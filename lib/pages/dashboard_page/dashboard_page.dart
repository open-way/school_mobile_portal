import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/dashboard_model.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/routes/routes.dart';
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
  GlobalKey<RefreshIndicatorState> refreshKey;
  DashboardModel _dashboard;
  /* = new DashboardModel(
    estadoCuentaResumen: [],
    eventos: '',
    asistencias: {},
  );*/

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    this._loadDashboard();
  }

  void _loadDashboard() async {
    this._dashboard = await dashboardService.getDashboard$();
    setState(() {});
    //await dashboardService.getDashboard$().then((onValue) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
          storage: widget.storage,
          onChangeNewChildSelected: (HijoModel childSelected) {
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
    return new RefreshIndicator(
      displacement: 2,
      key: refreshKey,
      onRefresh: () async {
        _loadDashboard();
      },
      child: Container(
        child: ListView(
          children: <Widget>[
            _cardEstadoCuenta(),
            _cardEventos(),
            _cardAsistencias(),
          ],
        ),
      ),
    );
  }

  Widget futureBuildEstadoCuenta(BuildContext context) {
    if (_dashboard != null) {
      String importe = _dashboard?.estadoCuentaResumen[0]['importe'] ?? '';
      String texto = _dashboard?.estadoCuentaResumen[0]['texto'] ?? '';
      String color = _dashboard?.estadoCuentaResumen[0]['color'] ?? '0';
      print(importe);
      return _circle(importe, texto, Color(int.parse(color)));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget futureBuildEventos(BuildContext context) {
    if (_dashboard != null) {
      //DashboardModel dashboard = snapshot.data;
      var cantEventos = _dashboard.eventos;
      return Card(
          elevation: 0,
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.agenda);
              },
              child: Container(
                  child: ListTile(
                      title: Text(
                          'Tienes ${cantEventos ?? ''} evento(s) los siguientes 7 días',
                          style: TextStyle(fontSize: 17))))));
    } else {
      return Center(child: CircularProgressIndicator());
    }
    //});
  }

  Widget getLegendAsis(Color color, String estadoNombre) {
    return Padding(
        padding: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
        child: SizedBox(
            child: Container(
                color: color,
                padding: EdgeInsets.all(5),
                child: Text(estadoNombre,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)))));
  }

  Widget futureBuildAsistencias(BuildContext context) {
    if (_dashboard != null) {
      //DashboardModel dashboard = snapshot.data;
      var listaAsistencia = _dashboard.asistencias;
      var childrenCard = <Widget>[];
      var children = <Widget>[];

      Map<String, dynamic> colores = listaAsistencia['colores'];
      List<dynamic> alumnos = listaAsistencia['alumnos'];
      //children.add(Row(children: <Widget>[Text('Puntual: '), ],));
      children.add(getLegendAsis(
        Color(int.parse(colores['puntual_color'])),
        'Puntual',
      ));
      children.add(getLegendAsis(
        Color(int.parse(colores['tarde_color'])),
        'Tarde',
      ));
      children.add(getLegendAsis(
        Color(int.parse(colores['falta_color'])),
        'Falta',
      ));
      children.add(getLegendAsis(
        Color(int.parse(colores['justificado_color'])),
        'Justificado',
      ));
      var localWidth;
      if (alumnos.length > 1) {
        localWidth = MediaQuery.of(context).size.width / 2;
      } else {
        localWidth = MediaQuery.of(context).size.width / 1;
      }
      for (var i = 0; i < alumnos.length; i++) {
        childrenCard.add(
          Container(
            //color: Colors.blue,
            width: localWidth,
            child: Card(
              elevation: 0,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () async {
                  try {
                    HijoModel hijoModel = await misHijosService
                        .getHijoById(alumnos[i]['id_alumno']);
                    await widget.storage.delete(key: 'child_selected');
                    await widget.storage.write(
                        key: 'child_selected', value: hijoModel.toString());
                    Navigator.pushReplacementNamed(context, Routes.asistencia);
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
                    'P': double.parse(alumnos[i]['puntual_valor']),
                    'T': double.parse(alumnos[i]['tarde_valor']),
                    'F': double.parse(alumnos[i]['falta_valor']),
                    'J': double.parse(alumnos[i]['justificada_valor'])
                  },
                  fontSize: 0,
                  size: 180,
                  text: Text(
                    alumnos[i]['nombre'],
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      List<Widget> listaRows = [];
      if (childrenCard.length > 1) {
        Widget localWidget;
        print(childrenCard.length);
        for (var i = 0; i < childrenCard.length; i++) {
          if (i.isOdd) {
            listaRows.add(Row(
              children: <Widget>[localWidget, childrenCard[i]],
            ));
          } else {
            localWidget = childrenCard[i];
            if (i == childrenCard.length - 1) {
              listaRows.add(localWidget);
            }
          }
        }
      } else {
        listaRows = childrenCard;
      }
      return Column(
        children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children),
            ] +
            listaRows,
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
    //});
  }

  /*hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
    await storage.read(key: 'token') ?? ''
  }*/

  Widget _cardEstadoCuenta() =>
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
