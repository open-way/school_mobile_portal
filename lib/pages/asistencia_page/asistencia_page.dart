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
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/widgets/filter_anho_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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

  AnimationController _animationController;
  CalendarController _calendarController;

  List<JustificacionMotivoModel> _justificacionMotivos;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentDescripcionJusti;
  String _currentJustificacion;

  final Map<String, String> queryParams = new Map();
  String _currentIdChildSelected;
  String idAnho;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    this._getJustificacionMotivos();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    this._loadChildSelectedStorageFlow();
  }

  void _getJustificacionMotivos() {
    _justificacionMotivos = [];
    justificacionMotivosService.getAll$().then((onValue) {
      _justificacionMotivos = onValue;
      _dropDownMenuItems = [];
      for (JustificacionMotivoModel justificacion in _justificacionMotivos) {
        _dropDownMenuItems.add(new DropdownMenuItem(
            value: justificacion.idJmotivo,
            child: new Text(justificacion.nombre)));
      }
      _currentJustificacion = (_dropDownMenuItems.length > 0)
          ? _justificacionMotivos[0].idJmotivo
          : null;

      //setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  void _loadChildSelectedStorageFlow() async {
    var now = new DateTime.now();
    this.idAnho = this.idAnho ?? now.year.toString();
    var childSelected = await widget.storage.read(key: 'child_selected');
    var idChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected)).idAlumno;
    this._currentIdChildSelected = idChildSelected;
    if (this.queryParams['id_alumno'] == null) {
      this.queryParams['id_alumno'] = this._currentIdChildSelected;
    }
    this.queryParams['id_anho'] = this.idAnho;
    setState(() {});
  }

  @override
  void dispose() {
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
              color: Colors.lightBlue[400],
              child: Text('OK!'),
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

  showAlertJustificar(AsistenciaModel listaAsistencia) {
    Widget selecjusti;
    Widget descripcion;
    //String txtButton;
    DialogButton botonConfirmar;

    if (listaAsistencia.jutificacionEstado == '0' ||
        listaAsistencia.jutificacionEstado == '1') {
      selecjusti = Center(
          child: Text(listaAsistencia.jutificacionMotivo,
              style: TextStyle(fontSize: 17, color: Color(0x99000000))));
      descripcion = Center(
          child: Text(listaAsistencia.jutificacionDescripcion,
              style: TextStyle(fontSize: 15, color: Colors.black45)));
      botonConfirmar = DialogButton(
        onPressed: () => Future.delayed(Duration.zero, () {
          Navigator.of(context).pop();
        }),
        child: Text(
          'OK',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
      //txtButton = 'OK';
    } else {
      selecjusti = InputDecorator(
          decoration: InputDecoration(
            icon: Icon(Icons.date_range),
            labelText: 'Seleccione motivo',
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _currentJustificacion,
              items: _dropDownMenuItems,
              onChanged: (String newValue) {
                setState(() {
                  this._currentJustificacion = newValue;
                });
              },
            ),
          ));

      descripcion = TextField(
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Descripción',
        ),
        onChanged: (String newValue) =>
            {this.currentDescripcionJusti = newValue},
      );
      botonConfirmar = DialogButton(
        onPressed: () => Future.delayed(Duration.zero, () {
          if (this.currentDescripcionJusti != null) {
            Map<String, String> postParams = {
              'id_jmotivo': this._currentJustificacion,
              'id_asistencia': listaAsistencia.idAsistencia,
              'descripcion': this.currentDescripcionJusti,
              'archivo': ''
            };
            justificacionesService.postAll$(postParams);
          }
          Navigator.of(context).pop();
        }),
        child: Text(
          'ENVIAR',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
      //txtButton = 'ENVIAR';
    }
    Navigator.of(context).pop();
    newJustificacion(selecjusti, descripcion, botonConfirmar);
  }

  Future newJustificacion(Widget selecjusti, Widget descripcion,
      DialogButton botonConfirmar) async {
    await new Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        title: 'Justificación',
        content: Column(
          children: <Widget>[
            selecjusti,
            descripcion,
          ],
        ),
        buttons: [
          botonConfirmar,
        ]).show();
  }

  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Asistencia'),
      actions: <Widget>[
        IconButton(
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
      events: asistenciaEventos,
      initialSelectedDay: DateTime.now(),
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
    Color color = getEstado[1];
    Widget buttonJustificar = getEstado[2];
    String responsable = asistencia.responsable;
    String puerta = asistencia.puerta;

    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: Icon(Icons.album, color: color),
        title: Text(periodoNombre),
        subtitle: Text(estado),
      ),
      Text(DateFormat('HH:mm')
          .format(DateTime.parse(asistencia.fechaRegistro))
          .toString()),
      Text(responsable),
      Text(puerta),
      ButtonBar(children: <Widget>[buttonJustificar])
    ]));
  }

  //Retorna estado, color y solo si es de estado tarde o falta tambien el botonJustificar [Puntual, green, null]
  getEstadoColor(AsistenciaModel listaAsistencia) {
    String estado = listaAsistencia.estadoNombre;
    String jutificacionEstado = listaAsistencia.jutificacionEstado ?? '';
    var getEstado;
    var colorEstado;
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
          child: Text(nameButton),
          onPressed: () {
            showAlertJustificar(listaAsistencia);
          },
        );

    if (estado.isNotEmpty || estado != null) {
      switch (estado + '|' + jutificacionEstado) {
        case 'Puntual|':
          getEstado = 'Puntual';
          colorEstado = Colors.green[600];
          break;
        case 'Tarde|':
          getEstado = 'Tardanza';
          colorEstado = Colors.orange[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case 'Falta|':
          getEstado = 'Falta';
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case 'Justificación|1':
          getEstado = 'Justificación';
          colorEstado = Colors.lightBlue;
          getButtonJustificar = _getButtonJustificar();
          break;
        case 'Tarde|0':
          getEstado = 'Tardanza';
          colorEstado = Colors.orange[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case 'Falta|0':
          getEstado = 'Falta';
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case 'Tarde|2':
          getEstado = 'Tardanza';
          colorEstado = Colors.orange[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case 'Falta|2':
          getEstado = 'Falta';
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        default:
      }
    }
    return [getEstado, colorEstado, getButtonJustificar];
  }

  Widget _dayBuilder(DateTime date, List events, Color txtColor) {
    var asisColor;
    var getEventEstado = events.toString().substring(1, 2);
    if (getEventEstado == 'T') {
      asisColor = Colors.orange[300];
    }
    if (getEventEstado == 'F') {
      asisColor = Colors.red[300];
    }
    if (getEventEstado == 'J') {
      asisColor = Colors.lightBlue;
    }
    if (getEventEstado == 'P') {
      asisColor = Colors.green[600];
    }
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
