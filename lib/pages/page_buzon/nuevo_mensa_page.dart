import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class NuevoMensajePage extends StatefulWidget {
  NuevoMensajePage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  //static const String routeName = '/NuevoMensaje';
  @override
  _NuevoMensajePageState createState() => _NuevoMensajePageState();
}

class _NuevoMensajePageState extends State<NuevoMensajePage> {
  HijoModel _currentChildSelected;
  Icon markedStar = Icon(
    Icons.star,
    color: Colors.yellow[900],
  );
  Icon notMarkedStar = Icon(Icons.star_border);
  bool isMarkedStar = false;
  bool isMarked = true;

  @override
  void initState() {
    super.initState();
    this._loadChildSelectedStorageFlow();
  }

  Future _loadChildSelectedStorageFlow() async {
    var childSelected = await widget.storage.read(key: 'child_selected');
    var currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    this._currentChildSelected =
        this._currentChildSelected ?? currentChildSelected;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) async {
          this._currentChildSelected = childSelected;
          await _loadChildSelectedStorageFlow();
        },
      ),
      /*appBar: AppBarLamb(
        title: Text('Nuevo mensaje'),
        alumno: this._currentChildSelected,
      ),*/
      appBar: AppBar(
        title: Text('Nuevo mensaje'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: LambThemes.light.scaffoldBackgroundColor,
        child: Icon(
          Icons.attach_file,
          size: 40,
          color: LambThemes.light.primaryColor,
        ),
      ),
      body: ListView(
        controller: ScrollController(keepScrollOffset: false),
        children: <Widget>[
          /*RaisedButton(
            shape: Border.all(style: BorderStyle.none),
            padding: EdgeInsets.all(0),
            onPressed: () async {
              await _showDialog();
            },
            onLongPress: () {
              isMarked = !isMarked;
              setState(() {});
            },
            focusElevation: 0,
            autofocus: false,
            highlightElevation: 0,
            //highlightColor: LambThemes.light.primaryColor.withOpacity(0.2),
            elevation: 0,
            color: isMarked
                ? LambThemes.light.primaryColor.withOpacity(0.2)
                : Colors.transparent,
            //colorBrightness: Brightness.light,
            //highlightColor: LambThemes.light.primaryColor.withOpacity(0.4),
            hoverElevation: 0,
            child: ListTile(
              //enabled: isMarked,
              //selected: true,
              //isThreeLine: true,
              /*onTap: () {
                isMarked = !isMarked;
                setState(() {});
              },*/
              trailing: CircleAvatar(
                child: Icon(Icons.person),
              ),
              leading: IconButton(
                tooltip: 'Marcar como Importante',
                icon: isMarkedStar ? markedStar : notMarkedStar,
                onPressed: () {
                  isMarkedStar = !isMarkedStar;
                  setState(() {});
                },
              ),
              title: Text('Examen Parcial de RNAs'),
              subtitle: Text('19 de junio 2020'),
            ),
          ),*/
          /*Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[*/
          //ListTile(
          //title:
          Container(
            //width: double.infinity,
            child: TextField(
              //expands: true,

              toolbarOptions: ToolbarOptions(),
              maxLines: null,
              minLines: null,
              autofocus: false,
              decoration: new InputDecoration(
                labelText: 'Para:',
                icon: null,
              ),
            ),
          ),
          /*trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: null,
              tooltip: 'Añadir en grupo',
            ),
          ),*/
          /* ],
          ),*/
          Container(
            child: TextField(
              maxLines: 1,
              autofocus: false,
              decoration: new InputDecoration(
                labelText: 'Tema:',
                icon: null,
              ),
            ),
          ),
          Container(
            child: TextField(
              maxLines: 30,
              autofocus: false,
              decoration: new InputDecoration(
                labelText: 'Descripción:',
                icon: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*Future _showDialog() async {
    if (this._currentChildSelected != null) {
      ResponseDialogModel response = await showDialog(
        context: context,
        child: new CustomDialog(
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  isMarked = false;
                  setState(() {});
                },
                child: Text('OK'))
          ],
          children: <Widget>[
            Container(
              height: 100,
            )
          ],
        ),
      );

      switch (response?.action) {
        case DialogActions.SUBMIT:
          if (response.data != null) {
            await this._loadChildSelectedStorageFlow();
          }
          break;
        default:
      }
    }
  }*/
}
