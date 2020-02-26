import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/anho_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
// import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/enum.dart';
import 'package:school_mobile_portal/services/anhos.service.dart';
// import 'package:school_mobile_portal/services/mis-hijos.service.dart';

class FilterForm extends StatefulWidget {
  FilterForm({Key key, @required this.idAlumno}) : super(key: key);
  final String idAlumno;
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  // final _formKey = GlobalKey<FormState>();

  final AnhosService _anhosService = new AnhosService();

  // final MisHijosService _misHijosService = new MisHijosService();

  List<DropdownMenuItem<String>> _listaAnhos;
  // List<DropdownMenuItem<String>> _misHijos;
  // HijoModel _currentChildSelected;

  // String _idAlumno;
  String _idAnho;

  @override
  void initState() {
    super.initState();
    this.getMasters();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // myController.dispose();
    super.dispose();
  }

  void getMasters() {
    this.getAnhos();
  }

  void getAnhos() {
    if (this.widget.idAlumno.isNotEmpty) {
      var query = {
        'id_alumno': this.widget?.idAlumno,
      };
      this._anhosService.getByQuery$(query).then((listSnap) {
        var now = new DateTime.now();
        this._idAnho = now.year.toString();
        this._listaAnhos = listSnap.map((AnhoModel snap) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(15),
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
                  var responseDialog = new ResponseDialogModel(
                      action: DialogActions.SUBMIT, data: this._idAnho);
                  Navigator.pop(context, responseDialog);
                }
              },
            ),
          ),
          new SizedBox(
            width: double.infinity, // match_parent
            child: RaisedButton(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Cancelar'),
              onPressed: () {
                if (this._idAnho.isNotEmpty) {
                  var responseDialog = new ResponseDialogModel(
                      action: DialogActions.CANCEL, data: this._idAnho);
                  Navigator.pop(context, responseDialog);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
