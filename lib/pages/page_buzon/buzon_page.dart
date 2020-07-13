//import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/agenda_category_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
//import 'package:school_mobile_portal/pages/agenda_page/filter_periodo_aca_dialog.dart';
import 'package:school_mobile_portal/pages/page_buzon/filter_periodo_aca_dialog.dart';
//import 'package:school_mobile_portal/pages/page_buzon/nuevo_mensa_page.dart';
import 'package:school_mobile_portal/services/agenda.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
//import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
//import 'package:school_mobile_portal/widgets/custom_dialog.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';

class BuzonPage extends StatefulWidget {
  BuzonPage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/buzon';
  @override
  _BuzonPageState createState() => _BuzonPageState();
}

class _BuzonPageState extends State<BuzonPage> {
  TextEditingController _textController;
  final ScrollController _scrollController = ScrollController();
//filtros
  final AgendaService _agendaService = new AgendaService();
  //List<DropdownMenuItem<String>> _listaPeriodoAca;
  List<DropdownMenuItem<String>> _listaAgendaCategories;
  List<DropdownMenuItem<String>> _listaPeriodoNivel; //colegio
  //docente
  List<DropdownMenuItem<String>> _listaPeriodsStages;
  List<DropdownMenuItem<String>> _listaPeriodsStagesGrades;
  List<DropdownMenuItem<String>> _listaPeriodsStagesGradesSections;
  List<DropdownMenuItem<String>> _listaPeriodsStagesGradesAreas;

  String _idPNivel = '';
  String _idPNGrado = '';
  String _idPNGSeccion = '';
  String _idPNGCurso = '';
  //end docente

  String _idACategory = '';

  String _idPeriodoAcademico;
  String _idAnho;
  final Map<String, String> queryParams = new Map();
  final Map<String, dynamic> localDateTime = new Map();
  DateTime _selectedDate = DateTime.now();
  DateTime _firstDate;
  DateTime _lastDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  //TimeOfDay _firstTime;
  //TimeOfDay _lastTime;
//end filtros

