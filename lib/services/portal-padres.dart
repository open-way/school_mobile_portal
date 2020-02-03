import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/services/base.dart';
// import 'dart:developer' as developer;

class PortalPadresService {
  final String theUrl = '${baseUrl}portal-padre';

  Future<List<OperationModel>> getEstadoCuenta() async {
    http.Response res = await http.get('$theUrl/mi-estado-cuenta');
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<OperationModel>((json) => OperationModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get operations.";
    }
  }

  Future<List<OperationModel>> getAsistencias() async {
    http.Response res = await http.get('$theUrl/asistencias');
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<OperationModel>((json) => OperationModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get asistencias.";
    }
  }

  Future<List<OperationModel>> get() async {
    http.Response res = await http.get('$theUrl/asistencias');
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<OperationModel>((json) => OperationModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get operations.";
    }
  }
}
