import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/services/portal-padres.dart';
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

/*class Asistencia extends StatelessWidget {
  //static const String _title = 'Table Calendar Demo';
  @override
  Widget build(BuildContext context) {
    return MyCalendarPage();
  }
}*/

class Asistencia extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<Asistencia>
    with TickerProviderStateMixin {
  final PortalPadresService portalPadresService = new PortalPadresService();
  List<AsistenciaModel> _listaAsistencias;
  final Map<DateTime, List> _asistenciaEventos = new Map();
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;

  List _justificaciones = [
    "Elegir Excusa",
    "Tengo trabajo",
    "No le gusta llegar puntual",
    "Se quemó la casa"
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

  void _getAsistencias() {
    _listaAsistencias = [];
    portalPadresService.getAsistencias().then((onValue) {
      _listaAsistencias = onValue;
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentJustificacion = _dropDownMenuItems[0].value;
    this._getMasters();
    super.initState();
    //print(this._events);
    //print(this._asistenciaEventos);

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

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void changedDropDownItem(String selectedPeriodo) {
    print("Selected city $selectedPeriodo, we are going to refresh the UI");
    setState(() {
      _currentJustificacion = selectedPeriodo;
    });
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    print(".......................");
    print(day.toString());
    print(events.toString());
    print(".......................");
    var getEstado;
    var colorEstado;
    var getResponsable;
    var getPuerta;
    var getButtonJustificar;
    if (events.isNotEmpty) {
      switch (events[0]) {
        case "P":
          getEstado = "Puntual";
          colorEstado = Colors.lightBlue;
          break;
        case "T":
          getEstado = "Tardanza";
          colorEstado = Colors.yellow[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case "F":
          getEstado = "Falta";
          colorEstado = Colors.red[300];
          getButtonJustificar = _getButtonJustificar();
          break;
        case "J":
          getEstado = "Justificación";
          colorEstado = Colors.lime;
          break;
        default:
      }
      getResponsable = events[2];
      getPuerta = events[3];
    }

    final f = new DateFormat('dd, MMMM yy');
    if (day != null) {
      animated_dialog_box.showScaleAlertBox(
        title: Column(
          children: <Widget>[
            Center(
              //child: Text(new DateFormat.yMMMd().format(day)),
              child: Text(f.format(day)),
            ),
            Container(
              child: Text('\b\b\b\b\b$getEstado!\b\b\b\b\b'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: colorEstado),
            ),
          ],
        ), // IF YOU WANT TO ADD
        context: context,
        firstButton: MaterialButton(
          // OPTIONAL BUTTON
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.lightBlue,
          child: Text('OK!'),
          onPressed: () {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
        ),
        secondButton: getButtonJustificar,
        icon: Icon(
          Icons.face,
          color: Colors.red,
        ), // IF YOU WANT TO ADD ICON
        yourWidget: Column(
          children: <Widget>[
            Container(
              child: Text('Responsable: ' + 'Fernandez Aguilar, Ana Carina'),
            ),
            Container(
              child: Text('Lugar de entrada: ' + 'Puerta N°1'),
            ),
          ],
        ),
      );
    }
  }

  Widget _getButtonJustificar() {
    return MaterialButton(
      // FIRST BUTTON IS REQUIRED
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: Colors.lime,
      child: Text('Justificar'),
      onPressed: () {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pop();
        });

        Alert(
            context: context,
            title: "Justificación",
            content: Column(
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
            buttons: [
              DialogButton(
                onPressed: () => Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                }),
                child: Text(
                  "ENVIAR",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]).show();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        futureBuild(context),
        const SizedBox(height: 8.0),
        const SizedBox(height: 8.0),
        _buildButtons(),
      ],
    );
  }

  Widget futureBuild(BuildContext context) {
    return FutureBuilder(
        future: portalPadresService.getAsistencias(),
        builder: (context, AsyncSnapshot<List<AsistenciaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AsistenciaModel> asistencias = snapshot.data;
            for (var i = 0; i < asistencias.length; i++) {
              DateTime newDateTimeObj = new DateFormat("dd/MM/yyyy HH:mm")
                  .parse(asistencias[i].fecha);
              _asistenciaEventos[newDateTimeObj] = [
                asistencias[i].estado,
                asistencias[i].periodoNombre,
                asistencias[i].responsable,
                asistencias[i].puerta
              ];
            }
            //print(asistencias.toString());

            return _buildTableCalendar(_asistenciaEventos);
            /*ListView(
              children: asistencias
                  .map(
                    (AsistenciaModel asistencia) => ListTile(
                      title: Text(asistencia.periodoNombre),
                      subtitle: Text("${asistencia.fecha}"),
                    ),
                  )
                  .toList(),
            );*/
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildTableCalendar(Map<DateTime, List> asistenciaEventos) {
    //var map =
    //asistencias.map((date, item) => (DateTime.parse(date), ));
    //print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    //print(this._asistenciaEventos);
    //print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    //_events = this._asistenciaEventos;
    //print(asistenciaEventos);
    print("----------------------------");
    print(asistenciaEventos);
    print("----------------------------");
    return TableCalendar(
      calendarController: _calendarController,
      events: asistenciaEventos,
      initialSelectedDay: DateTime.now(),
      holidays: _holidays,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          print("datedateadtedatedatedatedatedate");
          print(date);
          print("datedateadtedatedatedatedatedate");
          print("eventseventseventseventseventsevents");
          print(events);
          print("eventseventseventseventseventsevents");
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
    print("////////////////////");
    print(events.toString().substring(1, 2));
    print("////////////////////");
    if (getEventEstado == 'T') {
      asisColor = Colors.yellow[300];
    }
    if (getEventEstado == 'F') {
      asisColor = Colors.red[300];
    }
    if (getEventEstado == 'J') {
      asisColor = Colors.lime;
    }
    if (getEventEstado == 'P') {
      asisColor = Colors.lightBlue;
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
}
