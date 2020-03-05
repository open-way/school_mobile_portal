import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/justificacion_motivo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/services/justificacion-motivos.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

class FormJustificacion extends StatefulWidget {
  FormJustificacion({Key key}) : super(key: key);
  @override
  _FormJustificacionState createState() => _FormJustificacionState();
}

class _FormJustificacionState extends State<FormJustificacion> {
  final JustificacionMotivosService _justificacionMotivosService =
      new JustificacionMotivosService();

  List<DropdownMenuItem<String>> _listaMotivos;
  String _idMotivo;

  final Map<String, String> _nombreMotivo = new Map();
  String _currentDescripcionJusti;
  TextEditingController _textController;
  ResponseDialogModel _responseDialog;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    this.getMasters();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void getMasters() {
    this.getMotivos();
  }

  void getMotivos() {
    this._justificacionMotivosService.getAll$().then((onValue) {
      this._idMotivo = onValue[0].idJmotivo;
      this._listaMotivos = onValue.map((JustificacionMotivoModel snap) {
        this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: snap.idJmotivo,
          child: Text(snap.nombre),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Seleccione motivo',
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: this._idMotivo,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      this._idMotivo = newValue;
                    });
                  },
                  items: this._listaMotivos,
                ),
              ),
            ),
          ),
          new TextField(
            controller: _textController,
            obscureText: false,
            scrollController: _scrollController,
            maxLength: 100,
            onSubmitted: (String newValue) =>
                {this._currentDescripcionJusti = newValue},
            decoration: InputDecoration(
                labelText: 'Descripción',
                counterStyle: TextStyle(color: LambThemes.light.primaryColor)),
            onChanged: (String newValue) =>
                {this._currentDescripcionJusti = newValue},
          ),
          new RaisedButton(
            onPressed: () => Future.delayed(Duration.zero, () async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Desea enviar justificación?'),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                              'Motivo: ${this._nombreMotivo[this._idMotivo]}.'),
                          Text('Descripcion: ${this._currentDescripcionJusti}.')
                        ],
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('CANCELAR',
                                style: TextStyle(
                                  color: LambThemes.light.primaryColor,
                                )),
                          ),
                          RaisedButton(
                            onPressed: () {
                              this._responseDialog = new ResponseDialogModel(
                                  action: DialogActions.SUBMIT,
                                  data: {
                                    'id_jmotivo': this._idMotivo,
                                    'descripcion': this._currentDescripcionJusti
                                  });
                              Navigator.pop(context);
                            },
                            child: Text('  SÍ  '),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
              Navigator.pop(context, _responseDialog);
            }),
            child: Text(
              '  ENVIAR  ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
