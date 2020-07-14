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
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';

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
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  String url = "";

  double progress = 0;

  Future<bool> _onWillPop() async {
    flutterWebviewPlugin.hide();

    bool response = (await showDialog(
          context: context,
          builder: (context) => new CustomDialog(
            title: '¡ALERTA!',
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                child: Text(
                  'No regrese hacia atrás si aún no ha terminado con la operación\n¿Desea regresar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                ),
              ),
            ],
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('No',
                    style: TextStyle(color: LambThemes.light.primaryColor)),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('Sí',
                    style: TextStyle(color: LambThemes.light.primaryColor)),
              ),
            ],
          ),
        )) ??
        false;
    if (response == false) flutterWebviewPlugin.show();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarLamb(
          /*leading: IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: _onWillPop,
        ),*/
          title: Text('Pago con VISA'),
          bottomTitle: '¡ALERTA!',
          bottomSubtitle:
              'No regrese hacia atrás si aún no ha terminado con la operación',
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
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: WebviewScaffold(
                    withJavascript: true,
                    appCacheEnabled: true,
                    hidden: false,
                    //  initialChild: Container(
                    //     color: LambThemes.light.backgroundColor,
                    //     child: const Center(
                    //       child: Text('Cargando.....'),
                    //     ),
                    //   ),
                    url: new Uri.dataFromString(_loadHTML(),
                            mimeType: 'text/html')
                        .toString(),
                  ),
                ),
              ),
            ],
          ),
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
        this.widget.listaOperationsSaldo.map((item) => item.idVenta ?? '0').join('|');
    var importes =
        this.widget.listaOperationsSaldo.map((item) => item.saldo ?? '0').join('|');
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
