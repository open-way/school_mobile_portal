import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/periodo_contable_model.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/services/periodos-contables.service.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class AsistenciaPage extends StatefulWidget {
  static const String routeName = '/asistencia';

  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

enum DialogActions { SEARCH, CANCEL }

class _AsistenciaPageState extends State<AsistenciaPage>
    with TickerProviderStateMixin {
  final PortalPadresService portalPadresService = new PortalPadresService();
  List<AsistenciaModel> _listaAsistencias;

  final Map<DateTime, List> _asistenciaEventos = new Map();
  AnimationController _animationController;
  CalendarController _calendarController;

  List _justificaciones = [
    'Elegir Excusa',
    'Tengo trabajo',
    'No le gusta llegar puntual',
    'Se quemó la casa'
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentJustificacion;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String justificacion in _justificaciones) {
      items.add(new DropdownMenuItem(
          value: justificacion, child: new Text(justificacion)));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentJustificacion = _dropDownMenuItems[0].value;
    this._getMasters();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  void _getMasters() {
    this._getAsistencias();
  }

  void _getAsistencias() {
    _listaAsistencias = [];
    portalPadresService.getAsistencias({}).then((onValue) {
      _listaAsistencias = onValue;
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

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

  List<Widget> detalleAsistenciasDia(DateTime day) {
    final f = new DateFormat('dd/MM/yyyy');
    final children = <Widget>[];
    for (var i = 0; i < _listaAsistencias.length; i++) {
      if (f.format(DateFormat('dd/MM/yyyy HH:mm')
              .parse(_listaAsistencias[i].fecha)) ==
          f.format(day)) {
        children.add(buildDetalleAsistencias(i));
      }
    }
    return children;
  }

  Widget buildDetalleAsistencias(int i) {
    var getEstado = getEstadoColor(i, _listaAsistencias[i].estado,
        _listaAsistencias[i].jutificacionEstado);
    String periodoNombre = _listaAsistencias[i].periodoNombre;
    String estado = getEstado[0];
    Color color = getEstado[1];
    Widget buttonJustificar = getEstado[2];
    String responsable = _listaAsistencias[i].responsable;
    String puerta = _listaAsistencias[i].puerta;

    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: Icon(Icons.album, color: color),
        title: Text(periodoNombre),
        subtitle: Text(estado),
      ),
      Text(DateFormat('HH:mm')
          .format(
              DateFormat('dd/MM/yyyy HH:mm').parse(_listaAsistencias[i].fecha))
          .toString()),
      Text(responsable),
      Text(puerta),
      ButtonBar(children: <Widget>[buttonJustificar])
    ]));
  }

  //Retorna estado, color y solo si es de estado tarde o falta tambien el botonJustificar [Puntual, green, null]
  getEstadoColor(int i, String estado, String jutificacionEstado) {
    var getEstado;
    var colorEstado;
    Widget getButtonJustificar;

    if (estado.isNotEmpty || estado != null) {
      switch (estado + '|' + jutificacionEstado) {
        case 'P|':
          getEstado = 'Puntual';
          colorEstado = Colors.green[600];
          break;
        case 'T|':
          getEstado = 'Tardanza';
          colorEstado = Colors.orange[300];
          getButtonJustificar = _getButtonJustificar(i);
          break;
        case 'F|':
          getEstado = 'Falta';
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar(i);
          break;
        case 'J|1':
          getEstado = 'Justificación';
          colorEstado = Colors.lightBlue;
          getButtonJustificar = _getButtonJustificar(i);
          break;
        case 'T|0':
          getEstado = 'Tardanza';
          colorEstado = Colors.orange[300];
          getButtonJustificar = _getButtonJustificar(i);
          break;
        case 'F|0':
          getEstado = 'Falta';
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar(i);
          break;
        case 'T|2':
          getEstado = 'Tardanza';
          colorEstado = Colors.orange[300];
          getButtonJustificar = _getButtonJustificar(i);
          break;
        case 'F|2':
          getEstado = 'Falta';
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar(i);
          break;
        default:
      }
    }
    return [getEstado, colorEstado, getButtonJustificar];
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
                  itemBuilder: (BuildContext context, int index) => Column(
                    children: detalleAsistenciasDia(day),
                  ),
                )),
          ),
        );
      }
    }
  }

  Future _showAlertJustifica() async {
    await animated_dialog_box.showScaleAlertBox(
      context: context,
      firstButton: DialogButton(
        onPressed: () => Future.delayed(Duration.zero, () {
          Navigator.of(context).pop();
        }),
        child: Text(
          'ENVIAR',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      icon: Icon(null),
      yourWidget: new SimpleDialog(
        title: new Text('Justificación'),
        children: <Widget>[
          DropdownButton(
            value: _currentJustificacion,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          TextField(
            obscureText: false,
            decoration: InputDecoration(
              //icon: Icon(Icons.lock),
              labelText: 'Descripción',
            ),
          ),
        ],
      ),
    );
  }

  showAlertJustificar(int i) {
    var selecjusti;
    var descripcion;
    var txtButton;

    if (_listaAsistencias[i].jutificacionEstado == '0' ||
        _listaAsistencias[i].jutificacionEstado == '1') {
      selecjusti = Center(
          child: Text(_listaAsistencias[i].jutificacionMotivo,
              style: TextStyle(fontSize: 17, color: Color(0x99000000))));
      descripcion = Center(
          child: Text(_listaAsistencias[i].jutificacionDescripcion,
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
            //icon: Icon(Icons.lock),
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

  Widget _getButtonJustificar(int i) {
    var nameButton;
    switch (_listaAsistencias[i].jutificacionEstado) {
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
    return FlatButton(
      child: Text(nameButton),
      onPressed: () {
        //_showAlertJustifica();
        showAlertJustificar(i);
      },
    );
  }

  final ScrollController _controllerOne = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Asistencia'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(7),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            futureBuild(context),
            // _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget futureBuild(BuildContext context) {
    return FutureBuilder(
        future: portalPadresService.getAsistencias({}),
        builder: (context, AsyncSnapshot<List<AsistenciaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AsistenciaModel> asistencias = snapshot.data;
            for (var i = 0; i < asistencias.length; i++) {
              DateTime newDateTimeObj = new DateFormat('dd/MM/yyyy HH:mm')
                  .parse(asistencias[i].fecha);
              _asistenciaEventos[newDateTimeObj] = [
                asistencias[i].estado,
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
      holidays: _holidays,
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
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(_buildEventsMarker(date, events, Colors.lightBlue));
          }
          //return children;
          return <Widget>[];
        },
      ),
      onDaySelected: _onDaySelected,
    );
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
      decoration: BoxDecoration(
        color: asisColor,
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(top: 5.0, left: 6.0),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(fontSize: 16.0, color: txtColor),
        ),
      ),
    );
  }

  Widget _buildEventsMarker(
      DateTime date, List events, MaterialColor asisColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(shape: BoxShape.circle),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                _calendarController.setSelectedDay(
                  DateTime.now(),
                  runCallback: true,
                );
              },
              child: new Text('Hoy'),
            )
          ],
        ),
      ],
    );
  }

  Future _showDialog() async {
    switch (await showDialog(
      context: context,
      child: new SimpleDialog(
        title: new Text('Filtrar'),
        children: <Widget>[
          new FilterForm(),
        ],
      ),
    )) {
      case DialogActions.SEARCH:
        this._getAsistencias();
        break;
      case DialogActions.CANCEL:
        break;
    }
  }
}

