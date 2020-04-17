import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/operation_detail.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
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

  List<dynamic> _listaOperations;
  OperationTotalModel _operationsTotal;

  HijoModel _currentChildSelected;

  String idAnho;

  @override
  void initState() {
    print('initState --------->');
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

    this._listaOperations = [];
    var queryParameters = {
      'id_anho': this.idAnho,
      'id_alumno': this._currentChildSelected.idAlumno,
    };
    await this
        .portalPadresService
        .getEstadoCuenta$(queryParameters)
        .then((onValue) {
      _listaOperations = onValue?.movements ?? [];
      _operationsTotal = onValue.movementsTotal;
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
        child: _listaOperations == null ||
                _listaOperations == [] ||
                _listaOperations.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: new EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    new Card(
                      child: Container(
                        padding: new EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: new RichText(
                            text: new TextSpan(
                          style: new TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                              text: 'SU SALDO ES: ',
                              style: new TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3),
                            ),
                            new TextSpan(
                                text: '${_operationsTotal?.total ?? ''}',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ],
                        )),
                      ),
                    ),
                    Expanded(
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
