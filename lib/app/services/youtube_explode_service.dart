import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeExplodeService {
  static final YoutubeExplodeService instance = YoutubeExplodeService();
  final yt = YoutubeExplode();

  Future<Video> getVideo(String url) async {
    return await yt.videos.get(url);
  }

  Future<Stream<List<int>>> getVideoStream(String url) async {
    StreamManifest manifest = await yt.videos.streamsClient.getManifest(url);
    var video = manifest.videoOnly.bestQuality;
    print(video.videoCodec);
    return yt.videos.streamsClient.get(video);
  }

  Future<Stream<List<int>>> getAudioStream(String url) async {
    StreamManifest manifest = await yt.videos.streamsClient.getManifest(url);
    AudioOnlyStreamInfo audio = manifest.audioOnly.withHighestBitrate();
    return yt.videos.streamsClient.get(audio);
  }

  Future<Stream<Video>> getPlaylist(String url) async {
    Playlist playlist = await yt.playlists.get(url);
    return yt.playlists.getVideos(playlist.id);
  }

  Future<String> getVideoTitle(String url) async {
    var video = await getVideo(url);
    return video.title;
  }

  Future<String> getPlaylistTitle(String url) async {
    Playlist playlist = await yt.playlists.get(url);
    return playlist.title;
  }

  dispose() {
    yt.close();
  }
}
