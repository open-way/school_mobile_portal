import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/agenda_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/pages/agenda_page/filter_periodo_aca_dialog.dart';
import 'package:school_mobile_portal/services/periodos-academicos.service.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AgendaPage extends StatefulWidget {
  static const String routeName = '/agenda';

  AgendaPage({
    Key key,
    @required this.storage,
  }) : super(key: key);

  final FlutterSecureStorage storage;

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {
  final PortalPadresService portalPadresService = new PortalPadresService();
  final PeriodosAcademicosService _periodoAcaService =
      new PeriodosAcademicosService();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final Map<DateTime, List> _agendaEventos = new Map();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  final Map<String, String> queryParams = new Map();
  //String _currentIdChildSelected;
  //String _currentNameChildSelected;
  HijoModel _currentChildSelected;
  String _idPeriodoAcademico;
  String _idAnho;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    initializeDateFormatting();
    Intl.defaultLocale = 'es_PE';
    this._loadMaster();
  }

  void _loadMaster() async {
    await this._loadChildSelectedStorageFlow();

    // Usar todos los metodos que quieran al hijo actual.
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
      _calendarController.setSelectedDay(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    /*AppBar(
      title: Text('AGENDA'),
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
    );*/
    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) async {
          this._currentChildSelected = childSelected;
          this.queryParams['id_alumno'] = this._currentChildSelected.idAlumno;
          await _loadChildSelectedStorageFlow();
        },
      ),
      appBar: AppBarLamb(
        title: Text('AGENDA'),
        alumno: this._currentChildSelected,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDialog,
          ),
        ],
      ),
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
    return //new FractionallySizedBox(
        //heightFactor: 1,
        //widthFactor: 1,
        /*child:*/ ListView(
      //shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
      controller: _controllerTwo,
      //child: Column(
      children: <Widget>[
        Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.height,
            height: (MediaQuery.of(context).size.height),
            child: Column(
              children: <Widget>[
                scrollWidget(),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ],
            ),
          ),
        ])
        /*Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Expanded(child: _buildEventList()),
            ),*/
      ],
      //),
      //),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 0));
    await _loadChildSelectedStorageFlow();
    return null;
  }

  Future _loadChildSelectedStorageFlow() async {
    var now = new DateTime.now();
    DateTime selectedDay = now;
    var childSelected = await widget.storage.read(key: 'child_selected');
    var currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    this._currentChildSelected =
        this._currentChildSelected ?? currentChildSelected;
    var listaPeriodos = await this
        ._periodoAcaService
        .getAll$({'id_alumno': this._currentChildSelected.idAlumno});
    if (this.queryParams['id_alumno'] == null) {
      this.queryParams['id_alumno'] = this._currentChildSelected.idAlumno;
    }
    if (this.queryParams['id_periodo'] == null) {
      this.queryParams['id_periodo'] = listaPeriodos[0].idPeriodo;
    }
    this._idPeriodoAcademico =
        this._idPeriodoAcademico ?? this.queryParams['id_periodo'];
    try {
      this._idAnho =
          listaPeriodos[int.parse(this._idPeriodoAcademico)].anhoPeriodo;
    } catch (e) {
      print('Error: $e');
    }
    if (int.parse(this._idAnho ?? '${now.year}') == now.year) {
      selectedDay = now;
    } else {
      selectedDay = DateTime(int.parse(this._idAnho), 1, 1, 0, 0);
    }
    try {
      _calendarController.setSelectedDay(selectedDay);
    } catch (e) {
      print('Error calendar controller: $e');
    }
    _selectedEvents = _agendaEventos[DateTime.parse(
            DateFormat('yyyy-MM-dd 00:00:00.000').format(selectedDay))] ??
        [];
    setState(() {});
  }

  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();

  Widget scrollWidget() {
    return new Container(
        //height: (MediaQuery.of(context).size.height - 100) / 2,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        //child: CupertinoScrollbar(
        //  controller: _controllerOne,
        child: ListView(
          shrinkWrap: true,
          controller: _controllerOne,
          children: <Widget>[futureBuildCalendar(context)],
          //itemCount: 1,
          //itemBuilder: (BuildContext context, int index) => Column(children: <Widget>[futureBuildCalendar(context)],),
        )
        //),
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
      listDays = getDates(i, agenda);
      var days = calculateDaysInterval(listDays[0], listDays[1]);
      for (var c = 0; c < days.length; c++) {
        if (_agendaEventos[days[c]] != null) {
          _agendaEventos[days[c]].add(agenda[i].idActividad);
        } else {
          _agendaEventos[days[c]] = [agenda[i].idActividad];
        }
      }
    }
    return _agendaEventos;
  }

  Widget futureBuildCalendar(BuildContext context) {
    return new FutureBuilder(
        future: portalPadresService.getAgenda(this.queryParams),
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
      locale: 'es_PE',
      calendarController: _calendarController,
      events: _getEventosDays(agenda),
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
    );
  }

  Widget _dayBuilder(DateTime date, List events, Color txtColor) {
    var asisColor;
    final f = new DateFormat('yyyy.MM.dd');
    DateTime selectedDay = _calendarController.selectedDay;
    if (events != null) {
      asisColor = Colors.black12;
    }
    if (f.format(date) == f.format(DateTime.now())) {
      asisColor = LambThemes.light.primaryColor.withOpacity(0.5);
    }
    if (date == selectedDay) {
      asisColor = LambThemes.light.primaryColor.withOpacity(0.8);
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
          style: TextStyle(fontSize: 16.0, color: txtColor),
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
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color(hexStringToHexInt(color))),
        width: 10.0,
        height: 10.0,
      );
    } else {
      return null;
    }
  }

  _getDetalleActividad(String idActividad, List<AgendaModel> listaActividades) {
    var categoriaNombre;
    var nombre;

    for (var i = 0; i < listaActividades.length; i++) {
      categoriaNombre = listaActividades[i].categoriaNombre; //.substring(0, 6);
      nombre = listaActividades[i].nombre; //.substring(0, 5);
      if (idActividad == listaActividades[i].idActividad) {
        return [
          RichText(
              text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              new TextSpan(
                  text: '$categoriaNombre. ',
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: '$nombre'),
            ],
          )),
          Text(
            '${DateFormat('HH:mm').format(DateTime.parse(listaActividades[i].fechaInicio))}',
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
          )
        ];
      }
    }
  }

  List getDates(int i, List<AgendaModel> listaActividades) {
    DateTime startParseDate = DateTime.parse(listaActividades[i].fechaInicio);
    DateTime endParseDate = DateTime.parse(listaActividades[i].fechaFinal);
    DateTime startDate = DateTime(startParseDate.year, startParseDate.month,
        startParseDate.day, 0, 0, 0, 0, 0);
    DateTime endDate = DateTime(
        endParseDate.year, endParseDate.month, endParseDate.day, 0, 0, 0, 0, 0);
    return [startDate, endDate, startParseDate, endParseDate];
  }

  _showDetalleActividadAlert(
      String idActividad, List<AgendaModel> listaActividades) {
    int getId;
    for (var i = 0; i < listaActividades.length; i++) {
      if (idActividad == listaActividades[i].idActividad) {
        getId = i;
      }
    }
    var dayList = getDates(getId, listaActividades);
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
    var nivel = listaActividades[getId].nivel ?? '';
    var grado = listaActividades[getId].grado ?? '';
    var nivelGrado;
    if (grado != '') {
      nivelGrado = nivel + ': ' + grado;
    } else {
      nivelGrado = '';
    }
    var seccion = listaActividades[getId].seccion ?? '';
    var curso = listaActividades[getId].curso ?? '';
    return new Alert(
        context: context,
        style: alertStyle,
        title: listaActividades[getId].categoriaNombre,
        content: Column(
          children: <Widget>[
            Text(rangoFechas, textAlign: TextAlign.center),
            Text(rangoHoras, textAlign: TextAlign.center),
            Text(listaActividades[getId].nombre, textAlign: TextAlign.center),
            Text(listaActividades[getId].descripcion,
                textAlign: TextAlign.center),
            Text(nivelGrado + ' ' + seccion, textAlign: TextAlign.center),
            Text(curso, textAlign: TextAlign.center),
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
    return new FutureBuilder(
        future: portalPadresService.getAgenda(this.queryParams),
        builder: (context, AsyncSnapshot<List<AgendaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AgendaModel> agenda = snapshot.data;
            print(_selectedEvents.toString() + '121231212312312');
            List<Widget> eventList = [];
            var evenText;
            for (var i = 0; i < _selectedEvents.length; i++) {
              evenText = _getDetalleActividad(_selectedEvents[i], agenda);

              eventList.add(Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [LambThemes.light.primaryColor, Colors.white],
                    begin: Alignment(1000, 0),
                    end: Alignment(-1, 0),
                    tileMode: TileMode.repeated,
                  ),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Container(
                    //constraints: BoxConstraints(minHeight: 50),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          alignment: Alignment.center,
                          width: 30,
                          child: Text(
                            '${i + 1}.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        //Agregar LayoutBuilder
                        Container(
                          width: 210,
                          child: evenText[0],
                        ),

                        Container(
                          alignment: Alignment.centerRight,
                          child: evenText[1],
                        )
                      ],
                    ),
                  ),
                  onTap: () =>
                      _showDetalleActividadAlert(_selectedEvents[i], agenda),
                ),
              ));
            }
            return ListView(children: eventList);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future _showDialog() async {
    if (this._currentChildSelected != null) {
      ResponseDialogModel response = await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Filtrar'),
          children: <Widget>[
            new FilterPeriodoAcaDialog(
              idAlumno: this._currentChildSelected.idAlumno,
              idPeriodoDefault: this._idPeriodoAcademico,
            ),
          ],
        ),
      );

      switch (response?.action) {
        case DialogActions.SUBMIT:
          if (response.data != null) {
            this._idPeriodoAcademico = response.data;
            this.queryParams['id_periodo'] = _idPeriodoAcademico;
            await this._loadChildSelectedStorageFlow();
          }
          break;
        default:
      }
    }
  }
}
