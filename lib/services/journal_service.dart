import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:uuid/uuid.dart';

class JournalService {
  static const String url = "http://192.168.15.15:3000/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor()
  ]); //passamos um client para o http, para assim ter o acesso aos interceptadores quando uma requisição ou resposta for feita no servidor.

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    String jsonJournal =
        json.encode(journal.toMap()); //json encode converte o map em json
    // int userId = int.parse(const Uuid().v1());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {'Content-type': 'application/json'},
      body: jsonJournal,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    if (response.statusCode != 200) {
      throw Exception();
    }
    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }

  Future<bool> editJournal(String id, Journal journal) async {
    String jsonJournal = json.encode(
      journal.toMap(),
    );
    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {'Content-type': 'application/json'},
      body: jsonJournal,
    ); //json encode converte o map em json
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteJournal(String id) async {
    http.Response response = await http.delete(Uri.parse('${getUrl()}$id'));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
