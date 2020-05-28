import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/saldo_documento.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

class VisapaymentPage extends StatefulWidget {
  final String idAlumno;
  final int idPersona;
  final String totalPagar;
  final List<SaldoDocumentoModel> listaOperationsSaldo;

  VisapaymentPage({
    @required this.idAlumno,
    @required this.idPersona,
    @required this.totalPagar,
    @required this.listaOperationsSaldo,
  });
  @override
  _VisapaymentPageState createState() => _VisapaymentPageState();
}

class _VisapaymentPageState extends State<VisapaymentPage> {
  // InAppWebViewController webView;

  String url = "";

  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(operation['glosa']),
        // title: Text('Pago con VISA'),
        title: Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 10),
            child: Text('PAGO CON VISA')),
        centerTitle: true,
        bottom: PreferredSize(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      '¡ALERTA!',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'No regrese hacia atrás si aún no ha terminado con la operación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            preferredSize: Size(MediaQuery.of(context).size.width - 2, 45)),
        // actions: widget.actions,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Container(
            //   padding: EdgeInsets.all(20.0),
            //   child: Text(
            //       "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
            // ),
            // Container(
            //   padding: EdgeInsets.all(10.0),
            //   child: progress < 1.0
            //       ? LinearProgressIndicator(value: progress)
            //       : Container(),
            // ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: WebviewScaffold(
                  withJavascript: true,
                  appCacheEnabled: true,
                  hidden: true,
                  initialChild: Container(
                    color: LambThemes.light.backgroundColor,
                    child: const Center(
                      child: Text('Cargando.....'),
                    ),
                  ),
                  url:
                      new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                          .toString(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _loadHTML() {
    var baseUrlWeb = baseAllUrl.substring(0, baseAllUrl.length - 10);
    var payUrl = '${baseUrlWeb}visapayment/tokens';
    var idAplication = paymentVisaId;
    var idComprobante = '03';
    var idsVentas =
        this.widget.listaOperationsSaldo.map((item) => item.idVenta).join('|');
    var importes =
        this.widget.listaOperationsSaldo.map((item) => item.saldo).join('|');
    var idsArticulos = this
        .widget
        .listaOperationsSaldo
        .map((item) => item.idArticulo)
        .join('|');

    var idAlumno = this.widget.idAlumno;
    var idClienteLegal = this.widget.idPersona;
    var importeTotal = this.widget.totalPagar;

    // <form id="f" name="f" method="post" action="">
    // return r'''
    return '''
      <html>
        <body onload="document.f.submit();">
          <form id="f" name="f" method="post" action="$payUrl">
            <input type="hidden" name="importe_total" value="$importeTotal" />
            <input type="hidden" name="cod_transaccion" value="DA" />
            <input type="hidden" name="id_aplicacion" value="$idAplication" />
            <input type="hidden" name="id_comprobante" value="$idComprobante" />
            <input type="hidden" name="ids_venta" value="$idsVentas" />
            <input type="hidden" name="importes" value="$importes" />
            <input type="hidden" name="ids_articulos" value="$idsArticulos" />
            <input type="hidden" name="id_alumno" value="$idAlumno" />
            <input type="hidden" name="id_cliente_legal" value="$idClienteLegal" />
          </form>
        </body>
      </html>
    ''';
  }
}
