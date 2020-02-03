import 'package:flutter/foundation.dart';

class OperationModel {
  final String glosa;
  final String fecha;
  final String importe;

  OperationModel({
    @required this.glosa,
    @required this.fecha,
    @required this.importe,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) {
    return OperationModel(
      glosa: json['glosa'] as String,
      fecha: json['fecha'] as String,
      importe: json['importe'] as String,
    );
  }
}
