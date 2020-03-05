import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';

class AppBarLamb extends StatefulWidget implements PreferredSizeWidget {
  AppBarLamb({Key key, @required this.title, this.alumno, this.actions})
      : preferredSize = Size.fromHeight(100),
        super(key: key);
  final Widget title;
  final HijoModel alumno;
  final List<Widget> actions;

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarLambState createState() => _AppBarLambState();
}

class _AppBarLambState extends State<AppBarLamb> {
  Widget title;
  HijoModel alumno;
  String nombreDoc;
  List<Widget> actions;

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
    this.title = widget.title;
    this.alumno = widget.alumno;
    this.actions = widget.actions;
    this.getNomDoc();
    setState(() {});
  }

  String getNomDoc() {
    String nombre = this.alumno?.nombre ?? '';
    String doc;
    if (this.alumno?.numDoc == null) {
      doc = '';
    } else {
      doc = '(${this.alumno?.numDoc})';
    }
    this.nombreDoc = '$nombre $doc';
    print(nombreDoc + '????????????????');
    setState(() {});
    return this.nombreDoc;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 10), child: this.title),
      centerTitle: true,
      bottom: PreferredSize(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    //this.getNomDoc(),
                    this.alumno?.nombre ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'El Buen Pastor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              )),
          preferredSize: Size(MediaQuery.of(context).size.width - 2, 45)),
      actions: this.actions,
    );
  }
}
