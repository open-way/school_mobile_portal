import 'package:flutter/foundation.dart';

class HijoModel {
  final String idAlumno;
  final String nombre;
  final String paterno;
  final String materno;
  final String numDoc;
  final String institucionNombre;

  HijoModel({
    @required this.idAlumno,
    @required this.nombre,
    @required this.paterno,
    @required this.materno,
    @required this.numDoc,
    @required this.institucionNombre,
  });

  factory HijoModel.fromJson(Map<String, dynamic> json) {
    return HijoModel(
      idAlumno: json['id_alumno'] as String,
      nombre: json['nombre'] as String,
      paterno: json['paterno'] as String,
      materno: json['materno'] as String,
      numDoc: json['num_doc'] as String,
      institucionNombre: json['institucion_nombre'] as String,
    );
  }

  @override
  String toString() {
    return """
    {
      "id_alumno": "${this.idAlumno}", 
      "nombre" : "${this.nombre}", 
      "paterno" : "${this.paterno}", 
      "materno" : "${this.materno}",
      "num_doc" : "${this.numDoc}",
      "institucion_nombre" : "${this.institucionNombre}"
    }
    """;
  }
}
