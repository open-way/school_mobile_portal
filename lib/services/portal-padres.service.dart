import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/agenda_model.dart';
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class PortalPadresService extends VitHttpService {
  Future<List<OperationModel>> getEstadoCuenta$(Map<String, String> queryParams) async {
    http.Response res = await httpGetByQuery('/portal-padre/mi-estado-cuenta', queryParams);

    final body = jsonDecode(res.body);
    // print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<OperationModel>((json) => OperationModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get operations.";
    }
  }

  // Promesa
  Future<List<AsistenciaModel>> getAsistencias(
      Map<String, String> queryParams) async {
    http.Response res = await httpGetByQuery('/portal-padre/asistencias', queryParams);

    final body = jsonDecode(res.body);
    print(res.body.toString());

    if (res.statusCode == 200) {
      // String pres =
      //     '{"data":[{"periodo_nombre":"Año academico 2020","fecha":"01/02/2020 07:15","estado":"P","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Curso taller verano","fecha":"01/02/2020 07:16","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Año academico 2020","fecha":"02/02/2020 07:31","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 02","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Año academico 2020","fecha":"03/02/2020 07:35","estado":"F","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 02","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Año academico 2020","fecha":"04/02/2020 07:37","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"0","jutificacion_motivo":"Por problemas de Salud","jutificacion_descripcion":"Mi hijo y yo fuimos de al centro medico porque se desmayó."},{"periodo_nombre":"Año academico 2020","fecha":"05/04/2020 07:38","estado":"J","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"1","jutificacion_motivo":"Por problemas de Salud","jutificacion_descripcion":"Mi hijo y yo fuimos de al centro medico porque se desmayó."},{"periodo_nombre":"Año academico 2020","fecha":"05/04/2020 07:39","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"2","jutificacion_motivo":"Por problemas de Salud","jutificacion_descripcion":"Mi hijo y yo fuimos de al centro medico porque se desmayó."}]}';
      // Map<String, dynamic> res = await jsonDecode(pres);
      // if (jsonEncode(res) != null) {
      //   final body = res;
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AsistenciaModel>((json) => AsistenciaModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get asistencias.";
    }
  }

  Future<List<AgendaModel>> getAgenda(Map<String, String> queryParams) async {
    http.Response res = await httpGetByQuery('/portal-padre/agendas', queryParams);
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AgendaModel>((json) => AgendaModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get agenda.";
    }
  }
}
