import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class JustificacionesService extends VitHttpService {
  Future postAll$(Map<String, String> postParams) async {
    try {
      http.Response res =
          await httpPost('/portal-padre/justificaciones', postParams);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final data = body['data'];
        return data;
      }
    } catch (e) {
      print("Can't save justificaciones: $e");
    }
  }
}
