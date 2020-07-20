import 'package:flutter/foundation.dart';

class AgendaCategoryModel {
  final String idACategoria;
  final String nombre;
  final String color;

  AgendaCategoryModel({
    @required this.idACategoria,
    @required this.nombre,
    @required this.color,
  });

  factory AgendaCategoryModel.fromJson(Map<String, dynamic> json) {
    return AgendaCategoryModel(
      idACategoria: json['id_acategoria'] as String,
      nombre: json['nombre'] as String,
      color: json['color'] as String,
    );
  }
}
