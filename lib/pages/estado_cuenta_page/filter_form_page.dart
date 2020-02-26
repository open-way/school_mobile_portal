import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/anho_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
// import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/enum.dart';
import 'package:school_mobile_portal/services/anhos.service.dart';
// import 'package:school_mobile_portal/services/mis-hijos.service.dart';

class FilterForm extends StatefulWidget {
  FilterForm({Key key, @required this.currentChildSelected}) : super(key: key);
  final HijoModel currentChildSelected;
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();

  final AnhosService _anhosService = new AnhosService();

  // final MisHijosService _misHijosService = new MisHijosService();

  List<DropdownMenuItem<String>> _listaAnhos;
  // List<DropdownMenuItem<String>> _misHijos;
  // HijoModel _currentChildSelected;

  // String _idAlumno;
  String _idAnho;

  @override
  void initState() {
    //this._idAlumno = '203708';
    //this._idAnho = '1';
    super.initState();
    print('Hola mundo');
    this._getMasters();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // myController.dispose();
    super.dispose();
  }

  void _getMasters() {
    this._getAnhos();
    // this._getMisHijos();
  }

  void _getAnhos() {
    var query = {
      'id_alumno': this.widget?.currentChildSelected?.idAlumno.toString() ?? '',
    };
    _anhosService.getByQuery$(query).then((listSnap) {
      // int currentYear = new DateTime(year);
      var now = new DateTime.now();
      // print(now.year);
      this._idAnho = now.year.toString();

      _listaAnhos = listSnap.map((AnhoModel snap) {
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

  // void _getMisHijos() {
  //   _misHijosService.getAll$().then((listSnap) {
  //     _misHijos = listSnap.map((HijoModel snap) {
  //       return DropdownMenuItem(
  //         value: snap.idAlumno,
  //         child: Text(snap.nombre),
  //       );
  //     }).toList();

  //     setState(() {});
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

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
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Seleccione año',
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: this._idAnho,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        this._idAnho = newValue;
                      });
                    },
                    items: this._listaAnhos,
                  ),
                ),
              ),
            ),
            new SizedBox(
                width: double.infinity, // match_parent
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Filtrar'),
                  onPressed: () {
                    if (this._idAnho.isNotEmpty) {
                      Navigator.pop(context, DialogActions.SEARCH);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
