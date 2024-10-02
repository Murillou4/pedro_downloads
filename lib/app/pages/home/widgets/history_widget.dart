import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pedro_downloads/app/core/cores.dart';
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    HomeController.instance.changeShowHistory();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Cores.textAndButtonColor,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await HistoryController.instance.clearHistory();
                  },
                  icon: const Icon(
                    Icons.cleaning_services_outlined,
                    color: Cores.textAndButtonColor,
                  ),
                )
              ],
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

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Cores.textAndButtonColor,
                                          width: 2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                          color: Cores.textAndButtonColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    Flexible(
                                        child: HistoryCard(history: history)),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(
                                    color: Cores.textAndButtonColor,
                                  ),
                                );
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
