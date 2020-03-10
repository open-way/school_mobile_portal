import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';

class AppBarLamb extends StatelessWidget implements PreferredSizeWidget {
  AppBarLamb({Key key, @required this.title, this.alumno, this.actions})
      : preferredSize = Size.fromHeight(100),
        super(key: key);
  final Widget title;
  final HijoModel alumno;
  final List<Widget> actions;

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return BarLamb(title: title, alumno: alumno, actions: actions);
  }
}

class BarLamb extends StatefulWidget {
  BarLamb({Key key, @required this.title, this.alumno, this.actions})
      : super(key: key);
  final Widget title;
  final HijoModel alumno;
  final List<Widget> actions;
  @override
  _AppBarLambState createState() => _AppBarLambState();
}

class _AppBarLambState extends State<BarLamb> {
  String nombreDoc;
  String institucion;

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
    this.getNomDoc();
    this.getInstitucion();
    setState(() {});
  }

  String getNomDoc() {
    String nombre = widget.alumno?.nombre ?? '';
    String doc;
    if (widget.alumno?.numDoc == null) {
      doc = '';
    } else {
      doc = '(${widget.alumno?.numDoc})';
    }
    this.nombreDoc = '$nombre $doc';
    return this.nombreDoc;
  }

  String getInstitucion() {
    this.institucion = widget.alumno?.institucionNombre ?? '';
    return this.institucion;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 10), child: widget.title),
      centerTitle: true,
      bottom: PreferredSize(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    this.getNomDoc(),
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.alumno?.institucionNombre ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          preferredSize: Size(MediaQuery.of(context).size.width - 2, 45)),
      actions: widget.actions,
    );
  }
}
