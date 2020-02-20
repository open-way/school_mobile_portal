import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/services/inteceptors/token_interceptor.service.dart';

class VitHttpService {
  http.Client lambHttp = HttpClientWithInterceptor.build(interceptors: [
    TokenInterceptor(),
  ]);

  final String baseUrl = baseApiGeneral;
  final String intermediateUrl = intermediateApiGeneral;

  // Methods generals

  Future<dynamic> httpGetAll(String otherUrl) {
    var uri = new Uri.http(baseUrl, '$intermediateUrl$otherUrl');
    return lambHttp.get(uri);
  }

  Future<dynamic> httpGetByQuery(
      String otherUrl, Map<String, String> queryParams) {
    var uri = new Uri.http(baseUrl, '$intermediateUrl$otherUrl', queryParams);
    return lambHttp.get(uri);
  }

  Future<dynamic> httpGetById(
      String otherUrl, String id, Map<String, String> queryParams) {
    var uri =
        new Uri.http(baseUrl, '$intermediateUrl$otherUrl/$id', queryParams);
    return lambHttp.get(uri);
  }

  Future<dynamic> httpPost(String otherUrl, Map<String, dynamic> body) {
    var uri = new Uri.http(baseUrl, '$intermediateUrl$otherUrl');
    return lambHttp.post(uri, body: body);
  }

  Future<dynamic> httpPut(
      String otherUrl, String id, Map<String, dynamic> body) {
    var uri = new Uri.http(baseUrl, '$intermediateUrl$otherUrl/$id');
    return lambHttp.put(uri, body: body);
  }

  Future<dynamic> httpPatch(
      String otherUrl, String id, Map<String, dynamic> body) {
    var uri = new Uri.http(baseUrl, '$intermediateUrl$otherUrl/$id');
    return lambHttp.patch(uri, body: body);
  }

  Future<dynamic> httpDelete(String otherUrl, String id) {
    var uri = new Uri.http(baseUrl, '$intermediateUrl$otherUrl/$id');
    return lambHttp.delete(uri);
  }
}
