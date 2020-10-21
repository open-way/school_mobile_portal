import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/ocupacion.dart';
import 'package:school_mobile_portal/models/religion.dart';
import 'package:school_mobile_portal/models/students_my_child_model.dart';
import 'package:school_mobile_portal/pages/reserva_matricula_page/steps/confirm_datos_page.dart';
import 'package:school_mobile_portal/services/portal.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';

class ActualizarDatosPage extends StatefulWidget {
  ActualizarDatosPage({
    Key key,
    @required this.hijo,
    @required this.storage,
  }) : super(key: key);

  final StudentMyChildModel hijo;
  final FlutterSecureStorage storage;

  @override
  _ActualizarDatosPageState createState() => _ActualizarDatosPageState();
}

enum ModoTrabajador { independiente, dependiente }

class _ActualizarDatosPageState extends State<ActualizarDatosPage> {
  HijoModel hijo;

  dynamic padre;
  ReligionModel religionModel;
  OcupacionModel ocupacionModel;
  List<ReligionModel> religiones;
  List<OcupacionModel> ocupaciones;
  PortalService portalService = new PortalService();

  TextEditingController emailController;
  TextEditingController celularController;
  TextEditingController direccionController;
  TextEditingController nombreReligionController;
  TextEditingController ocupacionController;
  TextEditingController lugarTrabajoController;
  ModoTrabajador tipoModalidadController = ModoTrabajador.independiente;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // print('initState --------->');
    super.initState();

    this.hijo = new HijoModel(
      nombre: widget.hijo.nombre,
      idAlumno: widget.hijo.idAlumno,
      institucionNombre: widget.hijo.nombreInstitucion,
      paterno: widget.hijo.paterno,
      materno: widget.hijo.materno,
      numDoc: widget.hijo.numDocumento,
    );

