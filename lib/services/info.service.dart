import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/app_version.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class InfoService extends VitHttpService {
  Future<AppVersionModel> getVersion$(Map<String, String> queryParams) async {
    http.Response res = await httpGetByQuery('/setup/app-version', queryParams);
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final data = AppVersionModel.fromJson(body['data']);
      return data;
    } else {
      throw "Can't get app version.";
    }
  }

  // Future<EstadoCuentaModel> getEstadoCuenta$(
  //     Map<String, String> queryParams) async {
  //   // print('Hola estado de cuenta');
  //   http.Response res =
  //       await httpGetByQuery('/portal-padre/mi-estado-cuenta', queryParams);
  //   final body = jsonDecode(res.body);
  //   print(res.body.toString());
  //   if (res.statusCode == 200) {
  //     final data = EstadoCuentaModel.fromJson(body['data']);
  //     return data;
  //   } else {
  //     throw "Can't get estado de cuenta.";
  //   }
  // }
}
