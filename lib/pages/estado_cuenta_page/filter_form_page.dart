import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/anho_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/enum.dart';
import 'package:school_mobile_portal/services/anhos.service.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';

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
    _anhosService.getAll$({}).then((listSnap) {
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
            // new DropdownButton(
            //   hint: new Text('Seleccione alumno'),
            //   value: this._idAlumno,
            //   isExpanded: true,
            //   onChanged: (String newValue) {
            //     setState(() {
            //       _idAlumno = newValue;
            //     });
            //   },
            //   items: _misHijos,
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
