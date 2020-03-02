import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/justificacion_motivo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/services/justificacion-motivos.service.dart';
import 'package:school_mobile_portal/services/justificaciones.service.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/widgets/filter_anho_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:intl/intl.dart';

class AsistenciaPage extends StatefulWidget {
  static const String routeName = '/asistencia';

  AsistenciaPage({
    Key key,
    @required this.storage,
  }) : super(key: key);

  final FlutterSecureStorage storage;

  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage>
    with TickerProviderStateMixin {
  final PortalPadresService portalPadresService = new PortalPadresService();
  final JustificacionMotivosService justificacionMotivosService =
      new JustificacionMotivosService();
  final JustificacionesService justificacionesService =
      new JustificacionesService();
  GlobalKey<RefreshIndicatorState> refreshKey;

  TextEditingController _textController;
  AnimationController _animationController;
  CalendarController _calendarController;

  String _idMotivo;
  String _nombreMotivo;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentDescripcionJusti;
  String _currentNameChildSelected;

  final Map<String, String> queryParams = new Map();
  String _currentIdChildSelected;
  String idAnho;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    //this._getJustificacionMotivos();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    this._loadChildSelectedStorageFlow();
  }

  /*void _getJustificacionMotivos() {
    justificacionMotivosService.getAll$().then((onValue) {
      this._dropDownMenuItems = onValue.map((JustificacionMotivoModel snap) {
        this._idMotivo = this._idMotivo ?? snap.idJmotivo;
        this._nombreMotivo = this._nombreMotivo ?? snap.nombre;
        return DropdownMenuItem(
          value: snap.idJmotivo,
          child: Text(snap.nombre),
        );
      }).toList();
    }).catchError((err) {
      print(err);
    });
  }*/

  /*void _getReOrderJustificacionMotivos() {
    justificacionMotivosService.getAll$().then((onValue) {
      this._dropDownMenuItems = onValue.map((JustificacionMotivoModel snap) {
        if (this._idMotivo == snap.idJmotivo) {
          this._nombreMotivo = this._nombreMotivo ?? snap.nombre;
        }
        this._idMotivo = this._idMotivo ?? snap.idJmotivo;
        return DropdownMenuItem(
          value: snap.idJmotivo,
          child: Text(snap.nombre),
        );
      }).toList();
    }).catchError((err) {
      print(err);
    });
  }*/

