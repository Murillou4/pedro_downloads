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
      Stream<List<int>> videoStream =
          await YoutubeExplodeService.instance.getVideoStream(url);
      var videoTitle = await YoutubeExplodeService.instance.getVideoTitle(url);
      videoTitle = limparNomeArquivo(videoTitle);
      var file = File('$path/$videoTitle.mp4');
      await requestStoragePermission();
      var fileStream = file.openWrite();
      await videoStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();
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
      context.mounted ? Navigator.pop(context) : null;
    } catch (e) {
      context.mounted ? Navigator.pop(context) : null;
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            )
          : null;
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
      Stream<List<int>> audioStream =
          await YoutubeExplodeService.instance.getAudioStream(url);
      var audioTitle = await YoutubeExplodeService.instance.getVideoTitle(url);
      audioTitle = limparNomeArquivo(audioTitle);
      var file = File('$path/$audioTitle.mp3');
      await requestStoragePermission();
      var fileStream = file.openWrite();
      await audioStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();
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
      context.mounted ? Navigator.pop(context) : null;
    } catch (e) {
      context.mounted ? Navigator.pop(context) : null;
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            )
          : null;
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
      Stream<Video> aux =
          await YoutubeExplodeService.instance.getPlaylist(urlController.text);
      List<Video> size = await aux.toList();
      downloadsCount.value = size.length;
      Stream<Video> playlist =
          await YoutubeExplodeService.instance.getPlaylist(urlController.text);
      await for (Video video in playlist) {
        if (cancelDownload.value) {
          clearDownloadProgress();
          cancelDownload.value = false;
          return;
        }
        await downloadAndSaveVideo(video.url, pathController.text);
        downloadsProgress.value++;
      }
      DateTime data = DateTime.now();
      var nome = await YoutubeExplodeService.instance
          .getPlaylistTitle(urlController.text);
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
      context.mounted ? Navigator.pop(context) : null;
    } catch (e) {
      context.mounted ? Navigator.pop(context) : null;
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            )
          : null;
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
      Stream<Video> aux =
          await YoutubeExplodeService.instance.getPlaylist(urlController.text);
      List<Video> size = await aux.toList();
      downloadsCount.value = size.length;
      Stream<Video> playlist =
          await YoutubeExplodeService.instance.getPlaylist(urlController.text);
      await for (Video video in playlist) {
        if (cancelDownload.value) {
          clearDownloadProgress();
          cancelDownload.value = false;
          return;
        }
        await downloadAndSaveAudio(video.url, pathController.text);
        downloadsProgress.value++;
      }
      DateTime data = DateTime.now();
      var nome = await YoutubeExplodeService.instance
          .getPlaylistTitle(urlController.text);
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
      context.mounted ? Navigator.pop(context) : null;
    } catch (e) {
      context.mounted ? Navigator.pop(context) : null;
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            )
          : null;
      clearDownloadProgress();
      return;
    }
  }
}