  //HijoModel _currentChildSelected;
  Icon markedStar = Icon(
    Icons.star,
    color: Colors.yellow[900],
  );
  Icon notMarkedStar = Icon(Icons.star_border);
  bool isMarkedStar = false;
  bool isMarked = true;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    initializeDateFormatting('es_PE');
    //Intl.defaultLocale = 'es_PE';
    this.getMasters();
  }

  void getMasters() async {
    await this._loadChildSelectedStorageFlow();
    await this._getAgendaCate();
    await this._getPeriodStage();
    //await this._getPeriodStageGrade();
    //await this._getPeriodStageGradeSection();
    //await this._getPeriodStageGradeArea();
  }

  Future _loadChildSelectedStorageFlow() async {
    var now = new DateTime.now();
    DateTime selectedDay = now;
    this._idAnho = this._idAnho ?? now.year.toString();

    var listaPeriodos = await this._agendaService.getAllPeriodoEscolar({});
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

    //this.queryParams['id_anho'] = this._idAnho;
    if (int.parse(this._idAnho) == now.year) {
      selectedDay = now;
    } else {
      selectedDay = DateTime(int.parse(this._idAnho), 1, 1, 0, 0);
    }
    _selectedDate = selectedDay;
    DateFormat f1 = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateFormat f2 = DateFormat.yMMMd('es_PE');
    DateTime dateTime = new DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day, 0, 0);
    this.queryParams['fecha_inicio'] = '${f1.format(dateTime)}';
    this.queryParams['fecha_final'] = '${f1.format(dateTime)}';
    this.localDateTime['fecha_inicio'] = '${f2.format(dateTime)}';
    this.localDateTime['fecha_final'] = '${f2.format(dateTime)}';
    this.localDateTime['hora_inicio'] = '00:00';
    this.localDateTime['hora_final'] = '00:00';
    _firstDate = DateTime(int.parse(this._idAnho), 1, 1, 0, 0);
    _lastDate = DateTime(int.parse(this._idAnho), 12, 31, 0, 0);

    //var childSelected = await widget.storage.read(key: 'child_selected');
    //var currentChildSelected = new HijoModel.fromJson(jsonDecode(childSelected));
    //this._currentChildSelected = this._currentChildSelected ?? currentChildSelected;
    setState(() {});
  }

  Future _getAgendaCate() async {
    /*this._agendaService.getAgendaCategories().then((listSnap) {
      this._listaAgendaCategories = listSnap.map((AgendaCategoryModel snap) {
        return DropdownMenuItem(
          value: snap.idACategoria,
          child: Text(snap.nombre),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
*/
    await this._agendaService.getAgendaCategories().then((onValue) {
      this._idACategory = onValue[0].idACategoria;
      this._listaAgendaCategories = onValue.map((AgendaCategoryModel snap) {
        //this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: snap.idACategoria,
          child: Text(snap.nombre),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  Future _getPeriodStage() async {
    await this._agendaService.getMyPeriodsStages(
        {'id_periodo': _idPeriodoAcademico}).then((onValue) {
      print('$onValue !!!!!!!!!!!!!!!!!');
      //this._idPNivel = this._idPNivel ?? '${onValue[0]['id_pnivel']}';
      this._idPNivel = '${onValue[0]['id_pnivel']}';
      this._listaPeriodsStages = onValue.map((snap) {
        print('${snap['id_pnivel']} !!!!!!!!!!!!!!!!!');
        print('${snap['nombre_nivel']} !!!!!!!!!!!!!!!!!');
        //this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: '${snap['id_pnivel']}',
          child: Text('${snap['nombre_nivel']}'),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  Future _getPeriodStageGrade() async {
    await this
        ._agendaService
        .getMyPeriodsStagesGrades({'id_pnivel': _idPNivel}).then((onValue) {
      print('$onValue !!!!!!!!!!!!!!!!!');
      this._idPNGrado = this._idPNGrado ?? '${onValue[0]['id_pngrado']}';
      //this._idPNGrado = '${onValue[0]['id_pngrado']}';
      this._listaPeriodsStagesGrades = onValue.map((snap) {
        print('${snap['id_pngrado']} !!!!!!!!!!!!!!!!!');
        print('${snap['nombre_grado']} !!!!!!!!!!!!!!!!!');
        //this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: '${snap['id_pngrado']}',
          child: Text('${snap['nombre_grado']}'),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  Future _getPeriodStageGradeSection() async {
    //this._listaPeriodsStagesGradesSections = [];
    await this._agendaService.getMyPeriodsStagesGradesSections(
        {'id_pngrado': _idPNGrado}).then((onValue) {
      print('$onValue !!!!!!!!!!!!!!!!!');
      this._idPNGSeccion =
          this._idPNGSeccion ?? '${onValue[0]['id_pngseccion']}';
      this._listaPeriodsStagesGradesSections = onValue.map((snap) {
        print('${snap['id_pngseccion']} !!!!!!!!!!!!!!!!!');
        print('${snap['nombre_seccion']} !!!!!!!!!!!!!!!!!');
        //this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: '${snap['id_pngseccion']}',
          child: Text('${snap['nombre_seccion']}'),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  Future _getPeriodStageGradeArea() async {
    //this._listaPeriodsStagesGradesAreas = [];
    await this._agendaService.getMyPeriodsStagesGradesAreas({
      'id_pngrado': _idPNivel,
      'id_pngseccion': _idPNGSeccion
    }).then((onValue) {
      print('$onValue !!!!!!!!!!!!!!!!!');
      this._idPNGCurso = this._idPNGCurso ?? '${onValue[0]['id_pngcurso']}';
      this._listaPeriodsStagesGradesAreas = onValue.map((snap) {
        print('${snap['id_pngcurso']} !!!!!!!!!!!!!!!!!');
        print('${snap['nombre_curso']} !!!!!!!!!!!!!!!!!');
        //this._nombreMotivo[snap.idJmotivo] = snap.nombre;
        return DropdownMenuItem(
          value: '${snap['id_pngcurso']}',
          child: Text('${snap['nombre_curso']}'),
        );
      }).toList();
      setState(() {});
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*MaterialApp(
      title: 'Material App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'),
      ],
      home:*/
        Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) async {
          //this._currentChildSelected = childSelected;
          await _loadChildSelectedStorageFlow();
        },
      ),
      appBar: AppBar(
        title: Text('BUZÓN'),
        //alumno: this._currentChildSelected,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDialog,
          ),
        ],
      ),
      body: contenedor(),
      //),
    );
  }

  Future<DateTime> selectDate() async {
    return await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      //locale: Locale('es', 'ES'),
      builder: (context, child) {
        return /*MaterialApp(
          title: 'Material App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('es', 'PE'),
          ],
          home: Center(
            child: */
            child
            //),
            //)
            ;
      },
    );
  }

  Future<TimeOfDay> selectTime() async {
    return await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      //useRootNavigator: true,
    );
  }

  Widget _dropDownList(List<DropdownMenuItem<String>> lista, String value,
      String text, String param) {
    value = this.queryParams[param] ?? value;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: text,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: false,
          onChanged: (String newValue) {
            value = newValue;
            this.queryParams[param] = newValue;
            switch (param) {
              case 'id_pnivel':
                this._idPNivel = newValue;
                this._listaPeriodsStagesGrades = [];
                this._listaPeriodsStagesGradesSections = [];
                this._listaPeriodsStagesGradesAreas = [];
                this._idPNGrado = null;
                this._idPNGSeccion = null;
                this._idPNGCurso = null;
                this._getPeriodStageGrade();
                break;
              case 'id_pngrado':
                this._idPNGrado = newValue;
                this._listaPeriodsStagesGradesSections = [];
                this._listaPeriodsStagesGradesAreas = [];
                this._idPNGSeccion = null;
                this._idPNGCurso = null;
                this._getPeriodStageGradeSection();
                break;
              case 'id_pngseccion':
                this._idPNGSeccion = newValue;
                this._listaPeriodsStagesGradesAreas = [];
                this._idPNGCurso = null;
                this._getPeriodStageGradeArea();
                break;
              case 'id_pngcurso':
                this._idPNGCurso = newValue;
                break;
              default:
            }
            //this.getMasters();
            setState(() {});
          },
          items: lista,
        ),
      ),
    );
  }

  Widget selectDateTime(String text, String param, String funcion) {
    //final formatDate = new DateFormat.yMMMd('es_PE');
    //var formatedDate = '${f.format(DateTime.parse(this.queryParams[param] ?? ''))}';
    String stringLo = this.localDateTime[param];
    //var stringLoTime;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(text),
          FlatButton(
            child: Text(
              stringLo == null ? 'Seleccionar' : stringLo,
              style: TextStyle(
                color: LambThemes.light.primaryColor,
              ),
            ),
            onPressed: () async {
              switch (funcion) {
                case 'selectDate':
                  //var loParam = 'hora${param.replaceRange(0, 5, '')}';
                  var loDate = await selectDate();
                  //stringLo = '${formatDate.format(loDate)}';
                  if (loDate != null) {
                    DateTime horaTime = DateTime.parse(
                        this.queryParams[param] ?? '$_selectedDate');
                    this.localDateTime[param] =
                        new DateFormat.yMMMd('es_PE').format(loDate);
                    this.queryParams[param] =
                        '${DateFormat('yyyy-MM-dd HH:mm:ss').format(loDate.add(Duration(hours: horaTime.hour, minutes: horaTime.minute)))}';
                    setState(() {});
                  }
                  break;
                case 'selectTime':
                  var loParam = 'fecha${param.replaceRange(0, 4, '')}';
                  var loTime = await selectTime();
                  //stringLo = '${loTime.hour}:${loTime.minute}';
                  if (loTime != null) {
                    this.localDateTime[param] = '${loTime.format(context)}';
                    //print(this.localDateTime[param]);
                    DateTime fecha = DateTime.parse(
                        this.queryParams[loParam] ?? '$_selectedDate');
                    this.queryParams[loParam] =
                        '${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(fecha.year, fecha.month, fecha.day, loTime.hour, loTime.minute, 0, 0))}';
                    setState(() {});
                  }
                  break;
                default:
              }
            },
          )
        ],
      ),
    );
  }

  Widget contenedor() {
    List<Widget> children = [
      _dropDownList(
          this._listaPeriodsStages, this._idPNivel, 'Nivel', 'id_pnivel'),
      _dropDownList(
          this._listaPeriodsStagesGrades, this._idPNGrado, 'Año', 'id_pngrado'),
      _dropDownList(this._listaPeriodsStagesGradesSections, this._idPNGSeccion,
          'Sección', 'id_pngseccion'),
      _dropDownList(this._listaPeriodsStagesGradesAreas, this._idPNGCurso,
          'Cursos', 'id_pngcurso'),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              selectDateTime('Fecha Inicial:', 'fecha_inicio', 'selectDate'),
              selectDateTime('Fecha Final:', 'fecha_final', 'selectDate'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              selectDateTime('Hora Inicial:', 'hora_inicio', 'selectTime'),
              selectDateTime('Hora Final:', 'hora_final', 'selectTime'),
            ],
          ),
        ],
      ),
      _dropDownList(this._listaAgendaCategories, this._idACategory, 'Categoría',
          'id_acategoria'),
      new TextField(
        controller: _textController,
        obscureText: false,
        maxLines: 10,
        minLines: 1,
        scrollController: _scrollController,
        maxLength: 100,
        onSubmitted: (String newValue) {
          //this._currentDescripcionJusti = newValue;
        },
        decoration: InputDecoration(
            labelText: 'Descripción',
            counterStyle: TextStyle(color: LambThemes.light.primaryColor)),
        onChanged: (String newValue) {
          //this._currentDescripcionJusti = newValue;
        },
      ),
      RaisedButton(
        child: Text('Crear Evento'),
        onPressed: () async{
          print(this.localDateTime);
          DateFormat f1 = DateFormat('yyyyMMddHHmm');
          DateFormat f2 = DateFormat('HHmm');
          var fechaiIni = int.parse(
              f1.format(DateTime.parse(this.queryParams['fecha_inicio'])));
          var fechaFin = int.parse(
              f1.format(DateTime.parse(this.queryParams['fecha_final'])));
          var horaIni = int.parse(
              f2.format(DateTime.parse(this.queryParams['fecha_inicio'])));
          var horaFin = int.parse(
              f2.format(DateTime.parse(this.queryParams['fecha_final'])));
          if (fechaiIni >= fechaFin && horaIni >= horaFin) {
            print(
                'La hora o fecha de finalización seleccionada ocurre antes de la hora o fecha de inicio');
          } else {
            print(this.queryParams);
            print(this._idPNivel);
            print(this._idPNGrado);
            print(this._idPNGSeccion);
            print(this._idPNGCurso);
          }
          var storage = await widget.storage.readAll();
          print(storage);
        },
      ),
    ];

    return Container(
      child: Column(
        children: <Widget>[] + children,
      ),
    );
  }

  Future _showDialog() async {
    if (this._idPeriodoAcademico != null) {
      ResponseDialogModel response = await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Filtrar'),
          children: <Widget>[
            new FilterPeriodoEscolarDialog(
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
            setState(() {});
            //await this._loadChildSelectedStorageFlow();
          }
          break;
        default:
      }
    }
  }
}
