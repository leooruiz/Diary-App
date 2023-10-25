import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(BuildContext context,
    {String title = "Atenção!",
    String content = "Você realmente deseja executar essa operação?",
    String affirmativeOption = "Confirmar",
    String cancel = "cancelar"}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context,
                  false); // passamos um parametro dentro do pop, que será usado no .then para confirmar se apagará ou não com true or false.
            },
            child: Text(
              "Cancelar".toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              affirmativeOption.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.brown),
            ),
          )
        ],
      );
    },
  );
}
