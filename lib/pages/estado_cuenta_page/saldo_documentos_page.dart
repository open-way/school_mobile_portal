import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
//import 'package:school_mobile_portal/models/saldo_documento.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/visapayment_page.dart';
// import 'package:school_mobile_portal/models/operation_model.dart';
// import 'package:school_mobile_portal/models/response_dialog_model.dart';
// import 'package:school_mobile_portal/pages/estado_cuenta_page/operation_detail.dart';
// import 'package:school_mobile_portal/pages/estado_cuenta_page/visapayment_page.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
// import 'package:school_mobile_portal/services/visapayment.service.dart';
//import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
// import 'package:school_mobile_portal/widgets/drawer.dart';
// import 'package:school_mobile_portal/widgets/drawer.dart';
// import 'package:school_mobile_portal/widgets/filter_anho_dialog.dart';

class SaldoDocumentosPage extends StatefulWidget {
  // static const String routeName = '/estado_cuenta';

  // SaldoDocumentosPage({Key key, @required this.storage}) : super(key: key);
  SaldoDocumentosPage({Key key, @required this.storage}) : super(key: key);
  final FlutterSecureStorage storage;

  @override
  _SaldoDocumentosPageState createState() => _SaldoDocumentosPageState();
}

class _SaldoDocumentosPageState extends State<SaldoDocumentosPage> {
  final PortalPadresService portalPadresService = new PortalPadresService();
  // final VisapaymentService visapaymentService = new VisapaymentService();
  List<dynamic> _listaOperationsSaldo;
  // OperationTotalModel _operationsTotal;

  HijoModel _currentChildSelected;
  String _totalPagar = '0';
  UserSignInModel _currentUserLogged;

  String idAnho;

  @override
  void initState() {
    super.initState();
    this._loadMaster();
  }

  Future _loadMaster() async {
    await this._loadChildSelectedStorageFlow();
    await this._loadUserStorage();
    // Usar todos los metodos que quieran al hijo actual.
    this.getOperationSaldos();
  }

  getOperationSaldos() async {
    var now = new DateTime.now();
    this.idAnho = this.idAnho ?? now.year.toString();

    var queryParameters = {
      'id_anho': this.idAnho,
      'id_alumno': this._currentChildSelected.idAlumno,
    };
    await this
        .portalPadresService
        .getSaldoDocumentos$(queryParameters)
        .then((onValue) {
      // _listaOperationsSaldo = onValue?.movements ?? [];
      // print('_listaOperationsSaldo.toString()====>>');
      this._listaOperationsSaldo = onValue ?? [];
      // print('_listaOperationsSaldo.toString()====>>');
      // print(this._listaOperationsSaldo[0].checked);
      // _operationsTotal = onValue.movementsTotal;
    }).catchError((err) {
      print(err);
    });
    setState(() {});
  }

  Future _loadChildSelectedStorageFlow() async {
    var childSelected = await widget.storage.read(key: 'child_selected');
    this._currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    setState(() {});
  }

  Future _loadUserStorage() async {
    var userStorage = await widget.storage.read(key: 'user_sign_in');
    this._currentUserLogged =
        new UserSignInModel.fromJson(jsonDecode(userStorage));
    setState(() {});
  }

  Future<Null> _handleRefresh() async {
    this.getOperationSaldos();
    return null;
  }

