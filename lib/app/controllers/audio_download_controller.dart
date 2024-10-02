import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedro_downloads/app/controllers/audio_player_controller.dart';
import 'package:pedro_downloads/app/controllers/history_controller.dart';
import 'package:pedro_downloads/app/models/download_type.dart';
import 'package:pedro_downloads/app/models/history_model.dart';
import 'package:pedro_downloads/app/pages/home/widgets/downloading_card.dart';
import 'package:pedro_downloads/app/src/limpar_nome_arquivo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:file_picker/file_picker.dart';
import '../services/youtube_explode_service.dart';

class AudioDownloadController extends ChangeNotifier {
  static final AudioDownloadController instance = AudioDownloadController();
  TextEditingController urlController = TextEditingController();
  TextEditingController pathController = TextEditingController();
  ValueNotifier<Video?> actualDownloadVideo = ValueNotifier(null);
  ValueNotifier<int> downloadsCount = ValueNotifier(0);
  ValueNotifier<int> downloadsProgress = ValueNotifier(0);
  ValueNotifier<int> actualAudioOrVideoDownloadedBytes = ValueNotifier(0);
  ValueNotifier<int> actualAudioOrVideoTotalBytes = ValueNotifier(0);
  ValueNotifier<bool> cancelDownload = ValueNotifier(false);
  ValueNotifier<DownloadType> downloadType = ValueNotifier(DownloadType.audio);

