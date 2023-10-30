import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddJournalScreen extends StatelessWidget {
  //CRIAÇÃO DA TELA PÓS CLIQUE NO CARD
  final Journal journal;
  final bool isEditing;
  AddJournalScreen({super.key, required this.journal, required this.isEditing});
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(journal.createdAt).toString()),
        actions: [
          IconButton(
              onPressed: () {
                registerJournal(context);
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
      ), //.long criado em Weekday.dart porque queremos a data longa (Ex: ao invés de 'dom' será 'domingo')
    );
  }

  registerJournal(BuildContext context) async {
    SharedPreferences.getInstance().then(
      (prefs) {
        String? token = prefs.getString('accessToken');
        String content = _contentController.text;
        journal.content =
            content; //atualiza o valor de journal que era vazio, agora passa a ter um valor
        JournalService service = JournalService();
        if (token != null) {
          if (isEditing) {
            service.register(journal, token).then(
              (value) {
                Navigator.pop(context, value);
              },
            ).catchError((error) {
              logout(context);
            }, test: (error) => error is TokenNotValidException).catchError(
                (error) {
              var innerError = error as HttpException;
              showExceptionDialog(context, content: innerError.message);
            }, test: (error) => error is HttpException);
          } else {
            service.editJournal(journal.id, journal, token).then(
              (value) {
                Navigator.pop(context,
                    value); //é possível enviar um argumento pelo Navigator, que pode ser usado por quem chamou a tela, que neste caso é o journal_card
              },
            ).catchError((error) {
              logout(context);
            }, test: (error) => error is TokenNotValidException).catchError(
                (error) {
              var innerError = error as HttpException;
              showExceptionDialog(context, content: innerError.message);
            }, test: (error) => error is HttpException);
          }
        }
      },
    );
  }
}
