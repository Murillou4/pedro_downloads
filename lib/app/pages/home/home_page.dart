import 'package:flutter/material.dart';
import 'package:pedro_downloads/app/core/cores.dart';
import 'package:pedro_downloads/app/pages/home/home_controller.dart';
import 'package:pedro_downloads/app/pages/home/widgets/download_widget.dart';
import 'package:pedro_downloads/app/pages/home/widgets/history_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.background,
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: HomeController.instance.showHistory,
          builder: (context, value, child) {
            if (value) {
              return const HistoryWidget();
            } else {
              return const DownloadWidget();
            }
          },
        ),
      ),
    );
  }
}
