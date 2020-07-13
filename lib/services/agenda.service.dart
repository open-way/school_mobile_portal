import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/agenda_model.dart';
import 'package:school_mobile_portal/models/agenda_category_model.dart';
import 'package:school_mobile_portal/models/periodo_academico_model.dart';
import 'package:school_mobile_portal/services/inteceptors/vit_http.service.dart';

class AgendaService extends VitHttpService {
  // get all periodo académico
  Future<List<PeriodoAcademicoModel>> getAllPeriodoEscolar(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/setup/list-periodo-escolar', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<PeriodoAcademicoModel>(
              (json) => PeriodoAcademicoModel.fromJson(json))
          .toList();
    } else {
      throw ("Can't get periodos academicos. $body");
    }
  }

  Future<List<AgendaCategoryModel>> getAgendaCategories() async {
    http.Response res = await httpGetAll('/setup/agenda-categories');
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AgendaCategoryModel>(
              (json) => AgendaCategoryModel.fromJson(json))
          .toList();
    } else {
      throw ("Can't get agenda categories. $body");
    }
  }

  // get agenda por alumno, periodo (ver portal-padres.service.dart)
  /*Future<List<AgendaModel>> getAgenda(Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/portal-padre/agendas', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AgendaModel>((json) => AgendaModel.fromJson(json))
          .toList();
    } else {
      throw ("Can't get agenda. $body");
    }
  }*/

  // get agenda por U C P, periodo
  Future<List<AgendaModel>> getAgendaConsolidado(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/portal-padre/agendas', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data
          .map<AgendaModel>((json) => AgendaModel.fromJson(json))
          .toList();
    } else {
      throw ("Can't get agenda. $body");
    }
  }

  //docente
  Future<List<dynamic>> getMyPeriodsStages(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/setup/my-periods-stages', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data.toList();
    } else {
      throw ("Can't get my periods stages. $body");
    }
  }

  Future<List<dynamic>> getMyPeriodsStagesGrades(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/setup/my-periods-stages-grades', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data.toList();
    } else {
      throw ("Can't get my periods stages grades. $body");
    }
  }

  Future<List<dynamic>> getMyPeriodsStagesGradesSections(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/setup/my-periods-stages-grades-sections', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data.toList();
    } else {
      throw ("Can't get my periods stages grades sections. $body");
    }
  }

  Future<List<dynamic>> getMyPeriodsStagesGradesAreas(
      Map<String, String> queryParams) async {
    http.Response res =
        await httpGetByQuery('/setup/my-periods-stages-grades-areas', queryParams);
    final body = jsonDecode(res.body);
    print(body.toString());
    if (res.statusCode == 200) {
      final data = body['data'].cast<Map<String, dynamic>>();
      return data.toList();
    } else {
      throw ("Can't get my periods stages grades areas. $body");
    }
  }
  //end docente
}
