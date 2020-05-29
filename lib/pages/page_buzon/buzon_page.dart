import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/pages/page_buzon/nuevo_mensa_page.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class BuzonPage extends StatefulWidget {
  BuzonPage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/buzon';
  @override
  _BuzonPageState createState() => _BuzonPageState();
}

class _BuzonPageState extends State<BuzonPage> {
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
      appBar: AppBarLamb(
        title: Text('BUZÓN'),
        alumno: this._currentChildSelected,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ResponseDialogModel response = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NuevoMensajePage(
                        storage: widget.storage,
                      )));
          switch (response?.action) {
            case DialogActions.SUBMIT:
              if (response.data != null) {
                await this._loadChildSelectedStorageFlow();
              }
              break;
            default:
          }
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.blue,
        ),
      ),
      body: ListView(
        controller: ScrollController(keepScrollOffset: false),
        children: <Widget>[
          RaisedButton(
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
            highlightElevation: 20,
            highlightColor: LambThemes.light.primaryColor.withOpacity(0.4),
            elevation: 0,
            color: isMarked
                ? LambThemes.light.primaryColor.withOpacity(0.2)
                : Colors.transparent,
            //colorBrightness: Brightness.light,
            //highlightColor: LambThemes.light.primaryColor.withOpacity(0.4),
            //hoverElevation: 10,
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
                icon: isMarkedStar ? markedStar : notMarkedStar,
                onPressed: () {
                  isMarkedStar = !isMarkedStar;
                  setState(() {});
                },
              ),
              title: Text('Examen Parcial de RNAs'),
              subtitle: Text('19 de junio 2020'),
            ),
          ),
        ],
      ),
    );
  }

  Future _showDialog() async {
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
  }
}
