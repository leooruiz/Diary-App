import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class AddJournalScreen extends StatelessWidget {
  //CRIAÇÃO DA TELA PÓS CLIQUE NO CARD
  final Journal journal;
  AddJournalScreen({super.key, required this.journal});

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${WeekDay(journal.createdAt.weekday).long.toLowerCase()}  -  ${journal.createdAt.day}  |  ${journal.createdAt.month}  |  ${journal.createdAt.year}'),
        actions: [
          IconButton(
              onPressed: () {
                registerJournal();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ), //.long porque queremos a data longa (Ex: ao invés de 'dom' será 'domingo')
    );
  }

  registerJournal() {
    String content = _contentController.text;
    journal.content =
        content; //atualiza o valor de journal que era vazio, agora passa a ter um valor
    JournalService service = JournalService();
    service.register(journal);
  }
}
