import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/students_my_child_model.dart';
import 'package:school_mobile_portal/pages/reserva_matricula_page/steps/actualizar_datos_page.dart';
import 'package:school_mobile_portal/services/portal.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/app_bar_lamb_reserva.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class ReservaMatriculaPage extends StatefulWidget {
  static const String routeName = '/reserva_matricula';
  final FlutterSecureStorage storage;
  final PortalService portalService;

  ReservaMatriculaPage(
      {Key key, @required this.storage, @required this.portalService})
      : super(key: key);

  @override
  _ReservaMatriculaPageState createState() => _ReservaMatriculaPageState();
}

class _ReservaMatriculaPageState extends State<ReservaMatriculaPage> {
  // HijoModel _currentChildSelected;
  String idAnho;
  List<StudentMyChildModel> _hijos;

  // getOperations() async {
  /*
    var now = new DateTime.now();
    this.idAnho = this.idAnho ?? now.year.toString();

    //this._listaOperations = [];
    var queryParameters = {
      'id_anho': this.idAnho,
      'id_alumno': this._currentChildSelected.idAlumno,
    };

    await this
        .portalPadresService
        .getEstadoCuenta$(queryParameters)
        .then((onValue) {
      _listaOperations = onValue?.movements ?? [];
      _infoTotalSaldo = onValue.movementsInfoTotal;
      _totalSaldo = onValue.movementsTotal;
      _colorSaldo = onValue.saldoColor;
    }).catchError((err) {
      print(err);
    });
    setState(() {});
    */
  // }

  @override
  void initState() {
    // print('initState --------->');
    super.initState();
    this._loadMaster();
  }

  Future _loadMaster() async {
    // await this._loadChildSelectedStorageFlow();
    await this._loadChilds();
    // this._loadUserStorage();
  }

/*
  Future _loadChildSelectedStorageFlow() async {
    var childSelected = await widget.storage.read(key: 'child_selected');
    this._currentChildSelected =
        new HijoModel.fromJson(jsonDecode(childSelected));
    setState(() {});
  }
 */

  Future _loadChilds() async {
    // this._hijos = [];

    this._hijos = await widget.portalService.getChilds$({});
    // print('Tope del precio');
    // print(_hijos[0].topePrecio);
    // print(_hijos[0].anho);
    // this._currentChildSelected =
    //     new HijoModel.fromJson(jsonDecode(childSelected));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          // this._currentChildSelected = childSelected;
          // this.getOperations();
          setState(() {});
        },
      ),
      appBar: AppBarLambReserva(
        title: Text('RESERVA MATRÍCULA'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _hijos == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: this._hijos.map(
                      (StudentMyChildModel hijo) {
                        return ChildCard(
                          hijo: hijo,
                          storage: widget.storage,
                          onBack: () {
                            this._loadMaster();
                          },
                        );
                      },
                    ).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class ChildCard extends StatefulWidget {
  ChildCard({
    Key key,
    @required this.onBack,
    this.hijo,
    this.storage,
    // this.institucionName,
    // this.periodo,
  }) : super(key: key);

  final StudentMyChildModel hijo;
  final FlutterSecureStorage storage;
  final Function onBack;

  @override
  _ChildCardState createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  final PortalService portalService = new PortalService();

  showAlertDialog(BuildContext context, StudentMyChildModel hijo) {
    Widget cancelButton = FlatButton(
      child: Text('Cancelar'),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    Widget confirmButton = FlatButton(
      child: Text('Aceptar'),
      onPressed: () async {
        // Crear reserva.
        var data = {
          'id_alumno': widget.hijo.idAlumno,
          'id_pngrado': widget.hijo.idPngrado,
        };
        await portalService.postAll$(data);

        Navigator.of(context).pop(); // dismiss dialog
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => ActualizarDatosPage(
              storage: widget.storage,
              hijo: hijo,
            ),
          ),
        )
            .then((onValue) {
          widget.onBack();
        });
      },
    );

    AlertDialog alert = new AlertDialog(
      title: Text('Confirmar'),
      content:
          Text('¿Estás seguro que quieres iniciar con el proceso de reserva?'),
      actions: <Widget>[cancelButton, confirmButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  _disabledButton(StudentMyChildModel hijo) {
    return double.parse(hijo.saldo) > 0 ||
        double.parse(hijo.cantidadVacantes) <= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.only(left: 50.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Container(
        child: new Stack(
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  // height: 90.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  '${widget.hijo.paterno} ${widget.hijo.materno} ${widget.hijo.nombre}' ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      this.widget.hijo.nombreInstitucion ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: LambThemes.light.primaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFEDEDED),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        this.widget.hijo.anho ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Año y grado de reserva',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '${this.widget.hijo.nombreGrado} ${this.widget.hijo.nombreNivel}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      this.widget.hijo.estadoReserva != 'DOC'
                          ? Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        'Requisitos:',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    (double.parse(this
                                                .widget
                                                .hijo
                                                .cantidadVacantes) >
                                            0)
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.greenAccent,
                                          )
                                        : Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                    Text(
                                      ' ${this.widget.hijo.cantidadVacantes} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        'Vancantes disponibles',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    (double.parse(this.widget.hijo.saldo) > 0)
                                        ? Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.check_circle,
                                            color: Colors.greenAccent,
                                          ),
                                    Text(
                                      ' S/. ${this.widget.hijo.saldo} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        'Deuda',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Divider(
                                      height: 0.2,
                                      color: LambThemes.light.dividerColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    color: _disabledButton(widget.hijo)
                                        ? LambThemes.light.disabledColor
                                        : (widget.hijo.idReserva == null
                                            ? LambThemes.light.accentColor
                                            : Colors.deepOrangeAccent),
                                    child: Text(
                                      widget.hijo.idReserva == null
                                          ? 'INICIAR RESERVA'
                                          : 'CONTINUAR RESERVA',
                                    ),
                                    onPressed: () {
                                      if (_disabledButton(widget.hijo)) {
                                        return null;
                                      }

                                      if (widget.hijo.idReserva == null) {
                                        showAlertDialog(
                                            context, this.widget.hijo
                                            // widget.storage,
                                            );
                                      } else {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ActualizarDatosPage(
                                              storage: widget.storage,
                                              hijo: widget.hijo,
                                            ),
                                          ),
                                        )
                                            .then((onValue) {
                                          widget.onBack();
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  // decoration: BoxDecoration(
                                  //   // color: Color(0xFFE5E5E5),
                                  //   color: Colors.greenAccent,
                                  //   borderRadius: BorderRadius.all(
                                  //     Radius.circular(10.0),
                                  //   ),
                                  // ),
                                  child: Center(
                                    child: Text(
                                      'RESERVA COMPLETADA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: LambThemes.light.accentColor,
                                        // color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
