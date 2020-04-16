//import 'dart:convert';

//import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class InfoService extends VitHttpService {
  Future getVersion() async {
    /*try {
      http.Response res = await getAll('/portal-padre/version');
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final data = body['data'];
        return data;
      } else {
        print("Can't get version. ${res.statusCode}");
      }
    } catch (e) {
      print("Can't get version: $e");
    }*/
    return '';
  }
}