  void _loadChildSelectedStorageFlow() async {
    var now = new DateTime.now();
    DateTime selectedDay = now;
    this.idAnho = this.idAnho ?? now.year.toString();
    var childSelected = await widget.storage.read(key: 'child_selected');
    var currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    this._currentIdChildSelected = currentChildSelected.idAlumno;
    this._currentNameChildSelected =
        this._currentNameChildSelected ?? currentChildSelected.nombre;
    if (this.queryParams['id_alumno'] == null) {
      this.queryParams['id_alumno'] = this._currentIdChildSelected;
    }
    this.queryParams['id_anho'] = this.idAnho;
    if (int.parse(this.idAnho) == now.year) {
      selectedDay = now;
    } else {
      selectedDay = DateTime(int.parse(this.idAnho), 1, 1, 0, 0);
    }
    try {
      _calendarController.setSelectedDay(selectedDay);
    } catch (e) {
      print('Error calendar controller: $e');
    }
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) async {
    final f = new DateFormat('dd, MMMM yyyy');

    if (events.isNotEmpty) {
      if (day != null) {
        await animated_dialog_box.showScaleAlertBox(
            title: Text(f.format(day)),
            context: context,
            firstButton: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: LambThemes.light.primaryColor,
              child: Text('Ok!'),
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
              },
            ),
            icon: Icon(null),
            yourWidget: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: 300,
              child: CupertinoScrollbar(
                  controller: _controllerOne,
                  child: ListView.builder(
                      controller: _controllerOne,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) =>
                          detalleAsistenciasDia(day))),
            ));
      }
    }
  }

  /*showAlertJustificar(AsistenciaModel listaAsistencia) {
    Navigator.of(context).pop();
    if (listaAsistencia.jutificacionEstado == '0' ||
        listaAsistencia.jutificacionEstado == '1') {
      showJustificacion(listaAsistencia);
    } else {
      newJustificacion(listaAsistencia);
    }
  }*/

  void showJustificacion(AsistenciaModel listaAsistencia) async {
    await animated_dialog_box.showScaleAlertBox(
        context: context,
        icon: Icon(null),
        title: Text('Justificación'),
        yourWidget: Column(
          children: <Widget>[
            Center(
                child: Text(listaAsistencia.justificacionMotivo ?? '',
                    style: TextStyle(fontSize: 17, color: Color(0x99000000)))),
            Center(
                child: Text(listaAsistencia.justificacionDescripcion ?? '',
                    style: TextStyle(fontSize: 15, color: Colors.black45))),
          ],
        ),
        firstButton: RaisedButton(
          onPressed: () => Future.delayed(Duration.zero, () {
            Navigator.of(context).pop();
          }),
          child: Text(
            '  OK  ',
          ),
        ));
  }

  Future newJustificacion(AsistenciaModel listaAsistencia) async {
    ResponseDialogModel response = await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Justificación'),
          children: <Widget>[
            new FormJustificacion(),
          ],
        ));

    switch (response?.action) {
      case DialogActions.SUBMIT:
        if (response.data != null) {
          final Map<String, String> postParams = new Map();
          postParams.addAll(response.data);
          postParams['id_asistencia'] = listaAsistencia.idAsistencia;
          postParams['archivo'] = '';
          justificacionesService.postAll$(postParams).then((onValue) {
            print(onValue);
          }).catchError((onError) {
            print(onError);
          });
        }
        break;
      case DialogActions.CANCEL:
        break;
      default:
    }
    /*await animated_dialog_box.showScaleAlertBox(
        context: context,
        icon: Icon(null),
        title: Text('Justificación'),
        yourWidget: Column(
          children: <Widget>[
            InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Seleccione motivo',
                ),
                child: DropdownButtonHideUnderline(
                  key: Key('selec_motivo'),
                  child: DropdownButton<String>(
                    value: this._idMotivo,
                    onChanged: (String newValue) {
                      this._idMotivo = newValue;
                      setState(() {});
                    },
                    items: this._dropDownMenuItems,
                  ),
                )),
            TextField(
              controller: _textController,
              obscureText: false,
              scrollController: _controllerThree,
              maxLength: 100,
              onSubmitted: (String newValue) =>
                  {this.currentDescripcionJusti = newValue},
              decoration: InputDecoration(
                  labelText: 'Descripción',
                  counterStyle:
                      TextStyle(color: LambThemes.light.primaryColor)),
              onChanged: (String newValue) =>
                  {this.currentDescripcionJusti = newValue},
            ),
          ],
        ),
        firstButton: RaisedButton(
          onPressed: () => Future.delayed(Duration.zero, () async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text('Desea enviar justificación?'),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Motivo: ${this._nombreMotivo}.'),
                        Text('Descripcion: ${this.currentDescripcionJusti}.')
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
                            Map<String, String> postParams = {
                              'id_jmotivo': this._idMotivo,
                              'id_asistencia': listaAsistencia.idAsistencia,
                              'descripcion': this.currentDescripcionJusti,
                              'archivo': ''
                            };
                            justificacionesService
                                .postAll$(postParams)
                                .then((onValue) {
                              print(onValue);
                            }).catchError((onError) {
                              print(onError);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('  SÍ  '),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
            Navigator.of(context).pop();
          }),
          child: Text(
            '  ENVIAR  ',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ));*/
  }

  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();
  final ScrollController _controllerThree = ScrollController();
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Asistencia'),
      centerTitle: true,
      bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              this._currentNameChildSelected ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width - 2, 40)),
      actions: <Widget>[
        IconButton(
          //alignment: CrossAxisAlignment.center,
          icon: Icon(Icons.filter_list),
          onPressed: _showDialog,
        ),
      ],
    );
    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          this._currentIdChildSelected = childSelected.idAlumno;
          this.queryParams['id_alumno'] = this._currentIdChildSelected;
          this._currentNameChildSelected = childSelected.nombre;
          _loadChildSelectedStorageFlow();
        },
      ),
      appBar: appBar,
      body: RefreshIndicator(
        displacement: 2,
        key: refreshKey,
        onRefresh: () async {
          await refreshList();
        },
        child: _calendarBox(),
      ),
    );
  }

  Widget _calendarBox() {
    return FractionallySizedBox(
      heightFactor: 1,
      widthFactor: 1,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
        controller: _controllerTwo,
        child: Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height,
                child: futureBuild(context)),
          ],
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 0));
    _loadChildSelectedStorageFlow();
    return null;
  }

  Widget futureBuild(BuildContext context) {
    return FutureBuilder(
        future: portalPadresService.getAsistencias(this.queryParams),
        builder: (context, AsyncSnapshot<List<AsistenciaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AsistenciaModel> asistencias = snapshot.data;
            Map<DateTime, List> _asistenciaEventos = new Map();
            for (var i = 0; i < asistencias.length; i++) {
              DateTime newDateTimeObj =
                  DateTime.parse(asistencias[i].fechaRegistro);
              _asistenciaEventos[newDateTimeObj] = [
                asistencias[i].estadoNombre,
                asistencias[i].idAsistencia,
                asistencias[i].estadoColor,
                asistencias[i].periodoNombre,
                asistencias[i].responsable,
                asistencias[i].puerta
              ];
            }
            return _buildTableCalendar(_asistenciaEventos);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildTableCalendar(Map<DateTime, List> asistenciaEventos) {
    Map<CalendarFormat, String> _calendarFormat = new Map();
    _calendarFormat[CalendarFormat.month] = 'only month';
    return TableCalendar(
      calendarController: _calendarController,
      startDay: DateTime(int.parse(this.idAnho), 1, 1, 0, 0),
      endDay: DateTime(int.parse(this.idAnho), 12, 31, 0, 0),
      events: asistenciaEventos,
      availableCalendarFormats: _calendarFormat,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          return _dayBuilder(date, events, Colors.black);
        },
        weekendDayBuilder: (context, date, events) {
          return _dayBuilder(date, events, Colors.black45);
        },
        markersBuilder: (context, date, events, holidays) {
          return <Widget>[];
        },
      ),
      onDaySelected: _onDaySelected,
    );
  }

  Widget detalleAsistenciasDia(DateTime day) {
    return new FutureBuilder(
        future: portalPadresService.getAsistencias(this.queryParams),
        builder: (context, AsyncSnapshot<List<AsistenciaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AsistenciaModel> asistencias = snapshot.data;
            final f = new DateFormat('dd/MM/yyyy');
            final children = <Widget>[];
            for (var i = 0; i < asistencias.length; i++) {
              if (f.format(DateTime.parse(asistencias[i].fechaRegistro)) ==
                  f.format(day)) {
                children.add(buildDetalleAsistencias(asistencias[i]));
              }
            }
            return Column(children: children);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildDetalleAsistencias(AsistenciaModel asistencia) {
    var getEstado = getEstadoColor(asistencia);
    String periodoNombre = asistencia.periodoNombre ?? '';
    String estado = getEstado[0];
    Color color = Color(int.parse(getEstado[1]));
    Widget buttonJustificar = getEstado[2];
    String responsable = asistencia.responsable;
    String puerta = asistencia.puerta;

    return Card(
        elevation: 0,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album, color: color),
                title: Text(periodoNombre),
                subtitle: Text(estado),
              ),
              ListTile(
                leading: Icon(null),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(DateFormat('HH:mm')
                        .format(DateTime.parse(asistencia.fechaRegistro))
                        .toString()),
                    Text(responsable),
                    Text(puerta),
                  ],
                ),
              ),
              ButtonBar(children: <Widget>[buttonJustificar]),
              Divider(),
            ]));
  }

  //Retorna estado, color y solo si es de estado tarde o falta tambien el botonJustificar [Puntual, green, null]
  getEstadoColor(AsistenciaModel listaAsistencia) {
    String estado = listaAsistencia.estadoNombre;
    String jutificacionEstado = listaAsistencia?.justificacionEstado ?? '';
    String getEstado = listaAsistencia.estadoNombre;
    String colorEstado = listaAsistencia.estadoColor;
    var getButtonJustificar;

    var nameButton;
    switch (jutificacionEstado) {
      case '':
        nameButton = 'Justificar';
        break;
      case '0':
        nameButton = 'Justificación en espera';
        break;
      case '1':
        nameButton = 'Justificación Aprobada';
        break;
      case '2':
        nameButton = 'Justificación rechazada';
        break;
      default:
    }

    _getButtonJustificar() => new FlatButton(
          child: Text(nameButton,
              style: TextStyle(
                color: LambThemes.light.primaryColor,
              )),
          onPressed: () {
            Navigator.of(context).pop();
            if (listaAsistencia.justificacionEstado == '0' ||
                listaAsistencia.justificacionEstado == '1') {
              showJustificacion(listaAsistencia);
            } else {
              newJustificacion(listaAsistencia);
            }
          },
        );

    if (estado.isNotEmpty || estado != null) {
      switch (estado + '|' + jutificacionEstado) {
        case 'Puntual|':
          break;
        default:
          getButtonJustificar = _getButtonJustificar();
          break;
      }
    }
    return [getEstado, colorEstado, getButtonJustificar];
  }

  Widget _dayBuilder(DateTime date, List events, Color txtColor) {
    var asisColor;
    if (events != null) {
      asisColor = Color(int.parse(events[2]));
    }
    /*var getEventEstado = events.toString().substring(1, 2);
    if (getEventEstado == 'T') {
      asisColor = Color(int.parse(events[2]));
    }
    if (getEventEstado == 'F') {
      asisColor = Colors.red[300];
    }
    if (getEventEstado == 'J') {
      asisColor = Colors.lightBlue;
    }
    if (getEventEstado == 'P') {
      asisColor = Colors.green[600];
    }*/
    return Container(
        decoration: BoxDecoration(color: asisColor, shape: BoxShape.circle),
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        width: 100,
        height: 100,
        child: Center(
            child: Text('${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0, color: txtColor))));
  }

  Future _showDialog() async {
    if (this._currentIdChildSelected != null) {
      ResponseDialogModel response = await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Filtrar'),
          children: <Widget>[
            new FilterAnhoDialog(
              idAlumno: this._currentIdChildSelected,
              idAnhoDefault: this.idAnho,
            ),
          ],
        ),
      );

      switch (response?.action) {
        case DialogActions.SUBMIT:
          if (response.data != null) {
            this.idAnho = response.data;
            this.queryParams['id_anho'] = response.data;
            this._loadChildSelectedStorageFlow();
          }
          break;
        default:
      }
    }
  }
}