  void clearDownloadProgress() {
    actualDownloadVideo.value = null;
    downloadsCount.value = 0;
    downloadsProgress.value = 0;
    actualAudioOrVideoDownloadedBytes.value = 0;
    actualAudioOrVideoTotalBytes.value = 0;
    cancelDownload.value = false;
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void selectPath() async {
    try {
      String? aux = await FilePicker.platform.getDirectoryPath();
      if (aux != null) {
        pathController.text = aux;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadAndSaveVideo(
    String url,
    String path,
  ) async {
    try {
      actualDownloadVideo.value =
          await YoutubeExplodeService.instance.getVideo(url);

      var yt = YoutubeExplode();
      var video = await yt.videos.get(url);
      var manifest = await yt.videos.streamsClient.getManifest(video.id);

      // Get video stream info (choose desired quality or highest bitrate)
      var videoStreamInfo = manifest.muxed.withHighestBitrate();

      // Set total bytes
      actualAudioOrVideoTotalBytes.value = videoStreamInfo.size.totalBytes;

      var videoTitle = limparNomeArquivo(
          await YoutubeExplodeService.instance.getVideoTitle(url));
      var file = File('$path/$videoTitle.mp4');
      await requestStoragePermission();
      var fileStream = file.openWrite();

      // Get the stream and update progress
      var videoStream = yt.videos.streamsClient.get(videoStreamInfo);

      int downloadedBytes = 0;
      await for (final data in videoStream) {
        if (cancelDownload.value) {
          // Cancel download
          break;
        }
        downloadedBytes += data.length;
        actualAudioOrVideoDownloadedBytes.value = downloadedBytes;
        fileStream.add(data);
      }
      if (cancelDownload.value) {
        // If download was cancelled, delete the incomplete file
        await fileStream.close();
        await file.delete();
        yt.close();
        return;
      }

      await fileStream.flush();
      await fileStream.close();
      yt.close();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadVideo(BuildContext context) async {
    if (urlController.text.isEmpty || pathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: DownloadingCard(),
        ),
      );

      await downloadAndSaveVideo(
        urlController.text,
        pathController.text,
      );
      if (cancelDownload.value) {
        clearDownloadProgress();
        return;
      }
      DateTime data = DateTime.now();
      var nome = await YoutubeExplodeService.instance
          .getVideoTitle(urlController.text);
      await HistoryController.instance.addToHistory(
        HistoryModel(
          url: urlController.text,
          path: pathController.text,
          nome: nome,
          tipo: 'Video',
          data: '${data.day}/${data.month}/${data.year}',
        ),
      );
      await AudioPlayerController.instance.downloadCompleted();
      clearDownloadProgress();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
      clearDownloadProgress();
      return;
    }
  }

  Future<void> downloadAndSaveAudio(
    String url,
    String path,
  ) async {
    try {
      actualDownloadVideo.value =
          await YoutubeExplodeService.instance.getVideo(url);

      var yt = YoutubeExplode();
      var video = await yt.videos.get(url);
      var manifest = await yt.videos.streamsClient.getManifest(video.id);

      // Get audio stream info
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();

      // Set total bytes
      actualAudioOrVideoTotalBytes.value = audioStreamInfo.size.totalBytes;

      var audioTitle = limparNomeArquivo(
          await YoutubeExplodeService.instance.getVideoTitle(url));
      var file = File('$path/$audioTitle.mp3');
      await requestStoragePermission();
      var fileStream = file.openWrite();

      // Get the stream and update progress
      var audioStream = yt.videos.streamsClient.get(audioStreamInfo);

      int downloadedBytes = 0;
      await for (final data in audioStream) {
        if (cancelDownload.value) {
          // Cancel download
          break;
        }

        downloadedBytes += data.length;
        actualAudioOrVideoDownloadedBytes.value = downloadedBytes;
        fileStream.add(data);
      }

      if (cancelDownload.value) {
        // If download was cancelled, delete the incomplete file
        await fileStream.close();
        await file.delete();
        yt.close();
        return;
      }

      await fileStream.flush();
      await fileStream.close();
      yt.close();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadAudio(BuildContext context) async {
    if (urlController.text.isEmpty || pathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: DownloadingCard(),
        ),
      );
      await downloadAndSaveAudio(
        urlController.text,
        pathController.text,
      );
      if (cancelDownload.value) {
        clearDownloadProgress();
        return;
      }
      DateTime data = DateTime.now();
      var nome = await YoutubeExplodeService.instance
          .getVideoTitle(urlController.text);
      await HistoryController.instance.addToHistory(
        HistoryModel(
          nome: nome,
          url: urlController.text,
          path: pathController.text,
          data: '${data.day}/${data.month}/${data.year}',
          tipo: 'audio',
        ),
      );
      await AudioPlayerController.instance.downloadCompleted();
      clearDownloadProgress();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
      clearDownloadProgress();
      return;
    }
  }

  Future<void> downloadVideoPlaylist(BuildContext context) async {
    if (urlController.text.isEmpty || pathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: DownloadingCard(),
        ),
      );
      var yt = YoutubeExplode();
      var playlist = await yt.playlists.get(urlController.text);
      var videos = await yt.playlists.getVideos(playlist.id).toList();
      downloadsCount.value = videos.length;

      for (var video in videos) {
        if (cancelDownload.value) {
          clearDownloadProgress();
          cancelDownload.value = false;
          yt.close();
          return;
        }
        await downloadAndSaveVideo(video.url, pathController.text);
        downloadsProgress.value++;
      }

      DateTime data = DateTime.now();
      var nome = playlist.title;
      await HistoryController.instance.addToHistory(
        HistoryModel(
          nome: nome,
          url: urlController.text,
          path: pathController.text,
          data: '${data.day}/${data.month}/${data.year}',
          tipo: 'Video playlist',
        ),
      );
      await AudioPlayerController.instance.downloadCompleted();
      clearDownloadProgress();
      yt.close();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
      clearDownloadProgress();
      return;
    }
  }

  Future<void> downloadAudioPlaylist(BuildContext context) async {
    if (urlController.text.isEmpty || pathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: DownloadingCard(),
        ),
      );
      var yt = YoutubeExplode();
      var playlist = await yt.playlists.get(urlController.text);
      var videos = await yt.playlists.getVideos(playlist.id).toList();
      downloadsCount.value = videos.length;

      for (var video in videos) {
        if (cancelDownload.value) {
          clearDownloadProgress();
          cancelDownload.value = false;
          yt.close();
          return;
        }
        await downloadAndSaveAudio(video.url, pathController.text);
        downloadsProgress.value++;
      }

      DateTime data = DateTime.now();
      var nome = playlist.title;
      await HistoryController.instance.addToHistory(
        HistoryModel(
          nome: nome,
          url: urlController.text,
          path: pathController.text,
          data: '${data.day}/${data.month}/${data.year}',
          tipo: 'Audio playlist',
        ),
      );
      await AudioPlayerController.instance.downloadCompleted();
      clearDownloadProgress();
      yt.close();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
      clearDownloadProgress();
      return;
    }
  }
}
