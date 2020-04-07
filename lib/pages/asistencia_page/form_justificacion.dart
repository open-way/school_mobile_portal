import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  ResponseDialogModel _responseDialog =
      ResponseDialogModel(action: DialogActions.CANCEL, data: {});

  String _fileName = '';
  String _base64Image;

  Future<File> file;
  String status = '';
  String errMessage = 'Error cargando imagen';

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

  deleteFile() {
    this._fileName = '';
    this._base64Image = '';
    this.file = null;
    setState(() {});
  }

  chooseImage(ImageSource source) {
    setState(() {
      file = ImagePicker.pickImage(source: source);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  cancelJustificacion() {
    this._responseDialog =
        new ResponseDialogModel(action: DialogActions.CANCEL, data: {});
    Navigator.pop(context, _responseDialog);
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          this._fileName = snapshot.data.path.split('/').last;
          this._base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            height: 400,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fitHeight,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error escogiendo imagen',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No ha seleccionado Imagen',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => cancelJustificacion(),
          ),
          title: Text('Justificación'),
        ),
        body: Container(
          padding: EdgeInsets.all(0.0),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
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
                      maxLines: 10,
                      minLines: 1,
                      scrollController: _scrollController,
                      maxLength: 100,
                      onSubmitted: (String newValue) {
                        this._currentDescripcionJusti = newValue;
                      },
                      decoration: InputDecoration(
                          labelText: 'Descripción',
                          counterStyle:
                              TextStyle(color: LambThemes.light.primaryColor)),
                      onChanged: (String newValue) {
                        this._currentDescripcionJusti = newValue;
                      },
                    ),
                    new RaisedButton(
                      onPressed: () => Future.delayed(Duration.zero, () async {
                        await (this._currentDescripcionJusti == null ||
                                this._currentDescripcionJusti == '' ||
                                this._idMotivo == null ||
                                this._idMotivo == ''
                            ? Future.delayed(
                                Duration.zero,
                                () async {
                                  await showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        contentPadding: EdgeInsets.all(0),
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: RichText(
                                                textAlign: TextAlign.center,
                                                text: new TextSpan(
                                                  style: new TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: 'Los campos '),
                                                    new TextSpan(
                                                      text: 'Selecione motivo',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                    new TextSpan(text: ' y '),
                                                    new TextSpan(
                                                      text: 'Descripción',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                    new TextSpan(
                                                        text:
                                                            ' no pueden estar vacíos',
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                )),
                                          ),
                                          ButtonBar(
                                            buttonPadding: EdgeInsets.all(0),
                                            children: <Widget>[
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: LambThemes
                                                        .light.primaryColor,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                            : showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text('Desea enviar justificación?'),
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                              'Motivo: ${this._nombreMotivo[this._idMotivo]}.'),
                                          Text(
                                              'Descripcion: ${this._currentDescripcionJusti}.')
                                        ],
                                      ),
                                      ButtonBar(
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              this._responseDialog =
                                                  new ResponseDialogModel(
                                                      action:
                                                          DialogActions.CANCEL,
                                                      data: {});
                                              Navigator.pop(context);
                                            },
                                            child: Text('CANCELAR',
                                                style: TextStyle(
                                                  color: LambThemes
                                                      .light.primaryColor,
                                                )),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              this._responseDialog =
                                                  new ResponseDialogModel(
                                                      action:
                                                          DialogActions.SUBMIT,
                                                      data: {
                                                    'id_jmotivo':
                                                        this._idMotivo,
                                                    'descripcion': this
                                                        ._currentDescripcionJusti,
                                                    'archivo':
                                                        this._fileName ?? '',
                                                    'file_name':
                                                        this._base64Image ?? '',
                                                  });
                                              Navigator.pop(context);
                                              Navigator.pop(
                                                  context, _responseDialog);
                                            },
                                            child: Text('  SÍ  '),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ));
                      }),
                      child: Text(
                        '  ENVIAR  ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              showImage(),
              SizedBox(
                height: 20.0,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            this.file == null
                ? Text('')
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        deleteFile();
                      },
                      heroTag: 'image0',
                      tooltip: 'No enviar Foto',
                      child: const Icon(Icons.delete),
                    ),
                  ),
            FloatingActionButton(
              onPressed: () {
                chooseImage(ImageSource.gallery);
              },
              heroTag: 'image1',
              tooltip: 'Adjuntar Foto de Galería',
              child: const Icon(Icons.photo_library),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                },
                heroTag: 'image2',
                tooltip: 'Tomar un Foto',
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ));
  }
}
