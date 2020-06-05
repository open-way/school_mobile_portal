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

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            height: MediaQuery.of(context).size.width / 3,
            width: MediaQuery.of(context).size.width / 3,
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3, vertical: 0),
            child: /*CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: (MediaQuery.of(context).size.width / 3)+100,
              child: */Image.file(
                snapshot.data,
                fit: BoxFit.cover,
              ),
            /*),*/
            /*decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10000)),
                border: Border.all(
                  style: BorderStyle.none,
                )),*/
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
          title: Text('Perfil'),
        ),
        body: Container(
          padding: EdgeInsets.all(0.0),
          child: ListView(
            controller: ScrollController(keepScrollOffset: false),
            children: <Widget>[
              showImage(),
              /*Container(
                //constraints: BoxConstraints(maxWidth: 100),
                //height: MediaQuery.of(context).size.width / 3,
                //width: 100,

                /*padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3,
                    vertical: 30),*/
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      style: BorderStyle.none,
                    )),
                child: showImage(),
              ),*/
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
