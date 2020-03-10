import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/dashboard_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/pages/agenda_page/agenda_page.dart';
import 'package:school_mobile_portal/pages/asistencia_page/asistencia_page.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/estado_cuenta_page.dart';
import 'package:school_mobile_portal/services/dashboard.service.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:school_mobile_portal/pages/dashboard_page/circle_button.dart';
import 'package:school_mobile_portal/pages/dashboard_page/pie_chart_asis.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, @required this.storage}) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService dashboardService = new DashboardService();
  final MisHijosService misHijosService = new MisHijosService();

  @override
  void initState() {
    super.initState();
    //this._loadMaster();
  }

  //Future _loadMaster() async {
  // Usar todos los metodos que quieran al hijo actual.
  //}

  final ScrollController _controllerOne = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
          storage: widget.storage,
          onChangeNewChildSelected: (HijoModel childSelected) {
            // this._currentIdChildSelected = childSelected.idAlumno;
            setState(() {});
          }),
      appBar: AppBar(
        title: Text('DASHBOARD'),
        centerTitle: true,
      ),
      body: scrollWidget(),
    );
  }

  Widget scrollWidget() {
    return new Container(
      child: CupertinoScrollbar(
          controller: _controllerOne,
          child: ListView.builder(
            controller: _controllerOne,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) => Column(
              children: <Widget>[
                _cardEstadaCuenta(),
                _cardEventos(),
                _cardAsistencias(),
              ],
            ),
          )),
    );
  }

  Widget futureBuildEstadoCuenta(BuildContext context) {
    return FutureBuilder(
        future: dashboardService.getDashboard$(),
        builder: (context, AsyncSnapshot<DashboardModel> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            DashboardModel dashboard = snapshot.data;
            var importe = dashboard.estadoCuentaResumen[0]['importe'];
            var texto = dashboard.estadoCuentaResumen[0]['texto'];
            var color = dashboard.estadoCuentaResumen[0]['color'];

            return _circle(importe, texto, Color(int.parse(color)));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget futureBuildEventos(BuildContext context) {
    return FutureBuilder(
        future: dashboardService.getDashboard$(),
        builder: (context, AsyncSnapshot<DashboardModel> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            DashboardModel dashboard = snapshot.data;
            var cantEventos = dashboard.eventos;

            return Card(
                elevation: 0,
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AgendaPage(storage: widget.storage)));
                    },
                    child: Container(
                        child: ListTile(
                            title: Text(
                                'Tienes $cantEventos evento(s) los siguientes 7 días',
                                style: TextStyle(fontSize: 17))))));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget futureBuildAsistencias(BuildContext context) {
    return FutureBuilder(
        future: dashboardService.getDashboard$(),
        builder: (context, AsyncSnapshot<DashboardModel> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            DashboardModel dashboard = snapshot.data;
            var listaAsistencia = dashboard.asistencias;
            var childrenCard = <Widget>[];
            var children = <Widget>[];

            Map<String, dynamic> colores = listaAsistencia['colores'];
            List<dynamic> alumnos = listaAsistencia['alumnos'];
            //children.add(Row(children: <Widget>[Text('Puntual: '), ],));
            children.add(Padding(
                padding: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
                child: SizedBox(
                    child: Container(
                        color: Color(int.parse(colores['puntual_color'])),
                        padding: EdgeInsets.all(5),
                        child: Text('Puntual',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800))))));
            children.add(Padding(
                padding: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
                child: SizedBox(
                    child: Container(
                        color: Color(int.parse(colores['tarde_color'])),
                        padding: EdgeInsets.all(5),
                        child: Text('Tarde',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800))))));
            children.add(Padding(
                padding: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
                child: SizedBox(
                    child: Container(
                        color: Color(int.parse(colores['falta_color'])),
                        padding: EdgeInsets.all(5),
                        child: Text('Falta',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800))))));
            children.add(Padding(
                padding: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
                child: SizedBox(
                    child: Container(
                        color: Color(int.parse(colores['justificado_color'])),
                        padding: EdgeInsets.all(5),
                        child: Text('Justificado',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800))))));
            for (var i = 0; i < alumnos.length; i++) {
              childrenCard.add(LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                var localWidth;
                if (alumnos.length > 1) {
                  localWidth = MediaQuery.of(context).size.width / 2;
                } else {
                  localWidth = MediaQuery.of(context).size.width / 1;
                }
                return Container(
                    width: localWidth,
                    child: Card(
                        elevation: 0,
                        child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () async {
                              try {
                                HijoModel hijoModel = await misHijosService
                                    .getHijoById(alumnos[i]['id_alumno']);
                                await widget.storage
                                    .delete(key: 'child_selected');
                                await widget.storage.write(
                                    key: 'child_selected',
                                    value: hijoModel.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AsistenciaPage(
                                              storage: widget.storage,
                                            )));
                              } catch (e) {
                                print('Error: $e');
                              }
                            },
                            child: PieChartAsistencia(
                                colorList: [
                                  Color(int.parse(colores['puntual_color'])),
                                  Color(int.parse(colores['tarde_color'])),
                                  Color(int.parse(colores['falta_color'])),
                                  Color(int.parse(colores['justificado_color']))
                                ],
                                dataMap: {
                                  'P':
                                      double.parse(alumnos[i]['puntual_valor']),
                                  'T': double.parse(alumnos[i]['tarde_valor']),
                                  'F': double.parse(alumnos[i]['falta_valor']),
                                  'J': double.parse(
                                      alumnos[i]['justificada_valor'])
                                },
                                fontSize: 0,
                                size: 180,
                                text: Text(alumnos[i]['nombre'],
                                    style: TextStyle(fontSize: 14))))));
              }));
            }
            return Column(
              children: <Widget>[
                Row(children: children),
                Row(children: childrenCard)
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  /*hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
    await storage.read(key: 'token') ?? ''
  }*/

  Widget _cardEstadaCuenta() =>
      new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          title: Text('Estado de Cuenta', style: TextStyle(fontSize: 19)),
          // subtitle: Text('None'),
          // subtitle: Text(this._currentChildSelected?.idAlumno ?? 'None'),
        ),
        futureBuildEstadoCuenta(context)
      ]);

  Widget _circle(String importe, String texto, Color color) => new Card(
      elevation: 0,
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EstadoCuentaPage(storage: widget.storage)));
          },
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: CircleButton(
                      color: color,
                      size: 150,
                      circleWidth: 7,
                      txt: Text('$importe', style: TextStyle(fontSize: 26)))),
              ListTile(subtitle: Text('$texto'))
            ],
          )));

  /*Widget _cardEsdadoCuenta(String saldo, Color color) => new Card(
        color: color,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgendaPage()),
            );
          },
          child: Container(
            child: ListTile(
              title: Text('Estado de Cuenta', style: TextStyle(fontSize: 19)),
              subtitle: Text('S/. $saldo',
                  style: TextStyle(
                    fontSize: 19,
                  )),
            ),
          ),
        ),
      );*/

  Widget _cardEventos() => new Column(children: <Widget>[
        ListTile(title: Text('Eventos', style: TextStyle(fontSize: 19))),
        futureBuildEventos(context)
      ]);

  Widget _cardAsistencias() {
    var card = Column(children: <Widget>[
      ListTile(title: Text('Asistencias', style: TextStyle(fontSize: 19))),
      futureBuildAsistencias(context)
    ]);
    return card;
  }
}
