import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class VisapaymentService extends VitHttpService {
  Future<dynamic> tokens$(Map<String, dynamic> postParams) async {
    try {
      print(postParams);
      http.Response res = await httpPost('/visapayment/tokens', postParams);
      print('postParams');
      final body = jsonDecode(res.body);
      print(res.body);
      if (res.statusCode == 200) {
        final data = body['data'];
        return '$data';
      }
    } catch (e) {
      throw ("Can't save tokens: $e");
    }

    // try {
    //   var uri = new Uri.http(
    //       '$baseUrl', '$intermediateUrl/visapayment/tokens');
    //   http.Response res = await lambHttp.post(uri, body: postParams);
    //   final body = jsonDecode(res.body);
    //   if (res.statusCode == 200) {
    //     final data = body['data'];
    //     return '$data';
    //   }
    // } catch (e) {
    //   throw ("Can't save tokens: $e");
    // }
  }
}
