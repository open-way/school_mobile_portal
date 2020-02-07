import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/periodo_contable_model.dart';
import 'package:school_mobile_portal/services/base.dart';

class PeriodosContablesService {
  final String theUrl = '$baseUrl/setup/periodos-contables';

  Future<List<PeriodoContableModel>> getAll$() async {
    http.Response res = await http.get(this.theUrl);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<PeriodoContableModel>((json) => PeriodoContableModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get periodos contables.";
    }
  }
}
