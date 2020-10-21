import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/students_my_child_model.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class PortalService extends VitHttpService {
  Future<List<StudentMyChildModel>> getChilds$(
      Map<String, String> queryParams) async {
    http.Response res =
        // await httpGetByQuery('/portal/saldo-documentos', queryParams);
        await httpGetByQuery('/portal/students-my-childs', queryParams);
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<StudentMyChildModel>(
              (json) => StudentMyChildModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get students my childs.";
    }
  }

  Future postAll$(Map<String, String> postParams) async {
    try {
      var uri =
          new Uri.http('$baseUrl', '$intermediateUrl/portal/reservations');
      http.Response res = await lambHttp.post(uri, body: postParams);
      print('ReservationsService');
      print(res.toString());
      final body = jsonDecode(res.body);
      print(body.toString());
      if (res.statusCode == 200) {
        final data = body['data'];
        return '$data';
      }
    } catch (e) {
      throw ("Can't save Reservations: $e");
    }
  }

  Future updateParentStudents$(Map<String, dynamic> postParams) async {
    try {
      var uri =
          new Uri.http('$baseUrl', '$intermediateUrl/portal/parent-students');
      http.Response res = await lambHttp.post(uri, body: postParams);
      print('ReservationsService');
      print(res.toString());
      final body = jsonDecode(res.body);
      print(body.toString());
      if (res.statusCode == 200) {
        final data = body['data'];
        return '$data';
      }
    } catch (e) {
      throw ("Can't save Reservations: $e");
    }
  }

  Future<dynamic> getInfoParentStudent$(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/portal/parent-students', queryParams);
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      // final data = StudentMyChildModel.fromJson(body['data']);
      return body['data'];
    } else {
      throw "Can't get Parent Students.";
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

  // Future<List<SaldoDocumentoModel>> getSaldoDocumentos$(
  //     Map<String, String> queryParams) async {
  //   http.Response res =
  //       await httpGetByQuery('/portal-padre/saldo-documentos', queryParams);
  //   print(res.body.toString());
  //   final body = jsonDecode(res.body);

  //   if (res.statusCode == 200) {
  //     final data = body['data'].cast<Map<String, dynamic>>();
  //     return data
  //         .map<SaldoDocumentoModel>(
  //             (json) => SaldoDocumentoModel.fromJson(json))
  //         .toList();
  //   } else {
  //     throw "Can't get sado de documentos.";
  //   }
  // }

  // Future<List<AsistenciaModel>> getAsistencias(
  //     Map<String, String> queryParams) async {
  //   http.Response res =
  //       await httpGetByQuery('/portal-padre/asistencias', queryParams);

  //   final body = jsonDecode(res.body);
  //   // print(res.body.toString());

  //   if (res.statusCode == 200) {
  //     final data = body['data'].cast<Map<String, dynamic>>();
  //     return data
  //         .map<AsistenciaModel>((json) => AsistenciaModel.fromJson(json))
  //         .toList();
  //   } else {
  //     throw "Can't get asistencias.";
  //   }
  // }

  // // get agenda por alumno, periodo
  // Future<List<AgendaModel>> getAgenda(Map<String, String> queryParams) async {
  //   http.Response res =
  //       await httpGetByQuery('/portal-padre/agendas', queryParams);
  //   final body = jsonDecode(res.body);
  //   print(body.toString());
  //   if (res.statusCode == 200) {
  //     final data = body['data'].cast<Map<String, dynamic>>();
  //     return data
  //         .map<AgendaModel>((json) => AgendaModel.fromJson(json))
  //         .toList();
  //   } else {
  //     throw ("Can't get agenda. $body");
  //   }
  // }
}
