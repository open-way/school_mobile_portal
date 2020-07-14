import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/operation_detail.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/saldo_documentos_page.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/services/visapayment.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/widgets/filter_anho_dialog.dart';

class EstadoCuentaPage extends StatefulWidget {
  static const String routeName = '/estado_cuenta';

  EstadoCuentaPage({Key key, @required this.storage}) : super(key: key);
  final FlutterSecureStorage storage;

  @override
  _EstadoCuentaPageState createState() => _EstadoCuentaPageState();
}

class _EstadoCuentaPageState extends State<EstadoCuentaPage> {
  final PortalPadresService portalPadresService = new PortalPadresService();
  final VisapaymentService visapaymentService = new VisapaymentService();
  List<dynamic> _listaOperations;
  // OperationTotalModel _operationsTotal;
  String _infoTotalSaldo;
  dynamic _totalSaldo;
  dynamic _colorSaldo;

  HijoModel _currentChildSelected;

  String idAnho;

  @override
  void initState() {
    // print('initState --------->');
    super.initState();
    this._loadMaster();
  }

  Future _loadMaster() async {
    await this._loadChildSelectedStorageFlow();
    // Usar todos los metodos que quieran al hijo actual.
    this.getOperations();
  }

  getOperations() async {
    var now = new DateTime.now();
    this.idAnho = this.idAnho ?? now.year.toString();

    //this._listaOperations = [];
    var queryParameters = {
      'id_anho': this.idAnho,
      'id_alumno': this._currentChildSelected.idAlumno,
    };
    await this
        .portalPadresService
        .getEstadoCuenta$(queryParameters)
        .then((onValue) {
      _listaOperations = onValue?.movements ?? [];
      _infoTotalSaldo = onValue.movementsInfoTotal;
      _totalSaldo = onValue.movementsTotal;
      _colorSaldo = onValue.saldoColor;
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

  Future<Null> _handleRefresh() async {
    this.getOperations();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          this._currentChildSelected = childSelected;
          this.getOperations();
          setState(() {});
        },
      ),
      appBar: AppBarLamb(
        title: Text('ESTADO DE CUENTA'),
        alumno: this._currentChildSelected,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDialog,
          ),
        ],
      ),
      body: new RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _listaOperations == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: new EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /*new Card(
                          child:*/
                        new Container(
                          //width: double.infinity,
                          padding: new EdgeInsets.all(15),
                          alignment: Alignment.center,
                          child: _listaOperations == [] ||
                                  _listaOperations.isEmpty
                              ? Text('Sin resultados',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15))
                              : new RichText(
                                  textAlign: TextAlign.center,
                                  text: new TextSpan(
                                    style: new TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: _infoTotalSaldo,
                                        style: new TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 3),
                                      ),
                                      new TextSpan(
                                          text: 'S/. ${_totalSaldo.toString()}',
                                          style: new TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(_colorSaldo),
                                          )),
                                    ],
                                  )),
                        ),
                        //),
                        _listaOperations == [] || _listaOperations.isEmpty
                            ? Text('Sin resultados',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15))
                            : new FloatingActionButton.extended(
                                isExtended: true,
                                autofocus: false,
                                elevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                hoverElevation: 0,
                                disabledElevation: 0,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SaldoDocumentosPage(
                                      storage: widget.storage,
                                    ),
                                  ),
                                ),
                                label: Text(
                                  'PAGAR',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 2.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new Container(
                          padding: new EdgeInsets.all(5),
                          child: new OperationsList(
                            listaOperations: this._listaOperations,
                          ),
                        ),
                      ),
                    ),
                    /*SizedBox(height: 5),
                    new FloatingActionButton.extended(
                      isExtended: false,
                      autofocus: false,
                      elevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      disabledElevation: 0,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SaldoDocumentosPage(
                            storage: widget.storage,
                          ),
                        ),
                      ),
                      label: Text(
                        'PAGAR',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
      ),
    );
  }

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
}

class OperationsList extends StatefulWidget {
  final List<dynamic> listaOperations;

  OperationsList({Key key, @required this.listaOperations}) : super(key: key);
  @override
  _OperationsListState createState() => _OperationsListState();
}

class _OperationsListState extends State<OperationsList> {
  @override
  void initState() {
    super.initState();
  }

  Color zero = LambThemes.light.primaryColorLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: new ListView(
        children: widget.listaOperations
            .map((dynamic operacion) => getOperation(operacion))
            .toList(),
      ),
    );
  }

  Widget getOperation(operacion) {
    return Container(
      color: operacion['fila_color'] == '0' ? zero : null,
      child: ListTile(
        title: Text(operacion['glosa']),
        subtitle: Text("${operacion['fecha']}"),
        trailing: Text(
          'S/. ${operacion['total'].toString()}',
          style: TextStyle(
              color: Color(int.parse(operacion['total_color'])),
              fontWeight: FontWeight.bold),
        ),
        leading:
            CircleAvatar(child: Icon(Icons.check_box, size: 15), radius: 15),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OperationDetail(
              operation: operacion,
            ),
          ),
        ),
      ),
    );
  }
}
