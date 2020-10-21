import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:school_mobile_portal/models/hijo_model.dart';
// import 'package:school_mobile_portal/theme/lamb_themes.dart';

class AppBarLambReserva extends StatelessWidget implements PreferredSizeWidget {
  AppBarLambReserva(
      {Key key,
      // this.leading,
      @required this.title,
      // this.bottomTitle,
      // this.bottomSubtitle,
      // this.alumno,
      // this.actions,
      })
      : preferredSize = Size.fromHeight(100),
        super(key: key);
  // final Widget leading;
  final Widget title;
  // final String bottomTitle;
  // final String bottomSubtitle;
  // final HijoModel alumno;
  // final List<Widget> actions;

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return BarLamb(
        // leading: leading,
        title: title,
        // bottomTitle: bottomTitle,
        // bottomSubtitle: bottomSubtitle,
        // alumno: alumno,
        // actions: actions,
        );
  }
}

class BarLamb extends StatefulWidget {
  BarLamb(
      {Key key,
      // this.leading,
      @required this.title,
      // this.bottomTitle,
      // this.bottomSubtitle,
      // this.alumno,
      // this.actions,
      })
      : super(key: key);
  // final Widget leading;
  final Widget title;
  // final String bottomTitle;
  // final String bottomSubtitle;
  // final HijoModel alumno;
  // final List<Widget> actions;
  @override
  _AppBarLambState createState() => _AppBarLambState();
}

class _AppBarLambState extends State<BarLamb> {
  // @override
  // void initState() {
  //   super.initState();
  //   // this.customValidator();
  // }

  // customValidator() {}

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // String _getNomDoc() {
  //   String nombre = widget.alumno?.nombre ?? '';
  //   String doc;
  //   if (widget.alumno?.numDoc == 'null' || widget.alumno?.numDoc == null) {
  //     doc = '';
  //   } else {
  //     doc = '(${widget.alumno?.numDoc})';
  //   }
  //   return '$nombre $doc';
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: widget.leading,
      title: Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 10), child: widget.title),
      centerTitle: true,
      bottom: PreferredSize(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  // Text(
                  //   widget.alumno != null
                  //       ? this._getNomDoc()
                  //       : widget.bottomTitle ?? '',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  // Text(
                  //   widget.alumno != null
                  //       ? widget.alumno?.institucionNombre ?? ''
                  //       : widget.bottomSubtitle ?? '',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 10,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  Container(
                    child: Opacity(
                      opacity: 0.8,
                      child: Text(
                        'Gracias por su confianza en la Educación Adventista. Para reservar su matrícula solo seleccione INICIAR RESERVA.',
                        style: TextStyle(fontSize: 13, color: Colors.white
                            // color: LambThemes.light.
                            ),
                      ),
                    ),
                  )
                ],
              )),
          preferredSize: Size(MediaQuery.of(context).size.width - 2, 45)),
      // actions: widget.actions,
    );
  }
}
