import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/periodo_academico_model.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class PeriodosAcademicosService extends VitHttpService {
  Future<List<PeriodoAcademicoModel>> getAll$() async {
    http.Response res = await httpGetAll('/setup/periodos-academicos');

    print(res.body.toString());
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<PeriodoAcademicoModel>(
              (json) => PeriodoAcademicoModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get periodos contables.";
    }
  }

  Future<List<PeriodoAcademicoModel>> getAllLocal() async {
    String pres =
        '{"data":[{"id_anho":"1","nombre":"2020"},{"id_anho":"2","nombre":"2019"},{"id_anho":"3","nombre":"2018"}]}';
    Map<String, dynamic> res = await jsonDecode(pres);
    //http.Response res = await http.get(this.theUrl);
    if (jsonEncode(res) != null) {
      //if (res.statusCode == 200) {
      final body = res;
      //final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<PeriodoAcademicoModel>(
              (json) => PeriodoAcademicoModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get periodos contables.";
    }
  }
}
