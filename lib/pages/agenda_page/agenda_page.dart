import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:school_mobile_portal/models/agenda_model.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class AgendaPage extends StatefulWidget {
  static const String routeName = '/agenda';

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {
  final PortalPadresService portalPadresService = new PortalPadresService();
  final Map<DateTime, List> _agendaEventos = new Map();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List<AgendaModel> _listaActividades;

  @override
  void initState() {
    super.initState();
    this._getMasters();
    final _selectedDay = DateTime.now();

    _selectedEvents = _agendaEventos[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  void _getMasters() {
    this._getActividades();
  }

  void _getActividades() {
    _listaActividades = [];
    portalPadresService.getAgenda().then((onValue) {
      _listaActividades = onValue;
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

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
    print(events.toString() + '----------------_onDaySelected------------');
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    print('a ver q sale aqui build build buildbuild ');
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          futureBuild(context),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  _getEventosDays(List<AgendaModel> agenda) {
    _agendaEventos.clear();
    for (var i = 0; i < agenda.length; i++) {
      var listDays = [];
      listDays.clear();
      listDays = getDates(i);
      var days = calculateDaysInterval(listDays[0], listDays[1]);
      for (var c = 0; c < days.length; c++) {
        if (_agendaEventos[days[c]] != null) {
          _agendaEventos[days[c]].add(agenda[i].idActividad);
        } else {
          _agendaEventos[days[c]] = [agenda[i].idActividad];
        }

        print(_agendaEventos.toString() + 'aqui agenda eventos!!!!!!');
      }
    }
    return _agendaEventos;
  }

  Widget futureBuild(BuildContext context) {
    return new FutureBuilder(
        future: portalPadresService.getAgenda(),
        builder: (context, AsyncSnapshot<List<AgendaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AgendaModel> agenda = snapshot.data;
            return _buildTableCalendar(agenda);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(List<AgendaModel> agenda) {
    return TableCalendar(
      calendarController: _calendarController,
      events: _getEventosDays(agenda),
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
          return _dayBuilder(date, events, Colors.black);
        },
        weekendDayBuilder: (context, date, events) {
          return _dayBuilder(date, events, Colors.black45);
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          var childWidget = <Widget>[];
          print(events.toList().toString() +
              'markersBuildermarkersBuildermarkersBuilder');
          if (events.isNotEmpty) {
            var eventsList = events.toList();
            for (var i = 0; i < agenda.length; i++) {
              for (var c = 0; c < eventsList.length; c++) {
                if (eventsList[c] == agenda[i].idActividad) {
                  childWidget.add(_buildEventsMarker(
                      [eventsList[c]], agenda[i].categoriaColor));
                }
              }
              if (childWidget.length > 4) {
                childWidget = childWidget.sublist(0, 4);
              }
            }
            var containerRow = Row(
              children: childWidget,
              mainAxisAlignment: MainAxisAlignment.center,
            );
            children.add(containerRow);
          }
          return children;
        },
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _dayBuilder(DateTime date, List events, Color txtColor) {
    var asisColor;
    if (events != null) {
      asisColor = Colors.black12;
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

  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  Widget _buildEventsMarker(List events, String color) {
    if (events.isNotEmpty) {
      var coroc = new Color(hexStringToHexInt(color));
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(shape: BoxShape.circle, color: coroc),
        width: 10.0,
        height: 10.0,
      );
    } else {
      return null;
    }
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

  _getDetalleActividad(int idActividad, List<AgendaModel> listaActividades) {
    for (var i = 0; i < listaActividades.length; i++) {
      if (idActividad == listaActividades[i].idActividad) {
        return '"' +
            listaActividades[i].categoriaNombre +
            '": ' +
            listaActividades[i].nombre;
      }
    }
  }

  List getDates(int i) {
    DateTime startParseDate = DateTime.parse(_listaActividades[i].fechaInicio);
    DateTime endParseDate = DateTime.parse(_listaActividades[i].fechaFinal);
    DateTime startDate = DateTime(startParseDate.year, startParseDate.month,
        startParseDate.day, 0, 0, 0, 0, 0);
    DateTime endDate = DateTime(
        endParseDate.year, endParseDate.month, endParseDate.day, 0, 0, 0, 0, 0);
    return [startDate, endDate, startParseDate, endParseDate];
  }

  _showDetalleActividadAlert(
      int idActividad, List<AgendaModel> listaActividades) {
    int getId;
    for (var i = 0; i < listaActividades.length; i++) {
      if (idActividad == listaActividades[i].idActividad) {
        getId = i;
      }
    }
    var dayList = getDates(getId);
    var rangoFechas;
    var rangoHoras;
    final formatoFecha = new DateFormat('EE dd, MM');
    final formatoHora = new DateFormat('HH:mm');
    if (dayList[0] == dayList[1]) {
      rangoFechas = formatoFecha.format(dayList[2]).toString();
    } else {
      rangoFechas = formatoFecha.format(dayList[2]).toString() +
          ' - ' +
          formatoFecha.format(dayList[3]).toString();
    }
    rangoHoras = formatoHora.format(dayList[2]).toString() +
        ' - ' +
        formatoHora.format(dayList[3]).toString();

    // Reusable alert style
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );
    return new Alert(
        context: context,
        style: alertStyle,
        title: listaActividades[getId].categoriaNombre,
        content: Column(
          children: <Widget>[
            Text(rangoFechas),
            Text(rangoHoras),
            Text(listaActividades[getId].nombre),
            Text(listaActividades[getId].descripcion),
            Text(listaActividades[getId].nivel +
                ': ' +
                listaActividades[getId].grado +
                ' ' +
                listaActividades[getId].seccion),
            Text(listaActividades[getId].curso),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget _buildEventList() {
    print('_selectedEvents _buildEventList' +
        _selectedEvents.toString() +
        '_selectedEvents _buildEventList');
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(_getDetalleActividad(event, _listaActividades)),
                  onTap: () => {
                    print('$event tapped!'),
                    _showDetalleActividadAlert(event, _listaActividades),
                  },
                ),
              ))
          .toList(),
    );
  }
}