    this._loadMaster();
  }

  _loadMaster() async {
    final resultado = await this.portalService.getInfoParentStudent$({});
    this.padre = resultado['padre'];

    final data = resultado['religiones'].cast<Map<String, dynamic>>();
    this.religiones = data
        .map<ReligionModel>((json) => ReligionModel.fromJson(json))
        .toList();
    // this.religionModel = this.religiones[0];

    final ocup = resultado['ocupaciones'].cast<Map<String, dynamic>>();
    this.ocupaciones = ocup
        .map<OcupacionModel>((json) => OcupacionModel.fromJson(json))
        .toList();
    print(this.ocupaciones[0].idOcupacion);
    print(this.ocupaciones[0].nombre);
    // this.ocupacionModel = this.ocupaciones[0];

    setState(() {
      print(padre);

      emailController = new TextEditingController(text: padre['email']);
      celularController = new TextEditingController(text: padre['celular']);
      direccionController = new TextEditingController(text: padre['direccion']);
      lugarTrabajoController =
          new TextEditingController(text: padre['lugar_trabajo']);

      if (padre['id_religion'] != null) {
        var objReligion = this.religiones.firstWhere(
            (religion) => religion.idReligion == padre['id_religion']);
        this.religionModel = objReligion;
      } else {
        this.religionModel = this.religiones[0];
      }

      if (padre['id_ocupacion'] != null) {
        var objOcupacion = this.ocupaciones.firstWhere(
            (ocupacion) => ocupacion.idOcupacion == padre['id_ocupacion']);
        this.ocupacionModel = objOcupacion;
      } else {
        this.ocupacionModel = this.ocupaciones[0];
      }

      if (padre['tipo_modalidad'] != null) {
        tipoModalidadController = (padre['tipo_modalidad'] == '01')
            ? ModoTrabajador.dependiente
            : ModoTrabajador.independiente;
      } else {
        tipoModalidadController = ModoTrabajador.dependiente;
      }

      // tipoModalidadController = ModoTrabajador.independiente;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    celularController.dispose();
    direccionController.dispose();
    lugarTrabajoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: 'Guardando...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(),
      ),
      // insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarLamb(
        title: Text('ACTUALIZAR DATOS'),
        alumno: this.hijo,
      ),
      body: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: TextFormField(
                    // cursorHeight: 60,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                    ),
                    controller: emailController,
                    validator: (val) {
                      if (val.length == 0) {
                        return "Es requerido";
                      } else {
                        return null;
                      }
                    },
                  ),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Celular',
                    ),
                    controller: celularController,
                    validator: (val) {
                      if (val.length == 0) {
                        return "Es requerido";
                      } else {
                        return null;
                      }
                    },
                  ),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Dirección actual',
                    ),
                    controller: direccionController,
                    validator: (val) {
                      if (val.length == 0) {
                        return "Es requerido";
                      } else {
                        return null;
                      }
                    },
                  ),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Seleccione su ocupación',
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<OcupacionModel>(
                        value: ocupacionModel,
                        isDense: true,
                        underline: Container(
                          height: 1.5,
                          color: LambThemes.light.primaryColor,
                          // color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (OcupacionModel newValue) {
                          setState(() {
                            ocupacionModel = newValue;
                          });
                        },
                        items: (ocupaciones == null)
                            ? []
                            : ocupaciones.map<DropdownMenuItem<OcupacionModel>>(
                                (OcupacionModel value) {
                                  return DropdownMenuItem<OcupacionModel>(
                                    value: value,
                                    child:
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //     left: 10,
                                        //   ),
                                        //   child:
                                        Text(value.nombre),
                                    // ),
                                  );
                                },
                              ).toList(),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Seleccione su religión',
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ReligionModel>(
                        value: religionModel,
                        isDense: true,
                        onChanged: (ReligionModel newValue) {
                          setState(() {
                            religionModel = newValue;
                          });
                        },
                        items: (religiones == null)
                            ? []
                            : religiones.map<DropdownMenuItem<ReligionModel>>(
                                (ReligionModel value) {
                                return DropdownMenuItem<ReligionModel>(
                                  value: value,
                                  child: Text(value.nombre),
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Lugar de trabajo',
                      filled: true,
                    ),
                    controller: lugarTrabajoController,
                    validator: (val) {
                      if (val.length == 0) {
                        return "Es requerido";
                      } else {
                        return null;
                      }
                    },
                  ),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Opacity(
                    opacity: 0.7,
                    child: Text('Trabajador'),
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Dependiente'),
                      leading: Radio(
                        value: ModoTrabajador.dependiente,
                        groupValue: tipoModalidadController,
                        onChanged: (ModoTrabajador value) {
                          setState(() {
                            tipoModalidadController = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Independiente'),
                      leading: Radio(
                        value: ModoTrabajador.independiente,
                        groupValue: tipoModalidadController,
                        onChanged: (ModoTrabajador value) {
                          setState(() {
                            tipoModalidadController = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: LambThemes.light.accentColor,
                    child: Text('ACTUALIZAR DATOS'),
                    onPressed: () async {
                      // celularController.value;
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        // form.save();
                        var dataToSave = {
                          'nombre': padre['nombre'],
                          'paterno': padre['paterno'],
                          'materno': padre['materno'],
                          'id_virtual': padre['id_virtual'],
                          'email': emailController.value.text,
                          'id_telefono': padre['id_telefono'],
                          'celular': celularController.value.text,
                          'direccion': direccionController.value.text,
                          'id_religion': religionModel.idReligion ?? '1',
                          'id_ocupacion': ocupacionModel.idOcupacion ?? '01',
                          'lugar_trabajo': lugarTrabajoController.value.text,
                          'tipo_modalidad': tipoModalidadController ==
                                  ModoTrabajador.dependiente
                              ? '01'
                              : '02',
                        };
                        pr.show();
                        await this
                            .portalService
                            .updateParentStudents$(dataToSave)
                            .then((dynamic onValue) {
                          pr.hide();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConfirmDatosPage(
                                // hijo: this.hijo,
                                hijoSeleccionado: widget.hijo,
                                storage: widget.storage,
                              ),
                            ),
                          );
                        }).catchError((dynamic onError) {
                          pr.hide();
                        });
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
