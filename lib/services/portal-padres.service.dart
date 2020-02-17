import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/services/inteceptors/lamb_http.service.dart';

class PortalPadresService extends LambHttpService {
  final String theUrl = '$baseUrl/portal-padre';

  Future<List<OperationModel>> getEstadoCuenta$() async {
    http.Response res = await lambHttp.get('$theUrl/mi-estado-cuenta');
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

  // Promesa
  Future<List<AsistenciaModel>> getAsistencias() async {
    http.Response res = await lambHttp.get('$theUrl/asistencias');
    // String pres =
    //     '{"data":[{"periodo_nombre":"Año academico 2020","fecha":"01/02/2020 07:15","estado":"P","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Curso taller verano","fecha":"01/02/2020 07:16","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Año academico 2020","fecha":"02/02/2020 07:31","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 02","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Año academico 2020","fecha":"03/02/2020 07:35","estado":"F","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 02","jutificacion_estado":"","jutificacion_motivo":"","jutificacion_descripcion":""},{"periodo_nombre":"Año academico 2020","fecha":"04/02/2020 07:37","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"0","jutificacion_motivo":"Por problemas de Salud","jutificacion_descripcion":"Mi hijo y yo fuimos de al centro medico porque se desmayó."},{"periodo_nombre":"Año academico 2020","fecha":"05/04/2020 07:38","estado":"J","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"1","jutificacion_motivo":"Por problemas de Salud","jutificacion_descripcion":"Mi hijo y yo fuimos de al centro medico porque se desmayó."},{"periodo_nombre":"Año academico 2020","fecha":"05/04/2020 07:39","estado":"T","responsable":"Vitmar Aliaga Cruz","puerta":"Puerta 01","jutificacion_estado":"2","jutificacion_motivo":"Por problemas de Salud","jutificacion_descripcion":"Mi hijo y yo fuimos de al centro medico porque se desmayó."}]}';
    // Map<String, dynamic> res = await jsonDecode(pres);
    if (res.statusCode == 200) {
      // if (jsonEncode(res) != null) {
      // final body = res;
      final body = jsonDecode(res.body);
      //print(body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AsistenciaModel>((json) => AsistenciaModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get asistencias.";
    }
  }

  Future<List<OperationModel>> getAgenda() async {
    http.Response res = await lambHttp.get('$theUrl/agendas');
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
