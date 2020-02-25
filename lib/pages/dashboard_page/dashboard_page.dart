import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/dashboard_model.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/services/dashboard.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.authService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/dashboard';
  final AuthService authService;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService dashboardService = new DashboardService();

  @override
  void initState() {
    super.initState();
  }

  final ScrollController _controllerOne = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
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
        future: dashboardService.getDashboard$({}),
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
        future: dashboardService.getDashboard$({}),
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
                      Navigator.pushReplacementNamed(context, Routes.agenda);
                    },
                    child: Container(
                        child: ListTile(
                            title: Text('Hoy hay $cantEventos evento(s)',
                                style: TextStyle(fontSize: 17))))));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget futureBuildAsistencias(BuildContext context) {
    return FutureBuilder(
        future: dashboardService.getDashboard$({}),
        builder: (context, AsyncSnapshot<DashboardModel> snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            DashboardModel dashboard = snapshot.data;
            var listaAsistencia = dashboard.asistencias;
            var children = <Widget>[];

            Map<String, dynamic> colores = listaAsistencia['colores'];
            List<dynamic> alumnos = listaAsistencia['alumnos'];
            for (var i = 0; i < alumnos.length; i++) {
              children.add(LayoutBuilder(
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
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.asistencia);
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
                                fontSize: 14,
                                size: 180,
                                text: Text(alumnos[i]['nombre'],
                                    style: TextStyle(fontSize: 14))))));
              }));
            }
            return Row(children: children);
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
  }*/
  Widget _cardEstadaCuenta() =>
      new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
            title: Text('Estado de Cuenta', style: TextStyle(fontSize: 19))),
        futureBuildEstadoCuenta(context)
      ]);

  Widget _circle(String importe, String texto, Color color) => new Card(
      elevation: 0,
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.estado_cuenta);
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

class CircleButton extends StatelessWidget {
  final Color color;
  final double size;
  final double circleWidth;
  final Text txt;

  const CircleButton(
      {Key key, this.color, this.size, this.circleWidth, this.txt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          border: Border(
            top: BorderSide(
                style: BorderStyle.solid, color: color, width: circleWidth),
            left: BorderSide(
                style: BorderStyle.solid, color: color, width: circleWidth),
            right: BorderSide(
                style: BorderStyle.solid, color: color, width: circleWidth),
            bottom: BorderSide(
                style: BorderStyle.solid, color: color, width: circleWidth),
          ),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Center(child: txt),
      ),
    );
  }
}

class PieChartAsistencia extends StatelessWidget {
  final Text text;
  final Map<String, double> dataMap;
  final List<Color> colorList;
  final double size;
  final double fontSize;
  const PieChartAsistencia(
      {Key key,
      this.text,
      this.dataMap,
      this.colorList,
      this.size,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        constraints: BoxConstraints(
            maxHeight: size, minHeight: size, maxWidth: size, minWidth: size),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            text,
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 0,
              chartRadius: constraints.maxHeight / 1.8,
              showChartValuesInPercentage: false,
              showChartValues: true,
              showChartValuesOutside: true,
              chartValueBackgroundColor: Colors.grey[900],
              colorList: colorList,
              showLegends: false,
              legendPosition: LegendPosition.left,
              decimalPlaces: 1,
              showChartValueLabel: false,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
                fontSize: fontSize,
              ),
              chartType: ChartType.ring,
            )
          ]));
        }));
  }
}
