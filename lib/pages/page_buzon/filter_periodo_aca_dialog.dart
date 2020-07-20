import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/periodo_academico_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/services/agenda.service.dart';
//import 'package:school_mobile_portal/services/periodos-academicos.service.dart';

class FilterPeriodoEscolarDialog extends StatefulWidget {
  FilterPeriodoEscolarDialog({Key key, @required this.idPeriodoDefault})
      : super(key: key);
  //final String idAlumno;
  final String idPeriodoDefault;
  @override
  _FilterPeriodoEscolarDialogState createState() =>
      _FilterPeriodoEscolarDialogState();
}

class _FilterPeriodoEscolarDialogState
    extends State<FilterPeriodoEscolarDialog> {
  final AgendaService _periodoAcaService = new AgendaService();

  List<DropdownMenuItem<String>> _listaPeriodosAca;
  String idPeriodoAcademico;

  @override
  void initState() {
    super.initState();
    this.getMasters();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getMasters() {
    this.getAnhos();
    this.idPeriodoAcademico = widget.idPeriodoDefault;
  }

  void getAnhos() {
    if (this.widget.idPeriodoDefault.isNotEmpty) {
      /*var query = {
        'id_alumno': this.widget?.idAlumno,
      };*/
      this._periodoAcaService.getAllPeriodoEscolar({}).then((listSnap) {
        this._listaPeriodosAca = listSnap.map((PeriodoAcademicoModel snap) {
          return DropdownMenuItem(
            value: snap.idPeriodo,
            child: Text('${snap.nombre} ${snap.anhoPeriodo}'),
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
                labelText: 'Seleccione Período',
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: this.idPeriodoAcademico,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      this.idPeriodoAcademico = newValue;
                    });
                  },
                  items: this._listaPeriodosAca,
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
                if (this.idPeriodoAcademico != null) {
                  var responseDialog = new ResponseDialogModel(
                      action: DialogActions.SUBMIT,
                      data: this.idPeriodoAcademico);
                  Navigator.pop(context, responseDialog);
                }
                if (this.idPeriodoAcademico == null) {
                  var responseDialog = new ResponseDialogModel(
                      action: DialogActions.CANCEL,
                      data: this.idPeriodoAcademico);
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
