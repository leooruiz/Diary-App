import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;

class JournalService {
  static const String resource = "journals/";
  String url = WebClient.url;
  http.Client client = WebClient().client;

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal =
        json.encode(journal.toMap()); //json encode converte o map em json
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    );
    if (response.statusCode != 201) {
      if (response.body == 'jwt expired') {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 200) {
      throw UnauthorizedUserException();
    }
    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }

  Future<bool> editJournal(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(
      journal.toMap(),
    );
    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    ); //json encode converte o map em json
    if (response.statusCode != 200) {
      if (response.body == 'jwt expired') {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> deleteJournal(String id, String token) async {
    http.Response response = await http.delete(Uri.parse('${getUrl()}$id'),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 200) {
      if (response.body == 'jwt expired') {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }
}

class UnauthorizedUserException implements Exception {}

class TokenNotValidException implements Exception {}
