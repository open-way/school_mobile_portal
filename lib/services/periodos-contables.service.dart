import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/periodo_contable_model.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/services/inteceptors/lamb_http.service.dart';

class PeriodosContablesService extends LambHttpService {
  final String theUrl = '$baseUrl/setup/periodos-contables';

  Future<List<PeriodoContableModel>> getAll$() async {
    http.Response res = await lambHttp.get(this.theUrl);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<PeriodoContableModel>(
              (json) => PeriodoContableModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get periodos contables.";
    }
  }

  Future<List<PeriodoContableModel>> getAllLocal() async {
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
          .map<PeriodoContableModel>(
              (json) => PeriodoContableModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get periodos contables.";
    }
  }
}
