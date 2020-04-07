import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/asistencia_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/pages/asistencia_page/form_justificacion.dart';
import 'package:school_mobile_portal/services/justificaciones.service.dart';
import 'package:school_mobile_portal/services/portal-padres.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/widgets/filter_anho_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  final PortalPadresService _portalPadresService = new PortalPadresService();

  final JustificacionesService _justificacionesService =
      new JustificacionesService();
  GlobalKey<RefreshIndicatorState> _refreshKey;

  AnimationController _animationController;
  CalendarController _calendarController;

  final Map<String, String> _queryParams = new Map();
  String _idAnho;
  HijoModel _currentChildSelected;

  @override
  void initState() {
    super.initState();
    this._refreshKey = GlobalKey<RefreshIndicatorState>();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    initializeDateFormatting();
    Intl.defaultLocale = 'es_PE';
    this._loadChildSelectedStorageFlow();
  }

  void _loadChildSelectedStorageFlow() async {
    var now = new DateTime.now();
    DateTime selectedDay = now;
    this._idAnho = this._idAnho ?? now.year.toString();
    var childSelected = await widget.storage.read(key: 'child_selected');
    var currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    this._currentChildSelected =
        this._currentChildSelected ?? currentChildSelected;
    if (this._queryParams['id_alumno'] == null) {
      this._queryParams['id_alumno'] = this._currentChildSelected.idAlumno;
    }
    this._queryParams['id_anho'] = this._idAnho;
    if (int.parse(this._idAnho) == now.year) {
      selectedDay = now;
    } else {
      selectedDay = DateTime(int.parse(this._idAnho), 1, 1, 0, 0);
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
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Future _onDaySelected(DateTime day, List events) async {
    final f = new DateFormat('dd, MMMM yyyy');

    if (events.isNotEmpty) {
      if (day != null) {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              opacity: 1,
              width: 250,
              title: f.format(day),
              buttonBarPadding: 40,
              children: <Widget>[
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: CupertinoScrollbar(
                    controller: _controllerOne,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _controllerOne,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) =>
                          detalleAsistenciasDia(day),
                    ),
                  ),
                ),
              ],
              floatingActionButton: Container(
                height: 40,
                width: 70,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusElevation: 0,
                  highlightElevation: 0,
                  elevation: 0,
                  isExtended: true,
                  backgroundColor: LambThemes.light.primaryColor,
                  child: Text('Ok!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
      }
    }
  }

  void showJustificacion(AsistenciaModel listaAsistencia) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              width: double.minPositive,
              opacity: 1,
              title: 'Justificación',
              children: <Widget>[
                Center(
                    child: Text(listaAsistencia.justificacionMotivo ?? '',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 17, color: Color(0x99000000)))),
                Center(
                    child: Text(listaAsistencia.justificacionDescripcion ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black45))),
              ],
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '  Ok  ',
                      style: TextStyle(
                        color: LambThemes.light.primaryColor,
                      ),
                    ))
              ]);
        });
  }

  Future showResNewJustificacion(String message) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            opacity: 1,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  '$message',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              )
            ],
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: LambThemes.light.primaryColor,
                  ),
                ),
              )
            ],
          );
        });
  }

  Future newJustificacion(AsistenciaModel listaAsistencia) async {
    ResponseDialogModel response = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormJustificacion()));

    switch (response?.action) {
      case DialogActions.SUBMIT:
        if (response.data != null) {
          Navigator.of(context).pop();
          final Map<String, String> postParams = new Map();
          //postParams.addAll(response.data);
          postParams['id_jmotivo'] = response.data['id_jmotivo'];
          postParams['descripcion'] = response.data['descripcion'];
          postParams['id_asistencia'] = listaAsistencia.idAsistencia;
          postParams['archivo'] = response.data['archivo'];
          await this
              ._justificacionesService
              .postAll$(postParams)
              .then((onValue) async {
            print(onValue);
            if (int.parse(onValue).isNaN) {
              await showResNewJustificacion(
                  'Ocurrió un error, intentar de nuevo.');
            } else {
              await showResNewJustificacion(
                  'La justificación se envió con éxito');
            }
          }).catchError((onError) async {
            await showResNewJustificacion(
                'Ocurrió un error, intentar de nuevo.');
          });
        }
        break;
      case DialogActions.CANCEL:
        break;
      default:
    }
  }

  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          this._currentChildSelected = childSelected;
          this._queryParams['id_alumno'] = this._currentChildSelected.idAlumno;
          _loadChildSelectedStorageFlow();
        },
      ),
      appBar: AppBarLamb(
        title: Text('ASISTENCIA'),
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
        key: this._refreshKey,
        onRefresh: () async {
          await refreshList();
        },
        child: _calendarBox(),
      ),
    );
  }

  Widget _calendarBox() {
    return ListView(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
      controller: _controllerTwo,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height,
                child: futureBuild(context)),
          ],
        ),
      ],
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 0));
    _loadChildSelectedStorageFlow();
    return null;
  }

  Widget futureBuild(BuildContext context) {
    return FutureBuilder(
        future: this._portalPadresService.getAsistencias(this._queryParams),
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
      locale: 'es_PE',
      calendarController: _calendarController,
      startDay: DateTime(int.parse(this._idAnho), 1, 1, 0, 0),
      endDay: DateTime(int.parse(this._idAnho), 12, 31, 0, 0),
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
        future: this._portalPadresService.getAsistencias(this._queryParams),
        builder: (context, AsyncSnapshot<List<AsistenciaModel>> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<AsistenciaModel> asistencias = snapshot.data;
            final f = new DateFormat('dd/MM/yyyy');
            final children = <Widget>[];
            Color cardColor = Colors.transparent;
            int counter = 0;
            for (var i = 0; i < asistencias.length; i++) {
              if (f.format(DateTime.parse(asistencias[i].fechaRegistro)) ==
                  f.format(day)) {
                cardColor = counter == 0
                    ? cardColor
                    : LambThemes.light.backgroundColor.withOpacity(0.2);
                counter = counter == 0 ? 1 : 0;
                children
                    .add(buildDetalleAsistencias(asistencias[i], cardColor));
              }
            }
            return Column(children: children);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildDetalleAsistencias(AsistenciaModel asistencia, Color cardColor) {
    var getEstado = getEstadoColor(asistencia);
    String periodoNombre = asistencia.periodoNombre ?? '';
    String estado = getEstado[0];
    Color color = Color(int.parse(getEstado[1]));
    Widget buttonJustificar = getEstado[2];
    String responsable = asistencia.responsable;
    String puerta = asistencia.puerta;

    TextStyle titTextStyle =
        TextStyle(fontWeight: FontWeight.w700, fontSize: 14);
    TextStyle subTextStyle =
        TextStyle(fontWeight: FontWeight.w300, fontSize: 13);
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      color: cardColor,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        color: Colors.transparent,
        margin: EdgeInsets.all(0),
        child: Container(
          width: 200,
          alignment: Alignment.center,
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.album, color: color),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(periodoNombre, style: titTextStyle),
                      Text(estado, style: subTextStyle),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(null),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                          DateFormat('HH:mm')
                              .format(DateTime.parse(asistencia.fechaRegistro))
                              .toString(),
                          style: titTextStyle),
                      Text(responsable, style: subTextStyle),
                      Text(puerta, style: titTextStyle),
                    ],
                  ),
                ],
              ),
              ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding: EdgeInsets.all(0),
                  children: <Widget>[buttonJustificar]),
            ],
          ),
        ),
      ),
    );
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
            //cierra _onDaySelected Navigator.of(context).pop();
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
    if (this._currentChildSelected != null) {
      ResponseDialogModel response = await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Filtrar'),
          children: <Widget>[
            new FilterAnhoDialog(
              idAlumno: this._currentChildSelected.idAlumno,
              idAnhoDefault: this._idAnho,
            ),
          ],
        ),
      );

      switch (response?.action) {
        case DialogActions.SUBMIT:
          if (response.data != null) {
            this._idAnho = response.data;
            this._queryParams['id_anho'] = response.data;
            this._loadChildSelectedStorageFlow();
          }
          break;
        default:
      }
    }
  }
}
