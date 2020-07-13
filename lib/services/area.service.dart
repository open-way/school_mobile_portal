import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class AreaService extends VitHttpService {
  // get all student evaluation grid
  Future<dynamic> getStudentsEvaluationsGrid(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/setup/students-evaluations-grid', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200 || res.statusCode == 202) {
      final data = body['data'];
      print(data.runtimeType.toString());
      if (data.runtimeType.toString() == 'List<dynamic>') {
        return data.cast<Map<String, dynamic>>().map((json) => (json)).toList();
      } else {
        return data;
      }
    } else {
      throw ("Can't get students evaluations grid. $body");
    }
  }
}
