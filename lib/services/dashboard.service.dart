import 'dart:convert';

//import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/dashboard_model.dart';
//import 'package:school_mobile_portal/enviroment.dev.dart';
//import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';
// import 'dart:developer' as developer;

class DashboardService {
  //final String theUrl = httpGetAll('/dashboard');

  Future<List<DashboardModel>> getDashboard() async {
    //http.Response res = await http.get('$theUrl');
    String pres =
        '{"data":[{"estado_cuenta_resumen":[{"importe":"78 297,93","texto":"USTED DEBE SETENTA Y OCHO MIL DOSCIENTOS NOVENTA Y SIENTE Y 93/100 SOLES","color":"0xFFFFCD32"}],"eventos":"5","asistencias":{"colores":{"puntual_color":"0xFF91CD32","tarde_color":"0xFFFFCD32","falta_color":"0xFFD22800","justificado_color":"0xFF0067B1"},"alumnos":[{"id_alumno":"1","nombre":"Juan David","puntual_valor":"24","tarde_valor":"21","falta_valor":"23","justificada_valor":"22"},{"id_alumno":"2","nombre":"Pepito Pancho","puntual_valor":"44","tarde_valor":"11","falta_valor":"33","justificada_valor":"12"}]}}]}';
    Map<String, dynamic> res = await jsonDecode(pres);
    //if (res.statusCode == 200) {
    if (jsonEncode(res) != null) {
      final body = res;
      //final body = jsonDecode(res.body);
      //print(body);
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<DashboardModel>((json) => DashboardModel.fromJson(json))
          .toList();
    } else {
      throw "Can't get dashboard.";
    }
  }
}
