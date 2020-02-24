import 'package:flutter/foundation.dart';

class AsistenciaModel {
  final String periodoNombre;
  final String fechaRegistro;
  final String estadoNombre;
  final String estadoColor;
  final String responsable;
  final String puerta;
  final String jutificacionEstado;
  final String jutificacionMotivo;
  final String jutificacionDescripcion;

  AsistenciaModel({
    @required this.periodoNombre,
    @required this.fechaRegistro,
    @required this.estadoNombre,
    @required this.estadoColor,
    @required this.responsable,
    @required this.puerta,
    @required this.jutificacionEstado,
    @required this.jutificacionMotivo,
    @required this.jutificacionDescripcion,
  });

  factory AsistenciaModel.fromJson(Map<String, dynamic> json) {
    return AsistenciaModel(
      periodoNombre: json['periodo_nombre'] as String,
      fechaRegistro: json['fecha_registro'] as String,
      estadoNombre: json['estado_nombre'] as String,
      estadoColor: json['estado_color'] as String,
      responsable: json['responsable'] as String,
      puerta: json['puerta'] as String,
      jutificacionEstado: json['jutificacion_estado'] as String,
      jutificacionMotivo: json['jutificacion_motivo'] as String,
      jutificacionDescripcion: json['jutificacion_descripcion'] as String,
    );
  }
}
