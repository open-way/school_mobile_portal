import 'package:flutter/foundation.dart';

class ReligionModel {
  final String idReligion;
  final String nombre;

  ReligionModel({
    @required this.idReligion,
    @required this.nombre,
  });

  factory ReligionModel.fromJson(Map<String, dynamic> json) {
    return ReligionModel(
      idReligion: json['id_religion'] as String,
      nombre: json['nombre'] as String,
    );
  }
}
