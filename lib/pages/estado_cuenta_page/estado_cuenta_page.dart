import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/anho_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/operation_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/operation_detail.dart';
import 'package:school_mobile_portal/services/anhos.saervice.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class EstadoCuentaPage extends StatefulWidget {
  static const String routeName = '/estado_cuenta';

  EstadoCuentaPage({Key key, @required this.storage}) : super(key: key);
  final FlutterSecureStorage storage;

  @override
  _EstadoCuentaPageState createState() => _EstadoCuentaPageState();
}

enum DialogActions { SEARCH, CANCEL }

class _EstadoCuentaPageState extends State<EstadoCuentaPage> {
  final PortalPadresService portalPadresService = new PortalPadresService();

  List<OperationModel> _listaOperations;
  OperationTotalModel _operationsTotal;

  String _currentIdChildSelected;

  @override
  void initState() {
    super.initState();
    this._getMasters();
    this._loadChildSelectedStorageFlow();
  }

  void _getMasters() {
    this._getOperations();
  }

  void _getOperations() {
    _listaOperations = [];
    var queryParameters = {
      // 'estado': 'S',
      'id_anho': '2020',
      'id_cliente': '7677',
    };
    portalPadresService.getEstadoCuenta$(queryParameters).then((onValue) {
      _listaOperations = onValue.movements;
      _operationsTotal = onValue.movementsTotal;
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  void _loadChildSelectedStorageFlow() async {
    var idChildSelected = await widget.storage.read(key: 'id_child_selected');
    this._currentIdChildSelected = idChildSelected;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          this._currentIdChildSelected = childSelected.idAlumno;
          setState(() {});
        },
      ),
      appBar: AppBar(
        title: Text('Estado cuenta'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     _scaffoldKey.currentState.openDrawer();
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDialog,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Expanded(
          //   child: new FilterForm(),
          //   flex: 0,
          // ),
          Expanded(
            child: new OperationsList(
              listaOperations: this._listaOperations,
            ),
          ),
        ],
      ),
    );
  }

  Future _showDialog() async {
    switch (await showDialog(
      context: context,
      // child: new Center(
      //   child: new CircularProgressIndicator(),
      // )
      child: new SimpleDialog(
        title: new Text('Filtrar'),
        children: <Widget>[
          new FilterForm(),
        ],
      ),
    )) {
      case DialogActions.SEARCH:
        // this.estado =
        this._getOperations();
        break;
      case DialogActions.CANCEL:
        // _setValue('Cancel');
        break;
      // case Answers.MAYBE:
      //   _setValue('Maybe');
      //   break;
    }
  }
}

class FilterForm extends StatefulWidget {
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();

  final AnhosService _anhosService = new AnhosService();

  final MisHijosService _misHijosService = new MisHijosService();

  List<DropdownMenuItem<String>> _listaPeriodosContables;
  List<DropdownMenuItem<String>> _misHijos;

  String _idAlumno;
  String _idAnho;

  @override
  void initState() {
    //this._idAlumno = '203708';
    //this._idAnho = '1';
    super.initState();
    this._getMasters();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // myController.dispose();
    super.dispose();
  }

  void _getMasters() {
    this._getPeriodos();
    this._getMisHijos();
  }

  void _getPeriodos() {
    _anhosService.getAll$().then((listSnap) {
      _listaPeriodosContables = listSnap.map((AnhoModel snap) {
        return DropdownMenuItem(
          value: snap.idAnho,
          child: Text(snap.idAnho),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  void _getMisHijos() {
    _misHijosService.getAll$().then((listSnap) {
      _misHijos = listSnap.map((HijoModel snap) {
        return DropdownMenuItem(
          value: snap.idAlumno,
          child: Text(snap.nombre),
        );
      }).toList();

      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(15),
      // child: Card(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // new Title(
            //   child: Text('Filtros'),
            //   color: Colors.blue,
            // ),
            new DropdownButton(
              hint: new Text('Seleccione alumno'),
              value: this._idAlumno,
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  _idAlumno = newValue;
                });
              },
              items: _misHijos,
            ),
            // new Expanded(
            //   child:
            // new TextField(
            //   decoration: new InputDecoration(
            //       labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
            //   onChanged: (String newValue) {},
            // ),
            // ),
            new DropdownButton(
              hint: new Text('Seleccione un periodo'),
              value: this._idAnho,
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  this._idAnho = newValue;
                });
              },
              items: _listaPeriodosContables,
            ),
            new SizedBox(
                width: double.infinity, // match_parent
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Filtrar'),
                  onPressed: () {
                    if (this._idAlumno.isNotEmpty && this._idAnho.isNotEmpty) {
                      // if (this._idAlumno.isEmpty && this._idAnho.isEmpty) {
                      Navigator.pop(context, DialogActions.SEARCH);
                    }
                    // Navigator.pushReplacementNamed(context, Routes.estado_cuenta);
                    // if (_formKey.currentState.validate()) {}
                  },
                )),
          ],
        ),
      ),
    );
  }
}

/*
class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return new DropdownButton<String>(
      isExpanded: true,
      hint: new Text('Seleccione un periodo'),
      value: dropdownValue,
      underline: Container(
        height: 1,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['2019', '2020', '2021']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
*/

class OperationsList extends StatefulWidget {
  final List<OperationModel> listaOperations;

  OperationsList({Key key, @required this.listaOperations}) : super(key: key);
  @override
  _OperationsListState createState() => _OperationsListState();
}

class _OperationsListState extends State<OperationsList> {
  // bool _isSearching;

  @override
  void initState() {
    super.initState();
    // _isSearching = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: new Container(
          padding: new EdgeInsets.all(15),
          child: ListView(
            children: widget.listaOperations
                .map(
                  (OperationModel operacion) => ListTile(
                    title: Text(operacion.glosa),
                    subtitle: Text("${operacion.fecha}"),
                    trailing: Text('S/. ${operacion.total.toString()}'),
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
        ),
      ),
    );
  }
}
