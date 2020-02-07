import 'package:flutter/foundation.dart';

class PeriodoContableModel {
  final String idAnho;
  final String nombre;

  PeriodoContableModel({
    @required this.idAnho,
    @required this.nombre,
  });

  factory PeriodoContableModel.fromJson(Map<String, dynamic> json) {
    return PeriodoContableModel(
      idAnho: json['id_anho'] as String,
      nombre: json['nombre'] as String,
    );
  }

  // static List<PeriodoModel> getPeriodos() {
  //   return <PeriodoModel>[
  //     PeriodoModel(idPeriodo: '1', nombre: '2019'),
  //     PeriodoModel(idPeriodo: '2', nombre: '2020'),
  //   ];
  // }
}
