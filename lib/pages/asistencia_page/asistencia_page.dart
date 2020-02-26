import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/anho_model.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/justificacion_motivo_model.dart';
//import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/anhos.saervice.dart';
import 'package:school_mobile_portal/services/justificacion-motivos.service.dart';
//import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
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

//enum DialogActions { SEARCH, CANCEL }

class _AsistenciaPageState extends State<AsistenciaPage>
    with TickerProviderStateMixin {
  final PortalPadresService portalPadresService = new PortalPadresService();
  final JustificacionMotivosService justificacionMotivosService =
      new JustificacionMotivosService();
  //List<AsistenciaModel> _listaAsistencias;
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Map<DateTime, List> _asistenciaEventos = new Map();
  AnimationController _animationController;
  CalendarController _calendarController;

  List<JustificacionMotivoModel> _justificacionMotivos;
  // List _justificaciones = [
  //   'Elegir Motivo',
  //   'Tengo trabajo',
  //   'No le gusta llegar puntual',
  //   'Se quemó la casa'
  // ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentJustificacion;

  final Map<String, String> result = new Map();
  String _currentIdChildSelected;

  // List<DropdownMenuItem<String>> getDropDownMenuItems() {
  //   List<DropdownMenuItem<String>> items = new List();
  //   for (JustificacionMotivoModel justificacion in _justificacionMotivos) {
  //     items.add(new DropdownMenuItem(
  //         value: justificacion.idJmotivo,
  //         child: new Text(justificacion.nombre)));
  //   }
  //   return items;
  // }

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    this._getJustificacionMotivos();
    // _dropDownMenuItems = getDropDownMenuItems();
    // _currentJustificacion = _dropDownMenuItems ?? _dropDownMenuItems[0].value;
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    this._loadChildSelectedStorageFlow(result);
  }

  void _getJustificacionMotivos() {
    _justificacionMotivos = [];
    justificacionMotivosService.getAll$().then((onValue) {
      _justificacionMotivos = onValue;
      // _dropDownMenuItems
      _dropDownMenuItems = [];
      for (JustificacionMotivoModel justificacion in _justificacionMotivos) {
        _dropDownMenuItems.add(new DropdownMenuItem(
            value: justificacion.idJmotivo,
            child: new Text(justificacion.nombre)));
      }
      _currentJustificacion = (_dropDownMenuItems.length > 0)
          ? _justificacionMotivos[0].idJmotivo
          : null;

      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  void _loadChildSelectedStorageFlow(Map<String, String> result) async {
    var idChildSelected = await widget.storage.read(key: 'id_child_selected');
    this._currentIdChildSelected = idChildSelected;
    if (result['id_alumno'] == null) {
      result['id_alumno'] = _currentIdChildSelected;
    }
    if (result['id_anho'] == null) {
      result['id_anho'] = DateTime.now().year.toString();
    }
    setState(() {});
  }

  /*void _getAsistencias(Map<String, String> result) {
    _listaAsistencias = [];
    portalPadresService.getAsistencias(result).then((onValue) {
      _listaAsistencias = onValue;
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }*/

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void changedDropDownItem(String selectedPeriodo) {
    print('Selected city $selectedPeriodo, we are going to refresh the UI');
    setState(() {
      _currentJustificacion = selectedPeriodo;
    });
  }

  void _onDaySelected(DateTime day, List events) async {
    print('CALLBACK: _onDaySelected');
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
              height: 260,
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
    var selecjusti;
    var descripcion;
    var txtButton;

    if (listaAsistencia.jutificacionEstado == '0' ||
        listaAsistencia.jutificacionEstado == '1') {
      selecjusti = Center(
          child: Text(listaAsistencia.jutificacionMotivo,
              style: TextStyle(fontSize: 17, color: Color(0x99000000))));
      descripcion = Center(
          child: Text(listaAsistencia.jutificacionDescripcion,
              style: TextStyle(fontSize: 15, color: Colors.black45)));
      txtButton = 'OK';
    } else {
      selecjusti = DropdownButton(
        value: _currentJustificacion,
        items: _dropDownMenuItems,
        onChanged: changedDropDownItem,
      );
      descripcion = TextField(
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Descripción',
          ));
      txtButton = 'ENVIAR';
    }

    var newJustificacion = new Alert(
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
          DialogButton(
            onPressed: () => Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            }),
            child: Text(
              txtButton,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
    return newJustificacion;
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
          result['id_alumno'] = _currentIdChildSelected;
          //setState(() {
          _loadChildSelectedStorageFlow(result);
          //});
        },
      ),
      appBar: appBar,
      // body: SingleChildScrollView(
      //   padding: EdgeInsets.all(7),
      //   scrollDirection: Axis.vertical,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.max,
      //     children: <Widget>[
      //       futureBuild(context),
      //     ],
      //   ),
      body: RefreshIndicator(
        displacement: 2,
        key: refreshKey,
        onRefresh: () async {
          await refreshList();
        },
        child: _calendarBox(appBar.preferredSize.height),
      ),
    );
  }

  Widget _calendarBox(double appBarHeight) {
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
                height:
                    MediaQuery.of(context).size.height - appBarHeight * 1.99,
                child: futureBuild(context)),
          ],
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 0));
    _loadChildSelectedStorageFlow(result);
    //Navigator.pushReplacementNamed(context, Routes.asistencia);
    return null;
  }

  Widget futureBuild(BuildContext context) {
    return FutureBuilder(
        future: portalPadresService.getAsistencias(result),
        builder: (context, AsyncSnapshot<List<AsistenciaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AsistenciaModel> asistencias = snapshot.data;
            for (var i = 0; i < asistencias.length; i++) {
              DateTime newDateTimeObj =
                  DateTime.parse(asistencias[i].fechaRegistro);
              _asistenciaEventos[newDateTimeObj] = [
                asistencias[i].estadoNombre,
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
        future: portalPadresService.getAsistencias({}),
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
    Map<String, String> localResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SimpleDialog(
                title: new Text('Filtrar'),
                children: <Widget>[
                  new FilterForm(
                      currentIdChildSelected: _currentIdChildSelected),
                ],
              )),
    );
    print(localResult.toString() +
        'q34tvqc413XRXc#XE3rc3qxrwC4a%YV34WTrc4CT#CR34!!!!!!!!!!!!!!!!!!!1');
    if (localResult != null) {
      result.addAll(localResult);
      this._loadChildSelectedStorageFlow(result);
    }
    /*switch (await showDialog(
      context: context,
      child: new SimpleDialog(
        title: new Text('Filtrar'),
        children: <Widget>[
          new FilterForm(),
        ],
      ),
    )) {
      case DialogActions.SEARCH:
        this._getAsistencias({});
        break;
      case DialogActions.CANCEL:
        break;
    }*/
  }
}

class FilterForm extends StatefulWidget {
  FilterForm({
    Key key,
    @required this.currentIdChildSelected,
  }) : super(key: key);

  final String currentIdChildSelected;

  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();

  // final PeriodosAcademicosService _periodosAcademicosService =
  //     new PeriodosAcademicosService();
  final AnhosService _anhosService = new AnhosService();

  //final MisHijosService _misHijosService = new MisHijosService();

  List<DropdownMenuItem<String>> _listaAnhos;
  //List<DropdownMenuItem<String>> _misHijos;

  //String _idAlumno;
  String _idAnho;

  @override
  void initState() {
    //this._idAlumno = '1';
    //this._idAnho = '1';
    super.initState();
    this._getMasters();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // myController.dispose();
    super.dispose();
  }

  void _getMasters() {
    this._getMyAnhos();
    //this._getMisHijos();
  }

  void _getMyAnhos() {
    _anhosService
        .getAll$({'id_alumno': widget.currentIdChildSelected}).then((listSnap) {
      _listaAnhos = listSnap.map((AnhoModel snap) {
        return DropdownMenuItem(
          value: snap.idAnho,
          child: Text(snap.idAnho),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  /*void _getMisHijos() {
    _misHijosService.getAll$().then((listSnap) {
      _misHijos = listSnap.map((HijoModel snap) {
        return DropdownMenuItem(
          value: snap.idAlumno,
          child: Text(snap.nombre),
        );
      }).toList();

      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*DropdownButton(
              hint: new Text('Seleccione alumno'),
              value: this._idAlumno,
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  _idAlumno = newValue;
                });
              },
              items: _misHijos,
            ),*/
            DropdownButton(
              hint: new Text('Seleccione un periodo'),
              value: this._idAnho,
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  this._idAnho = newValue;
                });
              },
              items: _listaAnhos,
            ),
            new SizedBox(
                width: double.infinity, // match_parent
                child: RaisedButton(
                  //textTheme: LambThemes.light.buttonTheme.textTheme,
                  //color: LambThemes.light.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Filtrar'),
                  onPressed: () {
                    Map<String, String> params;
                    if (this._idAnho.isNotEmpty) {
                      params = {'id_anho': _idAnho};
                      //_AsistenciaPageState().reassemble();
                    }
                    print(params.toString() +
                        'q34tvqc413XRXc#XE3rc3qxrwC4a%YV34WTrc4CT#CR34!!!!!!!!!!!!!!!!!!!2');
                    Navigator.pop(context, params);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
