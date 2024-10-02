import 'package:audioplayers/audioplayers.dart';

class AudioPlayerController {
  static final AudioPlayerController instance = AudioPlayerController();
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> downloadCompleted() async {
    await audioPlayer.play(AssetSource('download_completed.mp3'));
  }
}
