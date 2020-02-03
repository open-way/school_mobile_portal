import 'package:flutter/foundation.dart';

class PeriodoModel {
  final String idPeriodo;
  final String nombre;

  PeriodoModel({
    @required this.idPeriodo,
    @required this.nombre,
  });

  factory PeriodoModel.fromJson(Map<String, dynamic> json) {
    return PeriodoModel(
      idPeriodo: json['id_periodo'] as String,
      nombre: json['nombre'] as String,
    );
  }

  static List<PeriodoModel> getPeriodos() {
    return <PeriodoModel>[
      PeriodoModel(idPeriodo: '1', nombre: '2019'),
      PeriodoModel(idPeriodo: '2', nombre: '2020'),
    ];
  }
}
