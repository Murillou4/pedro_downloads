import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pedro_downloads/app/controllers/audio_download_controller.dart';
import 'package:pedro_downloads/app/core/cores.dart';
import 'package:pedro_downloads/app/models/download_type.dart';
import 'package:pedro_downloads/app/pages/home/home_controller.dart';
import 'package:pedro_downloads/app/pages/home/widgets/botao_principal.dart';
import 'package:pedro_downloads/app/pages/home/widgets/text_field_principal.dart';

class DownloadWidget extends StatelessWidget {
  const DownloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/logo.svg'),
        const Gap(20),
        TextFieldPrincipal(
          controller: AudioDownloadController.instance.pathController,
          labelText: 'Selecione a pasta',
          icon: Icons.folder_outlined,
          isReadOnly: true,
          onTap: AudioDownloadController.instance.selectPath,
        ),
        const Gap(15),
        TextFieldPrincipal(
          controller: AudioDownloadController.instance.urlController,
          labelText: 'Insira a URL',
          icon: Icons.link_outlined,
          isReadOnly: false,
          onTap: () {},
        ),
        const Gap(15),
        SizedBox(
          width: 350,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListenableBuilder(
                  listenable: AudioDownloadController.instance.downloadType,
                  builder: (context, value) {
                    return DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Cores.background,
                      iconEnabledColor: Cores.textAndButtonColor,
                      iconDisabledColor: Cores.textAndButtonColor,
                      style: const TextStyle(color: Cores.textAndButtonColor),
                      underline: const SizedBox(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      alignment: Alignment.center,
                      focusColor: Colors.transparent,
                      items: const [
                        DropdownMenuItem(
                          value: DownloadType.audio,
                          child: Text('Audio'),
                        ),
                        DropdownMenuItem(
                          value: DownloadType.video,
                          child: Text('Video'),
                        ),
                      ],
                      onChanged: (value) {
                        AudioDownloadController.instance.downloadType.value =
                            value as DownloadType;
                        value == DownloadType.video
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                      'Os videos serão baixados na maior qualidade disponiível!'),
                                ),
                              )
                            : null;
                      },
                      value:
                          AudioDownloadController.instance.downloadType.value,
                    );
                  }),
              BotaoPrincipal(
                text: 'Baixar',
                textColor: Cores.textAndButtonColor,
                onTap: () async {
                  AudioDownloadController.instance.downloadType.value ==
                          DownloadType.video
                      ? await AudioDownloadController.instance
                          .downloadVideo(context)
                      : await AudioDownloadController.instance
                          .downloadAudio(context);
                },
                color: Cores.background,
                borderColor: Cores.textAndButtonColor,
                hasShadow: false,
              ),
              const Gap(10),
              BotaoPrincipal(
                text: 'Baixar Playlist',
                textColor: Colors.white,
                onTap: () async {
                  AudioDownloadController.instance.downloadType.value ==
                          DownloadType.video
                      ? await AudioDownloadController.instance
                          .downloadVideoPlaylist(context)
                      : await AudioDownloadController.instance
                          .downloadAudioPlaylist(context);
                },
                color: Cores.textAndButtonColor,
                borderColor: Cores.textAndButtonColor,
              ),
            ],
          ),
        ),
        const Gap(15),
        InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            HomeController.instance.changeShowHistory();
          },
          child: Container(
            width: 70,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                'Ver Histórico',
                style: TextStyle(
                  color: Cores.textAndButtonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
