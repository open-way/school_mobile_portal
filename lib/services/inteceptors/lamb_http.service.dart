import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:school_mobile_portal/services/inteceptors/token_interceptor.service.dart';

class LambHttpService {
  http.Client lambHttp = HttpClientWithInterceptor.build(interceptors: [
    TokenInterceptor(),
  ]);
}
