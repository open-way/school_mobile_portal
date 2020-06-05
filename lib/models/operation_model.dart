import 'package:flutter/foundation.dart';

class OperationTotalModel {
  final String total;

  OperationTotalModel({
    @required this.total,
  });

  factory OperationTotalModel.fromJson(Map<String, dynamic> json) {
    return OperationTotalModel(
      total: json['total'] as String,
    );
  }
}

class OperationModel {
  final String fecha;
  final String serie;
  final String numero;
  final String glosa;
  final String total;
  final String totalColor;

  OperationModel({
    @required this.fecha,
    @required this.serie,
    @required this.numero,
    @required this.glosa,
    @required this.total,
    @required this.totalColor,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) {
    return OperationModel(
      fecha: json['fecha'] as String,
      serie: json['serie'] as String,
      numero: json['numero'] as String,
      glosa: json['glosa'] as String,
      total: json['total'] as String,
      totalColor: json['total_color'] as String,
    );
  }
}

class EstadoCuentaModel {
  final List<dynamic> movements;
  // final OperationTotalModel movementsTotal;
  final double movementsTotal;
  final String movementsInfoTotal;

  EstadoCuentaModel({
    @required this.movements,
    @required this.movementsTotal,
    @required this.movementsInfoTotal,
  });

  factory EstadoCuentaModel.fromJson(Map<String, dynamic> json) {
    return EstadoCuentaModel(
      movements: json['movements'] as List<dynamic>,
      // movements: json['movements'].cast<Map<String, dynamic>>(),
      // movements: json['movements'] as List<OperationModel>,
      // movementsTotal: json['movements_total'] as OperationTotalModel,
      // movementsTotal: new OperationTotalModel.fromJson(json['movements_total']),
      movementsInfoTotal: json['movements_info_total'] as String,
      movementsTotal: json['movements_total'] as double,
    );
  }
}