class FilterForm extends StatefulWidget {
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();

  final PeriodosContablesService _periodosContablesService =
      new PeriodosContablesService();

  final MisHijosService _misHijosService = new MisHijosService();

  List<DropdownMenuItem<String>> _listaPeriodosContables;
  List<DropdownMenuItem<String>> _misHijos;

  String _idAlumno;
  String _idAnho;

  @override
  void initState() {
    this._idAlumno = '1';
    this._idAnho = '1';
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
    this._getPeriodos();
    this._getMisHijos();
  }

  void _getPeriodos() {
    _periodosContablesService.getAllLocal().then((listSnap) {
      _listaPeriodosContables = listSnap.map((PeriodoContableModel snap) {
        return DropdownMenuItem(
          value: snap.idAnho,
          child: Text(snap.nombre),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  void _getMisHijos() {
    _misHijosService.getAllLocal().then((listSnap) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(15),
      // child: Card(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // new Title(
            //   child: Text('Filtros'),
            //   color: Colors.blue,
            // ),
            new DropdownButton(
              hint: new Text('Seleccione alumno'),
              value: this._idAlumno,
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  _idAlumno = newValue;
                });
              },
              items: _misHijos,
            ),
            // new Expanded(
            //   child:
            // new TextField(
            //   decoration: new InputDecoration(
            //       labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
            //   onChanged: (String newValue) {},
            // ),
            // ),
            new DropdownButton(
              hint: new Text('Seleccione un periodo'),
              value: this._idAnho,
              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  this._idAnho = newValue;
                });
              },
              items: _listaPeriodosContables,
            ),
            new SizedBox(
                width: double.infinity, // match_parent
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Filtrar'),
                  onPressed: () {
                    if (this._idAlumno.isNotEmpty && this._idAnho.isNotEmpty) {
                      // if (this._idAlumno.isEmpty && this._idAnho.isEmpty) {
                      Navigator.pop(context, DialogActions.SEARCH);
                      _AsistenciaPageState().reassemble();
                    }
                    // Navigator.pushReplacementNamed(context, Routes.estado_cuenta);
                    // if (_formKey.currentState.validate()) {}
                  },
                )),
          ],
        ),
      ),
    );
  }
}

/*
class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return new DropdownButton<String>(
      isExpanded: true,
      hint: new Text('Seleccione un periodo'),
      value: dropdownValue,
      underline: Container(
        height: 1,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['2019', '2020', '2021']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
*/
