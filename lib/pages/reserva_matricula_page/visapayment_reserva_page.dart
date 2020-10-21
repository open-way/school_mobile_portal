import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/pages/reserva_matricula_page/reserva_matricula_page.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/portal.service.dart';
// import 'package:school_mobile_portal/models/saldo_documento.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';

class VisapaymentReservaPage extends StatefulWidget {
  final String idAlumno;
  final int idPersona;
  final String totalPagar;
  final String idReserva;
  final FlutterSecureStorage storage;
  // final List<SaldoDocumentoModel> listaOperationsSaldo;

  VisapaymentReservaPage({
    @required this.idAlumno,
    @required this.idPersona,
    @required this.totalPagar,
    @required this.idReserva,
    @required this.storage,
    // @required this.listaOperationsSaldo,
  });
  @override
  _VisapaymentReservaPageState createState() => _VisapaymentReservaPageState();
}

class _VisapaymentReservaPageState extends State<VisapaymentReservaPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  final PortalService portalService = new PortalService();
  // String url = "";

  // double progress = 0;

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
                  Navigator.pushReplacementNamed(context, Routes.reserva_matricula);
                  // Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return ReservaMatriculaPage(
                  //         storage: widget.storage,
                  //         portalService: portalService,
                  //       );
                  //     },
                  //   ),
                  // );
                 

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
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: WebviewScaffold(
                    withJavascript: true,
                    appCacheEnabled: true,
                    hidden: false,
                    withZoom: true,
                    initialChild: Container(
                      // color: Colors.redAccent,
                      child: const Center(
                        child: Text("Cargando...."),
                      ),
                    ),
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
    var payUrl = '${baseUrlWeb}visapayment/tokens-reserva';
    var idAplication = paymentReservaVisaId;
    print('----------------------------->');
    print(payUrl);
    print(idAplication);
    print('----------------------------->');
    // var idComprobante = '03';
    // var idsVentas =
    //     this.widget.listaOperationsSaldo.map((item) => item.idVenta ?? '0').join('|');
    // var importes =
    //     this.widget.listaOperationsSaldo.map((item) => item.saldo ?? '0').join('|');
    // var idsArticulos = this
    //     .widget
    //     .listaOperationsSaldo
    //     .map((item) => item.idArticulo)
    //     .join('|');

    var idAlumno = this.widget.idAlumno;
    var idClienteLegal = this.widget.idPersona;
    var idReserva = this.widget.idReserva;
    var importeTotal = this.widget.totalPagar;

    // <form id="f" name="f" method="post" action="">
    // return r'''
    // <input type="hidden" name="importe_total" value="$importeTotal" />
    // <input type="hidden" name="cod_transaccion" value="DA" />
    // <input type="hidden" name="id_comprobante" value="$idComprobante" />
    // <input type="hidden" name="ids_venta" value="$idsVentas" />
    // <input type="hidden" name="importes" value="$importes" />
    // <input type="hidden" name="ids_articulos" value="$idsArticulos" />
    // <input type="hidden" name="id_alumno" value="$idAlumno" />
    // <input type="hidden" name="id_cliente_legal" value="$idClienteLegal" />
    return '''
      <html>
        <body onload="document.f.submit();">
          <form id="f" name="f" method="post" action="$payUrl">
            <input type="hidden" name="id_reserva" value="$idReserva" />
            <input type="hidden" name="id_alumno" value="$idAlumno" />
            <input type="hidden" name="id_cliente_legal" value="$idClienteLegal" />
            <input type="hidden" name="id_aplicacion" value="$idAplication" />
            <input type="hidden" name="importe" value="$importeTotal" />
          </form>
        </body>
      </html>
    ''';
  }
}
