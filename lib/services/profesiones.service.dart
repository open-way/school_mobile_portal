import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/students_my_child_model.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class ProfesionesService extends VitHttpService {
  Future<List<StudentMyChildModel>> getAll$(
      Map<String, String> queryParams) async {
    print('ANTES==================>>>>>>');
    http.Response res =
        // await httpGetByQuery('/portal/saldo-documentos', queryParams);
        await httpGetByQuery('/setup/profesiones', queryParams);
    print('DESPUES==================>>>>>>');
    print(res.body.toString());
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

}
