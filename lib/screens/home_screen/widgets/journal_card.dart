import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/logout.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  final int userId;
  const JournalCard({
    Key? key,
    this.journal,
    required this.showedDate,
    required this.refreshFunction,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(showedDate).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeJournal(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(224, 160, 11, 0),
                  )),
            ],
          ),
        ),
      );
    } else {
      //caso o card não estiver preenchido irá retornar essas informações:
      return InkWell(
        onTap: () {
          callAddJournalScreen(
              context); //caso clicada, executará a função de navegação nomeada
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Journal innerJournal = Journal(
        id: const Uuid().v1(),
        content: "",
        createdAt: showedDate,
        updatedAt: showedDate,
        userId: userId);

    Map<String, dynamic> map = {};

    if (journal != null) {
      innerJournal = journal;
      map['is_editing'] = false; //caso o journal não for nulo, criaremos
    } else {
      map['is_editing'] = true; //caso for nulo, editaremos
    }

    map['journal'] = innerJournal;

    Navigator.pushNamed(
      context,
      'add-journal',
      arguments: map,
    ).then((value) {
      refreshFunction();
      // o valor passado pelo navigator.pop do registro é utilizado aqui
      try {
        if (value != null && value == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registro criado com sucesso."),
            ),
          );
        } else if (value == false || value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Nada foi registrado."),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Algo deu errado."),
            ),
          );
        }
      } on Exception {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Houve uma falha no registro."),
          ),
        );
      }
    });
  }

  removeJournal(context) {
    JournalService service = JournalService();
    if (journal != null) {
      showConfirmationDialog(
        context,
        content:
            "Deseja realmente remover o diário do dia ${WeekDay(journal!.createdAt)}?",
        affirmativeOption: "Remover",
      ).then((value) {
        if (value != null) {
          if (value) {
            SharedPreferences.getInstance().then(
              (prefs) {
                String? token = prefs.getString("accessToken");
                if (token != null) {
                  service.deleteJournal(journal!.id, token).then(
                    (value) {
                      refreshFunction();
                    },
                  ).catchError((error) {
                    logout(context);
                  },
                      test: (error) =>
                          error is TokenNotValidException).catchError((error) {
                    var innerError = error as HttpException;
                    showExceptionDialog(context, content: innerError.message);
                  }, test: (error) => error is HttpException);
                }
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("O registro foi deletado com sucesso!")));
                }
              },
            );
          }
        }
      });
    }
  }
}
