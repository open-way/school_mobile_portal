import 'package:flutter/foundation.dart';

// class OperationTotalModel {
//   final String total;

//   OperationTotalModel({
//     @required this.total,
//   });

//   factory OperationTotalModel.fromJson(Map<String, dynamic> json) {
//     return OperationTotalModel(
//       total: json['total'] as String,
//     );
//   }
// }

class SaldoDocumentoModel {
  final String idMes;
  final String glosa;
  final String fechaVencimiento;
  final String total;
  final String saldo;
  final String serie;
  final String numero;
  final String idVenta;
  final String idArticulo;
  bool checked;

  SaldoDocumentoModel({
    @required this.idMes,
    @required this.glosa,
    @required this.fechaVencimiento,
    @required this.total,
    @required this.saldo,
    @required this.serie,
    @required this.numero,
    @required this.idVenta,
    @required this.idArticulo,
    @required this.checked,
  });

  factory SaldoDocumentoModel.fromJson(Map<String, dynamic> json) {
    return SaldoDocumentoModel(
      idMes: json['id_mes'] as String,
      glosa: json['glosa'] as String,
      fechaVencimiento: json['fecha_vencimiento'] as String,
      total: json['total'] as String,
      saldo: json['saldo'] as String,
      serie: json['serie'] as String,
      numero: json['numero'] as String,
      idVenta: json['id_venta'] as String,
      idArticulo: json['id_articulo'] as String,
      checked: false,
    );
  }
}

// class EstadoCuentaModel {
//   final List<dynamic> movements;
//   final OperationTotalModel movementsTotal;

//   EstadoCuentaModel({
//     @required this.movements,
//     @required this.movementsTotal,
//   });

//   factory EstadoCuentaModel.fromJson(Map<String, dynamic> json) {
//     return EstadoCuentaModel(
//       movements: json['movements'] as List<dynamic>,
//       // movements: json['movements'].cast<Map<String, dynamic>>(),
//       // movements: json['movements'] as List<OperationModel>,
//       // movementsTotal: json['movements_total'] as OperationTotalModel,
//       movementsTotal: new OperationTotalModel.fromJson(json['movements_total']),
//     );
//   }
// }
