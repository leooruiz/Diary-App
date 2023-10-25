import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor implements InterceptorContract {
  Logger logger = Logger();
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    logger.i(
        "Requisição de ${data.baseUrl}\nCabeçalhos: ${data.headers}\nCorpo: ${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode ~/ 100 == 2) {
      logger.i(
          "Resposta de ${data.url}\nStatus da Resposta: ${data.statusCode}\nCabeçalhos: ${data.headers}\nCorpo: ${data.body}");
    } else {
      logger.e(
          "Resposta de ${data.url}\nStatus da Resposta: ${data.statusCode}\nCabeçalhos: ${data.headers}\nCorpo: ${data.body}");
    }
    return data;
  }
}
