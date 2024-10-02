import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pedro_downloads/app/models/history_model.dart';
import 'package:pedro_downloads/app/pages/home/home_controller.dart';
import 'package:pedro_downloads/app/pages/home/widgets/history_card.dart';
import 'package:pedro_downloads/app/services/shared_service.dart';

import '../../../controllers/history_controller.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 450,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    HomeController.instance.changeShowHistory();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: HistoryController.instance.historyList.isNotEmpty
                    ? AnimatedBuilder(
                        animation: HistoryController.instance,
                        builder: (context, child) {
                          return SizedBox(
                            width: 450,
                            height: 170,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                                  HistoryController.instance.historyList.length,
                              itemBuilder: (context, index) {
                                HistoryModel history = HistoryController
                                    .instance.historyList[index];

                                return HistoryCard(history: history);
                              },
                              separatorBuilder: (context, index) {
                                return const Gap(10);
                              },
                            ),
                          );
                        })
                    : const Center(child: Text('No history')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