class FormJustificacion extends StatefulWidget {
  FormJustificacion({Key key}) : super(key: key);
  @override
  _FormJustificacionState createState() => _FormJustificacionState();
}

class _FormJustificacionState extends State<FormJustificacion> {
  final JustificacionMotivosService justificacionMotivosService =
      new JustificacionMotivosService();
  TextEditingController _textController;

  List<DropdownMenuItem<String>> _listaMotivos;
  String _idMotivo;
  final Map<String, String> _nombreMotivo = new Map();
  String currentDescripcionJusti;

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
    this.justificacionMotivosService.getAll$().then((onValue) {
      this._listaMotivos = onValue.map((JustificacionMotivoModel snap) {
        //this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: snap.idJmotivo,
          child: Text(snap.nombre),
        );
      }).toList();
    }).catchError((err) {
      print(err);
    });
  }

  final ScrollController _controllerThree = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(15),
      child: Column(
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
            scrollController: _controllerThree,
            maxLength: 100,
            onSubmitted: (String newValue) =>
                {this.currentDescripcionJusti = newValue},
            decoration: InputDecoration(
                labelText: 'Descripción',
                counterStyle: TextStyle(color: LambThemes.light.primaryColor)),
            onChanged: (String newValue) =>
                {this.currentDescripcionJusti = newValue},
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
                          Text('Descripcion: ${this.currentDescripcionJusti}.')
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
                              var responseDialog = new ResponseDialogModel(
                                  action: DialogActions.SUBMIT,
                                  data: {
                                    'id_jmotivo': this._idMotivo,
                                    'descripcion': this.currentDescripcionJusti
                                  });
                              Navigator.pop(context, responseDialog);
                            },
                            child: Text('  SÍ  '),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
              Navigator.of(context).pop();
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