  bool get _isDisabled {
    var valor = (double.parse(_totalPagar) <= 0) ? true : false;
    return valor;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // drawer: AppDrawer(
      //   storage: widget.storage,
      //   onChangeNewChildSelected: (HijoModel childSelected) {
      //     this._currentChildSelected = childSelected;
      //     // this.getOperations();
      //     setState(() {});
      //   },
      // ),
      appBar: AppBarLamb(
        title: Text('PAGO DE MENSUALIDADES'),
        alumno: this._currentChildSelected,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.filter_list),
        //     onPressed: _showDialog,
        //   ),
        // ],
      ),
      body: new RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _listaOperationsSaldo == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: new EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    new Card(
                      child: new Container(
                        padding: new EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: _listaOperationsSaldo == [] ||
                                _listaOperationsSaldo.isEmpty
                            ? Text('Sin resultados',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15))
                            : new RichText(
                                text: new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: 'IMPORTE A PAGAR: ',
                                    style: new TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 3),
                                  ),
                                  new TextSpan(
                                      // text: '${_operationsTotal?.total ?? ''}',
                                      text: _totalPagar,
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                ],
                              )),
                      ),
                    ),
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new Container(
                          padding: new EdgeInsets.all(5),
                          child: new OperationsListSaldo(
                            listaOperations: this
                                ._listaOperationsSaldo
                                // .map((oper) => oper)
                                .toList(),
                            onChangeTotal: (total) {
                              setState(() {
                                this._totalPagar = total.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        padding: new EdgeInsets.all(1),
                        alignment: Alignment.center,
                        child: new ButtonBar(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // GestureDetector(
                            //   child: Container(
                            //     width: 120,
                            //     height: 40,
                            //     decoration: BoxDecoration(
                            //       color: LambThemes.light.primaryColor,
                            //       image: DecorationImage(
                            //           image: NetworkImage(
                            //               'https://static-content.vnforapps.com/v1/img/bottom/visa.png')
                            //           // image: AssetImage(
                            //           //     "assets/background_button.png"),
                            //           // fit: BoxFit.cover),
                            //           // child: Text("clickMe") // button text
                            //           // )
                            //           ),
                            //     ),
                            //   ),
                            //   onTap: () {
                            //     print("you clicked my");
                            //   },
                            // ),
                            new RaisedButton(
                              child: new Text(
                                'PAGAR CON',
                              ),
                              onPressed: () => _isDisabled
                                  ? null
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VisapaymentPage(
                                          idAlumno: this
                                                  ._currentChildSelected
                                                  ?.idAlumno ??
                                              null,
                                          idPersona:
                                              _currentUserLogged?.idPersona ??
                                                  null,
                                          totalPagar: _totalPagar ?? 0,
                                          listaOperationsSaldo: this
                                                  ._listaOperationsSaldo
                                                  .where(
                                                      (item) => item?.checked)
                                                  .toList() ??
                                              [],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

/*
  Future _showDialog() async {
    if (this._currentChildSelected?.idAlumno != null) {
      ResponseDialogModel response = await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Filtrar'),
          children: <Widget>[
            new FilterAnhoDialog(
              idAlumno: this._currentChildSelected.idAlumno,
              idAnhoDefault: this.idAnho,
            ),
          ],
        ),
      );

      switch (response?.action) {
        case DialogActions.SUBMIT:
          print('SUBMIT');
          this.idAnho = response.data;
          this.getOperations();
          break;
        default:
          print('default');
      }
    }
  }
  */

}

class OperationsListSaldo extends StatefulWidget {
  final List<dynamic> listaOperations;
  final Function(int) onChangeTotal;

  OperationsListSaldo(
      {Key key, @required this.listaOperations, @required this.onChangeTotal})
      : super(key: key);
  @override
  _OperationsListSaldoState createState() => _OperationsListSaldoState();
}

class _OperationsListSaldoState extends State<OperationsListSaldo> {
  // List<bool> inputs = new List<bool>();

  @override
  void initState() {
    super.initState();
  }

  //Color zero = LambThemes.light.primaryColorLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: new ListView(
        children: widget.listaOperations
            .asMap()
            .entries
            .map((dynamic entry) =>
                getOperationSaldo(entry.value, entry.key + 1))
            .toList(),
      ),
    );
  }

  Widget getOperationSaldo(operacion, int count) {
    // print('===>>>');
    // print('===>>> ${operacion.idVenta}');
    // print('===>>> ${operacion.nombre}');
    // print('===>>>');
    String glosa = operacion.idVenta != null ??
            operacion.idVenta != '' ??
            operacion.idVenta != 'null'
        ? '[${operacion.serie}-${operacion.numero}] - ${operacion.nombre}'
            .toString()
        : operacion.nombre.toString();

    return CheckboxListTile(
      title: Text(glosa),
      value: operacion.checked,
      subtitle: Text('Fecha venc: ${operacion.fechaVencimiento}'),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool val) {
        setState(() {
          //operacion.checked = val;
          updateCheckList(count, val);
          this.actualizarImporteTotal();
        });
      },
      secondary: Text(
        'S/. ${operacion.total}',
        style: TextStyle(
          color: null,
          fontWeight: FontWeight.bold,
        ),
      ),
      // activeColor: LambThemes.light.primaryColor,
      // checkColor: LambThemes.light.primaryColor,
      dense: true,
      // trailing: Text(
      //   // 'S/. ${operacion['total'].toString()}',
      //   'S/. ${operacion.total}',
      //   style: TextStyle(
      //       // color: Color(int.parse(operacion['total_color'])),
      //       color: null,
      //       fontWeight: FontWeight.bold),
      // ),
      // leading:
      //     CircleAvatar(child: Icon(Icons.check_box, size: 15), radius: 15),
      // onTap: () => Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => OperationDetail(
      //       operation: operacion,
      //     ),
      //   ),
      // ),
      // ),
    );
  }

  void updateCheckList(int count, bool val) {
    if (val) {
      for (final oper in widget.listaOperations.take(count)) {
        oper.checked = val;
      }
    } else {
      for (final oper in widget.listaOperations.skip(count - 1)) {
        oper.checked = val;
      }
    }
  }

  void actualizarImporteTotal() {
    int total = 0;
    for (final oper in widget.listaOperations) {
      if (oper.checked) {
        total = total + int.parse(oper.total);
      }
    }
    this.widget.onChangeTotal(total);
  }
}
