import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/enums/enum.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/response_dialog_model.dart';
import 'package:school_mobile_portal/services/area.service.dart';
import 'package:school_mobile_portal/services/periodos-academicos.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/widgets/filter_periodo_aca_dialog.dart';

class NotasdPage extends StatefulWidget {
  NotasdPage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/notas';
  @override
  _NotasdPageState createState() => _NotasdPageState();
}

class _NotasdPageState extends State<NotasdPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;
  AreaService _areaService = new AreaService();
  HijoModel _currentChildSelected;
  String _currentPeriodo = '';
  //List _currentEvaUnidad = [];

  final PeriodosAcademicosService _periodoAcaService =
      new PeriodosAcademicosService();
  String _idPeriodoAcademico;

  final Map<String, String> queryParams = new Map();

//////////////////////////////////
  Map<String, dynamic> _notasAreas;
  List _periodoArea = [];
  //List<Widget> childrenPeriodoButtons = [];
  //List _allPeriodos = [];
  List<DropdownMenuItem<String>> _listaFiltroPeriodos;

  //String _currentPeriodo = '';
//////////////////////////////////
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    this.getMasters();
  }

  Future<void> refreshList() async {
    //await Future.delayed(Duration(seconds: 0));
    await _loadChildSelectedStorageFlow();
  }

  void getMasters() async {
    await this._loadChildSelectedStorageFlow();
  }

  Future _loadChildSelectedStorageFlow() async {
    await this._loadData();
    await this._getNotasAreas();
    await this._getDropDownListPeriodo();
  }

  Future _loadData() async {
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
    setState(() {});
  }

  Future _getNotasAreas() async {
    print(queryParams.toString() + '!1!!!!!!!!!');
    print(_idPeriodoAcademico.toString() + '!1!!!!!!!!!');
    print(this._currentChildSelected.idAlumno.toString() + '!1!!!!!!!!!');

    await _areaService.getStudentsEvaluationsGrid(
      //{'id_alumno': '207655', 'id_periodo': '7'},
      {
        'id_alumno': '${this._currentChildSelected.idAlumno}',
        'id_periodo': '${this._idPeriodoAcademico}'
      },
    ).then((value) {
      this._notasAreas =
          value.runtimeType.toString() == 'List<dynamic>' ? {} : value ?? {};
      if (_notasAreas != null && _notasAreas != {}) {
        List areas = _notasAreas['cursos'];
        _periodoArea = _notasAreas['periodo_notas'];
        this._currentPeriodo = '${_periodoArea[0]['nro_periodo']}';
        for (var perArea in _periodoArea) {
          List notaCursos = perArea['notas_cursos'];
          //this._allPeriodos.add(perArea);
          //print('${this._allPeriodos}' + ' ????????????????');

          // childrenPeriodoButtons
          //     .add(_getPeridoButtons('${perArea['nro_periodo']}'));
          for (var notCurso in notaCursos) {
            for (var area in areas) {
              if (notCurso['id_curso'] == area['id_curso']) {
                notCurso['nombre_curso'] = area['nombre_curso'];
                notCurso['docente'] = area['docente'];
              }
            }
          }
        }
        print(areas);
      }
    }).catchError((err) {
      print(err);
    });
    setState(() {});
    print(queryParams.toString() + '!1!!!!!!!!!');
    print(_idPeriodoAcademico.toString() + '!1!!!!!!!!!');
    print(this._currentChildSelected.idAlumno.toString() + '!1!!!!!!!!!');
  }

  _getDropDownListPeriodo() {
    if (_notasAreas != {} && _periodoArea != null)
      this._listaFiltroPeriodos = _periodoArea.map((e) {
        return DropdownMenuItem(
          value: '${e['nro_periodo']}',
          child: _getPeridoButtons('${e['nro_periodo']}'),
        );
      }).toList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) async {
          this._currentChildSelected = childSelected;
          await _loadChildSelectedStorageFlow();
        },
      ),
      appBar: AppBarLamb(
        title: Text('EVALUACIÓN'),
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
        child: Theme(
          data: LambThemes.light.copyWith(
            canvasColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            dividerColor: Colors.transparent,
            dividerTheme: DividerThemeData(color: Colors.transparent),
          ),
          child: _notasAreas == null
              ? Center(child: CircularProgressIndicator())
              : _notasAreas == {}
                  ? Center(
                      child: Text('NO HAY DATOS'),
                    )
                  //: _buildTiles(),
                  : _buildContent(),
        ),
      ),
    );
  }

  /*Widget _buildTiles() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        List notaCursos = _periodoArea[index]['notas_cursos'];
        List<Widget> children = [];
        List<Widget> childrenCompetencias = [];

        for (var notCurso in notaCursos) {
          childrenCompetencias = [];
          List competencias = notCurso['competencias'];
          for (var comp in competencias) {
            childrenCompetencias.add(
              InkWell(
                onTap: () async {
                  await showNewDialog(notCurso, comp);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 2,
                        thickness: 0.3,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width - 70,
                            child: Text(comp['descripcion_competencia']),
                          ),
                          VerticalDivider(
                            thickness: 3,
                            color: LambThemes.light.primaryColor,
                            //color: Colors.black,
                            width: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: 35,
                            child: Text(
                              comp['nota_competencia'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: LambThemes.light.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          children.add(
            Column(
              children: <Widget>[
                Divider(
                  height: 3,
                  thickness: 0.5,
                ),
                ExpansionTile(
                  backgroundColor: Colors.white.withOpacity(0.5),
                  //key: PageStorageKey<String>(notCurso['nombre_curso']),
                  title: Text(
                    notCurso['nombre_curso'],
                    style: TextStyle(fontSize: 14.5),
                  ),
                  subtitle: RichText(
                    textAlign: TextAlign.start,
                    text: new TextSpan(
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                          text: notCurso['docente'] != null ? 'DOCENTE\n' : '',
                          style: new TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        new TextSpan(
                          text: notCurso['docente'] ?? '',
                          style: new TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),

                  children: <Widget>[] + childrenCompetencias,
                ),
              ],
            ),
          );
        }
        return Column(
          children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    '${_periodoArea[index]['nro_periodo']}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 2),
                  ),
                ),
                // Divider(),
              ] +
              children,
        );
      },
      itemCount: _periodoArea.length,
    );
  }*/

  Widget _buildContent() {
    //List notaCursos = _periodoArea[0]['notas_cursos'];
    List notaCursos;
    if (_notasAreas != {} && _periodoArea != null)
      for (var perArea in _periodoArea) {
        if (perArea['nro_periodo'] == _currentPeriodo) {
          notaCursos = perArea['notas_cursos'];
        }
      }
    List<Widget> children = [];
    List<Widget> childrenCompetencias = [];

    if (_notasAreas != {} && _periodoArea != null)
      for (var notCurso in notaCursos) {
        childrenCompetencias = [];
        List competencias = notCurso['competencias'];
        for (var comp in competencias) {
          childrenCompetencias.add(
            InkWell(
              onTap: () async {
                await showNewDialog(notCurso, comp);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 0, bottom: 5),
                child: Column(
                  children: <Widget>[
                    Divider(
                      height: 0,
                      thickness: 0.3,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            comp['descripcion_competencia'] ?? '',
                            style: TextStyle(
                              //color: LambThemes.light.primaryColorDark,
                              //color: Colors.blueGrey,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.25,
                            ),
                          ),
                        ),
                        /*VerticalDivider(
                        thickness: 3,
                        color: LambThemes.light.primaryColor,
                        //color: Colors.black,
                        width: 5,
                      ),*/
                        Padding(
                          //padding:EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                          padding: EdgeInsets.only(left: 20, right: 0),
                          child: SizedBox(
                            width: 0.5,
                            height: 40,
                            child: Container(
                              color: LambThemes.light.primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          //alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 12.5),
                          width: 30,
                          child: Text(
                            comp['nota_competencia'] ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: LambThemes.light.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        children.add(
          Container(
            margin: EdgeInsets.only(top: 0, bottom: 5, left: 10, right: 10),
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
            //height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(
                  color: LambThemes.light.primaryColor,
                )),
            child: Column(
              children: <Widget>[
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
                ExpansionTile(
                  backgroundColor: Colors.transparent,
                  //key: PageStorageKey<String>(notCurso['nombre_curso']),
                  title: Text(
                    '${notCurso['nombre_curso'] ?? ''}',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: LambThemes.light.accentColor),
                  ),
                  subtitle: RichText(
                    textAlign: TextAlign.start,
                    text: new TextSpan(
                      style: new TextStyle(
                        color: LambThemes.light.accentColor,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                          text: notCurso['docente'] != null ? 'DOCENTE: ' : '',
                          style: new TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            //color: Colors.black,
                          ),
                        ),
                        new TextSpan(
                          text: notCurso['docente'] ?? '',
                          style: new TextStyle(
                              fontSize: 12,
                              //color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),

                  children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: 15, right: 0, top: 0, bottom: 0),
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 0, bottom: 0),
                              child: Text(
                                'Competencias:',
                                style: new TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  //color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(
                                left: 0,
                                right: 17.5,
                                top: 0,
                                bottom: 0,
                              ),
                              padding: EdgeInsets.only(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                              ),
                              child: Text(
                                'Eval.',
                                style: new TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: LambThemes.light.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] +
                      childrenCompetencias,
                ),
              ],
            ),
          ),
        );
      }

    return ListView(
      children: <Widget>[
            _dropDownList(),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'ÁREAS',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 15,
                      color: LambThemes.light.accentColor),
                ),
              ),
            ),
            _periodoArea == null
                ? Center(
                    child: Text('NO HAY ÁREAS'),
                  )
                : Center(),
            /*ButtonBar(
              buttonPadding: EdgeInsets.all(5),
              mainAxisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[] + childrenPeriodoButtons,
            ),*/
          ] +
          children,
    );
  }

  Widget _dropDownList() {
    return Container(
      width: 20,
      margin: EdgeInsets.only(top: 10, bottom: 5, left: 100, right: 100),
      padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          border: Border.all(
            color: LambThemes.light.primaryColor,
          )),
      child: _periodoArea == null
          ? Center(
              child: Text('No Hay Periodos'),
            )
          : InputDecorator(
              expands: false,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                //labelText: 'ESCOGER PERIODO:',
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  //focusColor: Colors.black,
                  //dropdownColor: Colors.white,
                  isExpanded: false,
                  value: this._currentPeriodo,
                  isDense: true,
                  onChanged: (String newValue) {
                    this._currentPeriodo = newValue;
                    setState(() {});
                  },
                  items: _listaFiltroPeriodos,
                ),
              ),
            ),
    );
  }

  Widget _getPeridoButtons(String text) {
    return Container(
      //padding: EdgeInsets.only(top: 30, bottom: 10),
      padding: EdgeInsets.all(0),
      child: Text(
        text ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          fontSize: 12.5,
          color: LambThemes.light.accentColor,
        ),
      ),
    );
  }

  Future showNewDialog(notCurso, comp) async {
    TextAlign textAlignLocal = TextAlign.start;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              opacity: 1,
              buttonBarPadding: 0,
              width: 300,
              //isDivider: true,
              title: 'Conclusión Descriptiva:',
              titleStyle: TextStyle(
                  fontWeight: FontWeight.w600, letterSpacing: 2, fontSize: 15),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      /* RichText(
                        textAlign: TextAlign.start,
                        text: new TextSpan(
                          style: new TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                              text: notCurso['docente'] != null
                                  ? 'DOCENTE\n'
                                  : '',
                              style: new TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                            new TextSpan(
                              text: notCurso['docente'] ?? '',
                              style: new TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('ÁREA:\n${notCurso['nombre_curso']}',
                          textAlign: textAlignLocal),
                      SizedBox(
                        height: 20,
                      ),
                      Text('COMPETENCIA:\n${comp['descripcion_competencia']}',
                          textAlign: textAlignLocal),
                      SizedBox(
                        height: 20,
                      ),
                      Text('EVALUACIÓN: ${comp['nota_competencia']}',
                          textAlign: textAlignLocal),
                      SizedBox(
                        height: 20,
                      ),*/
                      Divider(
                        thickness: 1.5,
                        color: LambThemes.light.primaryColor.withOpacity(0.5),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            bottom: 50, top: 40, left: 30, right: 30),
                        child: Text(
                          '${comp['conclusion_descriptiva'] ?? ''}',
                          textAlign: textAlignLocal,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'OK',
                    style: TextStyle(color: LambThemes.light.primaryColor),
                  ),
                )
              ]);
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
