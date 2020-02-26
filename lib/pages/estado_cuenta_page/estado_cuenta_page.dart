import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/enum.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/filter_form_page.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/operation_detail.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

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

  @override
  void initState() {
    super.initState();
    this._loadMaster();
  }

  Future _loadMaster() async {
    await this._loadChildSelectedStorageFlow();

    // Usar todos los metodos que quieran al hijo actual.
    this._getOperations();
  }

  _getOperations() {
    _listaOperations = [];
    var queryParameters = {
      'id_anho': '2020',
      'id_alumno': this._currentChildSelected.idAlumno,
    };
    portalPadresService.getEstadoCuenta$(queryParameters).then((onValue) {
      _listaOperations = onValue?.movements ?? [];
      _operationsTotal = onValue.movementsTotal;
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  Future _loadChildSelectedStorageFlow() async {
    var childSelected = await widget.storage.read(key: 'child_selected');
    this._currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    setState(() {});
  }

  Future<Null> _handleRefresh() async {
    this._getOperations();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          this._currentChildSelected = childSelected;
          setState(() {});
        },
      ),
      appBar: AppBar(
        title: Text('Estado cuenta'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDialog,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: new Card(
              child: new Container(
                padding: new EdgeInsets.all(15),
                child: new RefreshIndicator(
                  child: new OperationsList(
                    listaOperations: this._listaOperations ?? [],
                  ),
                  onRefresh: _handleRefresh,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  Future _showDialog() async {
    switch (await showDialog(
      context: context,
      // child: new Center(
      //   child: new CircularProgressIndicator(),
      // )
      child: new SimpleDialog(
        title: new Text('Filtrar'),
        children: <Widget>[
          new FilterForm(
            idAlumno: this._currentChildSelected?.idAlumno ?? '',
          ),
        ],
      ),
    )) {
      // case DialogActions.SEARCH:
      //   this._getOperations();
      //   break;
      // case DialogActions.CANCEL:
      //   break;
      // case Answers.MAYBE:
      //   _setValue('Maybe');
      //   break;
    }
  }
  */

  Future _showDialog() async {
    ResponseDialogModel response = await showDialog(
      context: context,
      child: new SimpleDialog(
        title: new Text('Filtrar'),
        children: <Widget>[
          new FilterForm(
            idAlumno: this._currentChildSelected?.idAlumno ?? '',
          ),
        ],
      ),
    );

    switch (response?.action) {
      case DialogActions.SUBMIT:
        print(response.data);
        break;
      case DialogActions.CANCEL:
        break;
      default:
        print('default');
    }

// switch (response)
//       case DialogActions.SEARCH:
//         this._getOperations();
//         break;
//       case DialogActions.CANCEL:
//         break;
//       case Answers.MAYBE:
//         _setValue('Maybe');
//         break;

//     print('response');
//     print('response');
//     print(response);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(
        children: widget.listaOperations
            .map(
              (dynamic operacion) => ListTile(
                title: Text(operacion['glosa']),
                subtitle: Text("${operacion['fecha']}"),
                trailing: Text('S/. ${operacion['total'].toString()}'),
                leading: CircleAvatar(child: Icon(Icons.check_box)),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OperationDetail(
                      operation: operacion,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
