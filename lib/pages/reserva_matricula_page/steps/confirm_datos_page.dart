import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/students_my_child_model.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/pages/reserva_matricula_page/steps/terminos_condiciones.dart';
import 'package:school_mobile_portal/pages/reserva_matricula_page/visapayment_reserva_page.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';

class ConfirmDatosPage extends StatefulWidget {
  ConfirmDatosPage({
    Key key,
    // @required this.hijo,
    @required this.hijoSeleccionado,
    @required this.storage,
  }) : super(key: key);

  // final HijoModel hijo;
  final StudentMyChildModel hijoSeleccionado;
  final FlutterSecureStorage storage;

  @override
  _ConfirmDatosPageState createState() => _ConfirmDatosPageState();
}

enum ModoTrabajador { independiente, dependiente }

class _ConfirmDatosPageState extends State<ConfirmDatosPage> {
  HijoModel hijo;
  UserSignInModel _currentUserLogged;

  bool checkedValue = true;
  TextEditingController importePago;

  @override
  void initState() {
    super.initState();

    this._loadMaster();
  }

  _loadMaster() async {
    this.hijo = new HijoModel(
      nombre: widget.hijoSeleccionado.nombre,
      paterno: widget.hijoSeleccionado.paterno,
      materno: widget.hijoSeleccionado.materno,
      idAlumno: widget.hijoSeleccionado.idAlumno,
      numDoc: widget.hijoSeleccionado.numDocumento,
      institucionNombre: widget.hijoSeleccionado.nombreInstitucion,
    );
    await this._loadUserStorage();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _loadUserStorage() async {
    var userStorage = await widget.storage?.read(key: 'user_sign_in') ?? null;
    // print('userStorage desde confirm');
    // print(userStorage);

    this._currentUserLogged =
        new UserSignInModel.fromJson(jsonDecode(userStorage));
    setState(() {});
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'TERMINOS Y CONDICIONES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TerminosCondiciones(),
          actions: [
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var baseUrlWeb = baseAllUrl.substring(0, baseAllUrl.length - 10);
    var baseUrlWeb = baseAllUrl.substring(0, baseAllUrl.length - 10);
    List<String> imagesUrl = [
      'https://static-content.vnforapps.com/v1/img/bottom/visa.png',
      'https://static-content.vnforapps.com/v1/img/bottom/mc.png',
      'https://static-content.vnforapps.com/v1/img/bottom/dc.png'
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarLamb(
        title: Text('CONFIRMAR DATOS'),
        alumno: this.hijo,
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: LambThemes.light.primaryColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Center(
                          child: Text(
                            'RESERVA DE MATRÍCULA ${widget.hijoSeleccionado.anho}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: LambThemes.light.accentColor,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            'ALUMNO',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${widget.hijoSeleccionado?.paterno ?? ''} ${widget.hijoSeleccionado?.materno ?? ''}  ${widget.hijoSeleccionado?.nombre ?? ''}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            'DNI',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${widget.hijoSeleccionado?.numDocumento ?? ''}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            'GRADO - NIVEL EDUCATIVO',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${widget.hijoSeleccionado?.nombreGrado ?? ''} - ${widget.hijoSeleccionado?.nombreNivel ?? ''}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    child: Text('Ver términos y condiciones'),
                    onPressed: () {
                      _showDialog();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CheckboxListTile(
                    title: Text('Acepto términos y condiciones'),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'IMPORTE A PAGAR',
                    style: TextStyle(
                      // fontSize:
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                  child: TextFormField(
                    enabled: false,
                    // controller: ,
                    initialValue: widget.hijoSeleccionado?.topePrecio ?? '0.00',
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      // labelText: "Enter Email",
                      contentPadding: EdgeInsets.only(right: 20, left: 20),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Importe requerido";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: LambThemes.light.accentColor,
                    // color: LambThemes.light.accentColor.withOpacity(1),
                    padding: EdgeInsets.all(10),
                    // child: Text(
                    //   'PAGAR CON ',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w900,
                    //   ),
                    // ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                            Text(
                              'PAGAR CON ',
                              style: TextStyle(
                                // color: LambThemes.light.accentColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ] +
                          imagesUrl
                              .map((imgUrl) => Image.network(
                                    imgUrl,
                                    fit: BoxFit.contain,
                                    width: 65,
                                    height: 35,
                                  ))
                              .toList(),
                    ),
                    onPressed: () {
                      if (checkedValue &&
                          (double.parse(widget.hijoSeleccionado?.topePrecio) >
                              0)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VisapaymentReservaPage(
                              idAlumno:
                                  widget.hijoSeleccionado?.idAlumno ?? null,
                              idPersona: _currentUserLogged?.idPersona ?? null,
                              idReserva:
                                  widget.hijoSeleccionado?.idReserva ?? null,
                              totalPagar:
                                  widget.hijoSeleccionado?.topePrecio ?? null,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
