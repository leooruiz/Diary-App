import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class WebClient {
  static const String url = "http://192.168.15.18:3000/";
  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: const Duration(
      seconds: 5,
    ),
  ); //passamos um client para o http, para assim ter o acesso aos interceptadores quando uma requisição ou resposta for feita no servidor.
}
