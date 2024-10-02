import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedro_downloads/app/controllers/history_controller.dart';
import 'package:pedro_downloads/app/models/history_model.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.history});
  final HistoryModel history;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          history.nome,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${history.path} - ${history.tipo}'),
        trailing: IconButton(
          onPressed: () {
            HistoryController.instance.removeFromHistory(history);
          },
          icon: const Icon(Icons.delete),
        ),
        leading: IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: history.url));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied to clipboard'),
              ),
            );
          },
          icon: const Icon(Icons.link),
        ),
      ),
    );
  }
}
