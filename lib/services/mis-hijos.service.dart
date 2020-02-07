import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';

class MisHijosService {
  final String theUrl = '$baseUrl/setup/mis-hijos';

  Future<List<HijoModel>> getAll$() async {
    http.Response res = await http.get(this.theUrl);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data.map<HijoModel>((json) => HijoModel.fromJson(json)).toList();
    } else {
      throw "Can't get mis hijos.";
    }
  }
}
