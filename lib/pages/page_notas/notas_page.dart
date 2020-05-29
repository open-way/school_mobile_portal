import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/pages/page_notas/datos_notas.dart';

class NotasdPage extends StatefulWidget {
  NotasdPage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/notas';
  @override
  _NotasdPageState createState() => _NotasdPageState();
}

class _NotasdPageState extends State<NotasdPage>
    with SingleTickerProviderStateMixin {
  HijoModel _currentChildSelected;
  /*bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);*/

  //List _alphabetCursos = NotaDato.alphabetCursos;
  //List _cursos = NotaDato.cursos;
  Map<String, dynamic> _notasCursos = NotaDato.notasCursos;
  String _currentPeriodo = '';
  Map<String, String> _currentCurso = {};
  List _currentEvaUnidad = [];
  List _comIsSelected = [];

  @override
  void initState() {
    super.initState();
    //_controller = AnimationController(vsync: this, duration: duration);
    /*_controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });*/

    //super.initState();
    this._loadChildSelectedStorageFlow();
  }

  Future _loadChildSelectedStorageFlow() async {
    var childSelected = await widget.storage.read(key: 'child_selected');
    var currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    this._currentChildSelected =
        this._currentChildSelected ?? currentChildSelected;
    setState(() {});
  }

  @override
  void dispose() {
    /*_controller.dispose();*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;*/

    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) async {
          this._currentChildSelected = childSelected;
          await _loadChildSelectedStorageFlow();
        },
      ),
      appBar: AppBarLamb(
        title: Text('NOTAS'),
        alumno: this._currentChildSelected,
      ),
      body: Theme(
        data: LambThemes.light.copyWith(
            dividerTheme: DividerThemeData(
                color: LambThemes.light.primaryColor.withOpacity(0.5))),
        child: Stack(
          children: <Widget>[
            dataTable(context),
            //draggableCard(),
            detalleContainer(),
          ],
        ),
      ),
    );
  }

  List<DataColumn> listDataColumn() {
    TextStyle headerTextStyle = TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
    List<DataColumn> datacolumn = [];
    datacolumn.add(DataColumn(
      label: Text(
        'Curso',
        style: headerTextStyle,
      ),
    ));
    for (var i = 0; i < _notasCursos['periodo_notas'].length; i++) {
      datacolumn.add(
        DataColumn(
          onSort: (n, v) {
            this._currentPeriodo =
                '${_notasCursos['periodo_notas'][i]['nro_periodo']}';
            setState(() {});
            print('${this._currentPeriodo}');
          },
          label: Text(
            '${_notasCursos['periodo_notas'][i]['nro_periodo']}',
            style: headerTextStyle,
          ),
        ),
      );
    }
    datacolumn.add(DataColumn(
        label: Text(
      'Nota\nfinal',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black),
    )));
    return datacolumn;
  }

  List<DataRow> listDataRow() {
    List<DataRow> datarow = [];
    for (var i = 0; i < _notasCursos['periodo_notas'].length; i++) {
      if (_notasCursos['periodo_notas'][i]['nro_periodo'] ==
          this._currentPeriodo) {
        for (var c = 0;
            c < _notasCursos['periodo_notas'][i]['notas_cursos'].length;
            c++) {
          if (_notasCursos['periodo_notas'][i]['notas_cursos'][c]['id_curso'] ==
              this._currentCurso['id_curso']) {
            this._currentEvaUnidad =
                _notasCursos['periodo_notas'][i]['notas_cursos'][c]['unidades'];
          }
        }
      }
    }

    for (var i = 0; i < _notasCursos['cursos'].length; i++) {
      datarow.add(DataRow(
        cells: <DataCell>[
              DataCell(

                  /*Card(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: */
                  Text(this._currentPeriodo == '' ||
                          _currentCurso['id_curso'] == ''
                      ? _notasCursos['cursos'][i]['nombre_curso']
                      : _notasCursos['cursos'][i]['nombre_abv_curso']),
                  /* ),
                  ),*/
                  onTap: () {
                this._currentCurso['id_curso'] =
                    '${_notasCursos['cursos'][i]['id_curso']}';
                this._currentCurso['nombre_curso'] =
                    '${_notasCursos['cursos'][i]['nombre_curso']}';
                this._currentCurso['docente'] =
                    '${_notasCursos['cursos'][i]['docente']}';

                print('${this._currentEvaUnidad}');
                setState(() {});
                print('${this._currentEvaUnidad}');

                print('${this._currentCurso}');
              }),
            ] +
            notaPerCurso('${_notasCursos['cursos'][i]['id_curso']}'),
      ));
    }
    return datarow;
  }

  List<DataCell> notaPerCurso(String idCurso) {
    List<DataCell> datacell = [];
    TextStyle aprTextStyle = TextStyle(color: Colors.black);
    TextStyle desaprTextStyle = TextStyle(color: Colors.red);
    String notaCursoPer = '';
    for (var i = 0; i < _notasCursos['periodo_notas'].length; i++) {
      for (var c = 0;
          c < _notasCursos['periodo_notas'][i]['notas_cursos'].length;
          c++) {
        if (_notasCursos['periodo_notas'][i]['notas_cursos'][c]['id_curso'] ==
            idCurso) {
          notaCursoPer = _notasCursos['periodo_notas'][i]['notas_cursos'][c]
              ['nota_periodo'];
          datacell.add(
            DataCell(
              Text(
                notaCursoPer,
                style: int.parse(notaCursoPer) >= 13
                    ? aprTextStyle
                    : desaprTextStyle,
              ),
              onTap: () {
                this._currentCurso['id_curso'] =
                    '${_notasCursos['cursos'][c]['id_curso']}';
                this._currentCurso['nombre_curso'] =
                    '${_notasCursos['cursos'][c]['nombre_curso']}';
                this._currentCurso['docente'] =
                    '${_notasCursos['cursos'][c]['docente']}';
                this._currentPeriodo =
                    _notasCursos['periodo_notas'][i]['nro_periodo'];
                this._currentEvaUnidad = _notasCursos['periodo_notas'][i]
                    ['notas_cursos'][c]['unidades'];
                print('${this._currentEvaUnidad}');
                setState(() {});
                print('${this._currentEvaUnidad}');

                print('${this._currentCurso}');
              },
            ),
          );
        }
      }
    }
    for (var i = 0; i < _notasCursos['cursos'].length; i++) {
      if (_notasCursos['cursos'][i]['id_curso'] == idCurso) {
        datacell.add(
          DataCell(
            Text(
              _notasCursos['cursos'][i]['nota_final'],
              style: int.parse(
                        _notasCursos['cursos'][i]['nota_final'],
                      ) >=
                      13
                  ? aprTextStyle
                  : desaprTextStyle,
            ),
            onTap: () {},
          ),
        );
      }
    }
    return datacell;
  }

  dataTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      //controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        //controller: ScrollController(),
        child: DataTable(
          columnSpacing: 25,
          //headingRowHeight: 40,
          horizontalMargin: 10,
          //dataRowHeight: 500,
          columns: <DataColumn>[] + listDataColumn(),
          rows: <DataRow>[] + listDataRow(),
        ),
      ),
    );
  }

  Widget detalleContainer() {
    /*Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => null))
        .then((onValue) {});*/
    return /*DraggableCard(
        child: */
        this._currentPeriodo == '' || _currentCurso['id_curso'] == ''
            ? Center()
            : /* AnimatedContainer(
            duration: duration,
            child: */
            Align(
                alignment: Alignment(1, -0.2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 600,
                  width: 330,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: /*Card(
                    child:*/
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                            /*SizedBox(
                        height: 50,
                        /*child: Container(
                            color: Colors.blue.withOpacity(0.5),
                          ),*/
                      ),*/
                            /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              colorBrightness: Brightness.light,
                              color: Colors.blue,
                              onPressed: null,
                              child:*/
                            Container(
                              /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),*/
                              padding: EdgeInsets.all(10),
                              //height: double.infinity,

                              child: ListTile(
                                leading: InkWell(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: LambThemes.light.primaryColor
                                        .withOpacity(0.5),
                                  ),
                                  onTap: () {
                                    this._currentPeriodo = '';
                                    setState(() {});
                                  },
                                ),
                                title: Text(
                                  '${this._currentCurso['nombre_curso']} ${this._notasCursos['periodo_mes']} ${this._currentPeriodo}',
                                  //textAlign: TextAlign.center,
                                ),
                              ),
                              //),
                              /*Text(
                                '${this._currentCurso['nombre_curso']} ${this._currentPeriodo}'),
                          ],
                        ),*/
                            ),
                            new RichText(
                              textAlign: TextAlign.center,
                              text: new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: 'DOCENTE\n',
                                    style: new TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 3),
                                  ),
                                  new TextSpan(
                                      text: '${this._currentCurso['docente']}',
                                      style: new TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                            /*ListView(
                          controller: ScrollController(keepScrollOffset: false),
                          shrinkWrap: true,
                          children: <Widget>[] + detalleDataTables(),
                        ),*/
                            //),
                          ] +
                          detalleDataTables(),
                    ),
                  ),
                ),
                // ),
                // ),
                //)
              );
  }

  List<DataTable> detalleDataTables() {
    List<DataTable> datatables = [];
    List<DataRow> datarows = [];
    //TextStyle aprTextStyle = TextStyle(color: Colors.black);
    //TextStyle desaprTextStyle = TextStyle(color: Colors.red);
    TextStyle headeraprTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle headerdesaprTextStyle =
        TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    //_comIsSelected = [];

    for (var i = 0; i < _currentEvaUnidad.length; i++) {
      datarows = [];
      for (var c = 0;
          c < this._currentEvaUnidad[i]['competencias'].length;
          c++) {
        datarows.add(
          DataRow(
            cells: <DataCell>[
              DataCell(
                  Center(
                    child: Text(
                        '${this._currentEvaUnidad[i]['competencias'][c]['descripcion_competencia']}'),
                  ),
                  onTap: () {}),
              DataCell(
                  Center(
                    child: Text(
                        '${this._currentEvaUnidad[i]['competencias'][c]['nota_competencia']}',
                        style: int.parse(
                                    '${this._currentEvaUnidad[i]['competencias'][c]['nota_competencia']}') >=
                                13
                            ? headeraprTextStyle
                            : headerdesaprTextStyle),
                  ),
                  onTap: () {}),
            ],
          ),
        );
      }
      _comIsSelected.add(true);
      datatables.add(
        DataTable(
          //key: Key('$i'),
          dataRowHeight: _comIsSelected[i] ? 0 : 50,
          columnSpacing: 0,
          columns: <DataColumn>[
            DataColumn(
              onSort: (n, s) {
                print('${_comIsSelected[i]}');
                _comIsSelected[i] = !_comIsSelected[i];
                setState(() {});
                print('${_comIsSelected[i]}');
                print('$n $s');
              },
              numeric: false,
              label: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Icon(_comIsSelected[i]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ),
                  Text(
                    '${this._currentEvaUnidad[i]['descripcion_unidad']}',
                    style: headeraprTextStyle,
                  ),
                ],
              ),
            ),
            DataColumn(
                numeric: true,
                label: Text(
                  '${this._currentEvaUnidad[i]['nota_unidad']}',
                  style: int.parse(
                              '${this._currentEvaUnidad[i]['nota_unidad']}') >=
                          13
                      ? headeraprTextStyle
                      : headerdesaprTextStyle,
                )),
          ],
          rows: <DataRow>[] + datarows,
        ),
      );
    }

    return datatables;
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;
  final Alignment alignment;
  DraggableCard({this.child, this.alignment});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment(1, -0.2);

  Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    //print('$pixelsPerSecond');
    //print('$size');

    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(1, -0.2),
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
    //pixelsPerSecond.dx > 200 ? Navigator.pop(context, '') : null;
    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      //behavior: HitTestBehavior.translucent,
      //onHorizontalDragEnd: (DragEndDetails dragEndDetails) =>_onDragUpdate(context, dragEndDetails),
      //onHorizontalDragUpdate: (DragUpdateDetails update) =>_onDragUpdate(context, update),

      onPanDown: (details) {
        _controller.stop();
      },
      /*onPanStart: (details) {
        _runAnimation(null, size);
      },*/
      onPanUpdate: (details) {
        //print(details);
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 0.5),
          );
          /*if (details.delta.dx > 10) /*+*/ {
            _dragAlignment = Alignment(1, -0.2);
          } else if (details.delta.dx < 10) /*-*/ {
            _dragAlignment = Alignment.center;
          } else {
            //_dragAlignment = Alignment.centerRight;
          }*/
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: widget.child,
      ),
    );
  }
}
