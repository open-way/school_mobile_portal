import 'package:flutter/foundation.dart';

class OperationTotalModel {
  final String total;

  OperationTotalModel({
    @required this.total,
  });
}

class OperationModel {
  final String fecha;
  final String serie;
  final String numero;
  final String glosa;
  final String total;

  OperationModel({
    @required this.fecha,
    @required this.serie,
    @required this.numero,
    @required this.glosa,
    @required this.total,
  });
}

class EstadoCuentaModel {
  final List<OperationModel> movements;
  final OperationTotalModel movementsTotal;

  EstadoCuentaModel({
    @required this.movements,
    @required this.movementsTotal,
  });

  factory EstadoCuentaModel.fromJson(Map<String, dynamic> json) {
    return EstadoCuentaModel(
      movements: json['movements'] as List<OperationModel>,
      movementsTotal: json['movements_total'] as OperationTotalModel,
      // importe: json['importe'] as String,
    );
  }
}
