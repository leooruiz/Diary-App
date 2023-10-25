import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'http_interceptors.dart';

class AuthService {
  //TODO: Modularizar endpoint
  static const String url = "http://192.168.15.15:3000/";
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}login"), body: {
      'email': email,
      "password": password,
    });

    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFoundException();
      }
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);

    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse("${url}register"),
      body: {
        'email': email,
        "password": password,
      },
    );
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);

    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = jsonDecode(body);
    String token = map['accessToken'];
    String email = map['user']['email'];
    int id = map['user']['id'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setString('email', email);
    await prefs.setInt('id', id);

    String? tokenSalvo = prefs.getString('accessToken');
    String? emailSalvo = prefs.getString('email');
    int? idSalvo = prefs.getInt('id');
    print('$tokenSalvo\n $emailSalvo\n $idSalvo');
  }
}

class UserNotFoundException implements Exception {}
