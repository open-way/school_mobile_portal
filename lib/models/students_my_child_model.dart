import 'package:flutter/material.dart';

//           "id_pngrado": "137",
//           "cantidad_cupos": "4",
//           "tope_precio": null

class StudentMyChildModel {
  final String idAlumno;
  final String nombre;
  final String paterno;
  final String materno;
  final String nombreInstitucion;
  final String numDocumento;
  final String saldo;
  final String idReserva;
  final String estadoReserva;
  final String existePeriodo;
  final String nombreGrado;
  final String nombreNivel;
  final String idPngrado;
  final String cantidadVacantes;
  final String topePrecio;
  final String anho;

  StudentMyChildModel({
    @required this.idAlumno,
    @required this.nombre,
    @required this.paterno,
    @required this.materno,
    @required this.nombreInstitucion,
    @required this.numDocumento,
    @required this.saldo,
    @required this.idReserva,
    @required this.estadoReserva,
    @required this.existePeriodo,
    @required this.nombreGrado,
    @required this.nombreNivel,
    @required this.idPngrado,
    @required this.cantidadVacantes,
    @required this.topePrecio,
    @required this.anho,
  });

  factory StudentMyChildModel.fromJson(Map<String, dynamic> json) {
    return StudentMyChildModel(
      idAlumno: json['id_alumno'] as String,
      nombre: json['nombre'] as String,
      paterno: json['paterno'] as String,
      materno: json['materno'] as String,
      nombreInstitucion: json['nombre_institucion'] as String,
      numDocumento: json['num_documento'] as String,
      saldo: json['saldo'] as String,
      idReserva: json['id_reserva'] as String,
      estadoReserva: json['estado_reserva'] as String,
      existePeriodo: json['existe_periodo'] as String,
      nombreGrado: json['nombre_grado'] as String,
      nombreNivel: json['nombre_nivel'] as String,
      idPngrado: json['id_pngrado'] as String,
      cantidadVacantes: json['cantidad_vacantes'] as String,
      topePrecio: json['tope_precio'] as String,
      anho: json['anho'] as String,
    );
  }
}
