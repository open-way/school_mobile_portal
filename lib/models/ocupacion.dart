import 'package:flutter/foundation.dart';

class OcupacionModel {
  final String idOcupacion;
  final String nombre;

  OcupacionModel({
    @required this.idOcupacion,
    @required this.nombre,
  });

  factory OcupacionModel.fromJson(Map<String, dynamic> json) {
    return OcupacionModel(
      idOcupacion: json['id_ocupacion'] as String,
      nombre: json['nombre'] as String,
    );
  }
}
