import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pedro_downloads/app/controllers/audio_download_controller.dart';
import 'package:pedro_downloads/app/core/cores.dart';
import 'package:pedro_downloads/app/pages/home/widgets/botao_principal.dart';

class DownloadingCard extends StatelessWidget {
  const DownloadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 300,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Cores.background,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Baixando',
                style: TextStyle(
                  color: Cores.textAndButtonColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              Center(
                child: ListenableBuilder(
                  listenable:
                      AudioDownloadController.instance.actualDownloadVideo,
                  builder: (context, child) {
                    if (AudioDownloadController
                            .instance.actualDownloadVideo.value ==
                        null) {
                      return Container();
                    } else {
                      return SizedBox(
                        width: 250,
                        height: 50,
                        child: ListTile(
                          title: Text(
                            AudioDownloadController
                                .instance.actualDownloadVideo.value!.title,
                            style: const TextStyle(
                              color: Cores.textAndButtonColor,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            AudioDownloadController
                                .instance.actualDownloadVideo.value!.author,
                            style: const TextStyle(
                              color: Cores.textAndButtonColor,
                              fontSize: 12,
                            ),
                          ),
                          leading: Image.network(
                            AudioDownloadController.instance.actualDownloadVideo
                                .value!.thumbnails.mediumResUrl,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Gap(15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Progresso:',
                        style: TextStyle(
                          color: Cores.textAndButtonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(5),
                      ListenableBuilder(
                        listenable:
                            AudioDownloadController.instance.downloadsProgress,
                        builder: (context, child) {
                          return Text(
                            '${AudioDownloadController.instance.downloadsProgress.value}/',
                            style: const TextStyle(
                              color: Cores.textAndButtonColor,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                      ListenableBuilder(
                          listenable:
                              AudioDownloadController.instance.downloadsCount,
                          builder: (context, child) {
                            return Text(
                              '${AudioDownloadController.instance.downloadsCount.value}',
                              style: const TextStyle(
                                color: Cores.textAndButtonColor,
                                fontSize: 14,
                              ),
                            );
                          }),
                    ],
                  ),
                  const Gap(8),
                  ValueListenableBuilder<int>(
                    valueListenable: AudioDownloadController
                        .instance.actualAudioOrVideoDownloadedBytes,
                    builder: (context, downloadedBytes, child) {
                      final totalBytes = AudioDownloadController
                          .instance.actualAudioOrVideoTotalBytes.value;
                      double progress = 0.0;
                      if (totalBytes > 0) {
                        progress = downloadedBytes / totalBytes;
                      }
                      return SizedBox(
                        width: 250,
                        child: LinearProgressIndicator(
                          backgroundColor: Cores.textAndButtonColor,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Cores.background,
                          ),
                          value: progress,
                          color: Cores.textAndButtonColor,
                          minHeight: 5.0, // Optionally set the height
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Gap(15),
              BotaoPrincipal(
                text: 'Cancelar',
                textColor: Colors.white,
                onTap: () {
                  AudioDownloadController.instance.cancelDownload.value = true;
                  Navigator.of(context).pop();
                },
                color: Cores.textAndButtonColor,
                borderColor: Cores.textAndButtonColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
