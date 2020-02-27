import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class JustificacionesService extends VitHttpService {
  Future postAll$(Map<String, String> postParams) async {
    http.Response res =
        await httpPost('/portal-padre/justificaciones', postParams);
    final body = jsonDecode(res.body);
    print(postParams.toString() +
        'JustificacionesService postParams !!!!!!!!!!!');
    print(body.toString() + 'JustificacionesService body !!!!!!!!!!!');
    if (res.statusCode == 200) {
      final data = body['data'];
      return data;
    } else {
      throw "Can't save justificaciones.";
    }
  }
}
