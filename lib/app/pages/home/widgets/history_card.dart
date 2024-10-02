import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedro_downloads/app/controllers/history_controller.dart';
import 'package:pedro_downloads/app/core/cores.dart';
import 'package:pedro_downloads/app/models/history_model.dart';
import 'package:pedro_downloads/app/src/formatar_tam_max_path.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.history});
  final HistoryModel history;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Cores.textAndButtonColor,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(221, 151, 151, 151),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        color: Cores.background,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          
          title: Text(
            history.nome,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Cores.textAndButtonColor,
            ),
          ),
          subtitle: Text(
            '${formatarTamMaxPath(history.path)} - ${history.tipo}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Cores.textAndButtonColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              HistoryController.instance.removeFromHistory(history);
            },
            icon: const Icon(
              Icons.delete,
              color: Cores.textAndButtonColor,
            ),
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
            icon: const Icon(
              Icons.link,
              color: Cores.textAndButtonColor,
            ),
          ),
        ),
      ),
    );
  }
}
