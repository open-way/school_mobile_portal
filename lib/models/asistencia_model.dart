import 'package:flutter/foundation.dart';

class AsistenciaModel {
  final String periodoNombre;
  final String fecha;
  final String estado;
  final String responsable;
  final String puerta;
  final String jutificacionEstado;
  final String jutificacionMotivo;
  final String jutificacionDescripcion;

  AsistenciaModel({
    @required this.periodoNombre,
    @required this.fecha,
    @required this.estado,
    @required this.responsable,
    @required this.puerta,
    @required this.jutificacionEstado,
    @required this.jutificacionMotivo,
    @required this.jutificacionDescripcion,
  });

  factory AsistenciaModel.fromJson(Map<String, dynamic> json) {
    return AsistenciaModel(
      periodoNombre: json['periodo_nombre'] as String,
      fecha: json['fecha'] as String,
      estado: json['estado'] as String,
      responsable: json['responsable'] as String,
      puerta: json['puerta'] as String,
      jutificacionEstado: json['jutificacion_estado'] as String,
      jutificacionMotivo: json['jutificacion_motivo'] as String,
      jutificacionDescripcion: json['jutificacion_descripcion'] as String,
    );
  }
}
