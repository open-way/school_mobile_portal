import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/services/inteceptors/lamb_http.service.dart';

class MisHijosService extends LambHttpService {
  final String theUrl = '$baseUrl/setup/mis-hijos';

  Future<List<HijoModel>> getAll$() async {
    http.Response res = await lambHttp.get(this.theUrl);
    print('=================');
    print(res.statusCode);
    if (res.statusCode == 200) {
      print('=================');
      print('=================');
      print(res.body.toString());
      final body = jsonDecode(res.body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data.map<HijoModel>((json) => HijoModel.fromJson(json)).toList();
    } else {
      throw "Can't get mis hijos.";
    }
  }
}
