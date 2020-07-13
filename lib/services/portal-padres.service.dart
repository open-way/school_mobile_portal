import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/agenda_model.dart';
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/models/saldo_documento.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class PortalPadresService extends VitHttpService {
  Future<EstadoCuentaModel> getEstadoCuenta$(
      Map<String, String> queryParams) async {
    // print('Hola estado de cuenta');
    http.Response res =
        await httpGetByQuery('/portal-padre/mi-estado-cuenta', queryParams);
    final body = jsonDecode(res.body);
    print(res.body.toString());
    if (res.statusCode == 200) {
      final data = EstadoCuentaModel.fromJson(body['data']);
      return data;
    } else {
      throw "Can't get estado de cuenta.";
    }
  }

  Future<List<SaldoDocumentoModel>> getSaldoDocumentos$(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/portal-padre/saldo-documentos', queryParams);
    print(res.body.toString());
    final body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<SaldoDocumentoModel>(
              (json) => SaldoDocumentoModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get sado de documentos.";
    }
  }

  Future<List<AsistenciaModel>> getAsistencias(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/portal-padre/asistencias', queryParams);

    final body = jsonDecode(res.body);
    // print(res.body.toString());

    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AsistenciaModel>((json) => AsistenciaModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get asistencias.";
    }
  }

  // get agenda por alumno, periodo
  Future<List<AgendaModel>> getAgenda(Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/portal-padre/agendas', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AgendaModel>((json) => AgendaModel.fromJson(json))
          .toList();
    } else {
      throw ("Can't get agenda. $body");
    }
  }
}
