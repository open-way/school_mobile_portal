import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

enum MENUS { MENU_PRINCIPAL, MENU_SECUNDARIO }

class DrawerHeader extends StatefulWidget {
  final VoidCallback onChangeMenu;
  final HijoModel chilSelected;
  DrawerHeader(
      {Key key,
      @required this.onChangeMenu,
      @required this.chilSelected,
      @required this.storage})
      : super(key: key);

  final FlutterSecureStorage storage;

  @override
  _DrawerHeaderState createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<DrawerHeader> {
  // String strUserSignIn = '';
  UserSignInModel userSignInModel;

  String token = '';
  String fullname = '';
  String oauthFullname = '';
  String oauthEmail = '';
  String imagenUrl = '';

  @override
  void initState() {
    super.initState();
    this._readToken();
  }

  void _readToken() async {
    final strUserSignIn = await widget.storage.read(key: 'user_sign_in') ?? '';
    if (strUserSignIn.isNotEmpty) {
      this.userSignInModel =
          UserSignInModel.fromJson(jsonDecode(strUserSignIn));
    }
    print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><');
    print(userSignInModel.imagenUrl);
    print('=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new UserAccountsDrawerHeader(
        accountName: Text(this.userSignInModel?.oauthFullname ?? ''),
        accountEmail: Text(this.userSignInModel?.oauthEmail ?? ''),
        onDetailsPressed: () {
          widget.onChangeMenu();
        },
        decoration: new BoxDecoration(
          color: LambThemes.light.primaryColor,
          /*image: new DecorationImage(
              image:
                  new ExactAssetImage('assets/images/oauth-school.jpg', scale: 1),
              fit: BoxFit.cover,
            ),*/
        ),
        currentAccountPicture: CircleAvatar(
          child: InkWell(
            onTap: () {
              print('Click en principal');
            },
          ),
          // https://api-lamb.upeu.edu.pe/setup_files/users/20145.PNG
          // backgroundImage: NetworkImage(userSignInModel?.imagenUrl ?? ''),
          backgroundImage: NetworkImage(userSignInModel?.imagenUrl ?? ''),

          // backgroundColor: Color.
          // backgroundColor: Color.blue,
          // Theme.of(context).platform == TargetPlatform.iOS
          //     ? Colors.blue
          //     : Colors.white,
          // child: Text(
          //   "A",
          //   style: TextStyle(fontSize: 40.0),
          // ),
        ),
        otherAccountsPictures: <Widget>[
          // widget?.chilSelected ??
          /*new CircleAvatar(
            child: InkWell(
              onTap: () {
                print(widget?.chilSelected?.nombre);
              },
            ),
            backgroundImage: new ExactAssetImage('assets/images/girl.png'),
          ),*/
        ],
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  // final void Function({@required dynamic childSelected})
  //     onChangeNewChildSelected;
  final void Function(HijoModel childSelected) onChangeNewChildSelected;
  final FlutterSecureStorage storage;

  AppDrawer(
      {Key key,
      @required this.storage,
      @required this.onChangeNewChildSelected})
      : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  MENUS myMenu = MENUS.MENU_PRINCIPAL;
  List<HijoModel> _misHijos = [];

  HijoModel _chilSelected;

  // MisHijosService misHijosService = new MisHijosService();

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            canvasColor: LambThemes.light.accentColor,
            dividerTheme: DividerThemeData(
                color: LambThemes.light.dividerColor,
                thickness: LambThemes.light.dividerTheme.thickness)),
        child: Drawer(
          child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                    new DrawerHeader(
                      onChangeMenu: () {
                        this.changeMenu();
                      },
                      chilSelected: this._chilSelected,
                      storage: widget.storage,
                    ),
                  ] +
                  this.configMenu(context)),
        ));
  }

  @override
  void initState() {
    super.initState();
    this._getHijos();
  }

  void _getHijos() async {
    this._misHijos = [];
    final hijosString = await widget.storage.read(key: 'hijos') ?? '';
    if (hijosString.isNotEmpty) {
      final body = jsonDecode(hijosString);
      final hijos =
          body.map<HijoModel>((json) => HijoModel.fromJson(json)).toList();
      this._misHijos = hijos;
      setState(() {});
    }
  }

  void onChangeSeleted(newSelected) async {
    // Enviar al los hijos el hijo seleccionado y guardar en el storage.
    this._chilSelected = newSelected;
    widget.onChangeNewChildSelected(newSelected);
    // await widget.storage.delete(key: 'id_child_selected');
    await widget.storage.delete(key: 'child_selected');
    await widget.storage
        // .write(key: 'id_child_selected', value: newSelected.idAlumno);
        .write(key: 'child_selected', value: newSelected.toString());
  }

  void changeMenu() {
    myMenu = myMenu == MENUS.MENU_PRINCIPAL
        ? MENUS.MENU_SECUNDARIO
        : MENUS.MENU_PRINCIPAL;
    setState(() {});
  }

  List<Widget> configMenu(BuildContext context) {
    return this.myMenu == MENUS.MENU_PRINCIPAL
        ? this.getMenuPrincipal(context)
        : this.getMenuChildrens(context);
  }

  List<Widget> getMenuPrincipal(BuildContext context) {
    return [
      createDrawerItem(
        icon: Icons.dashboard,
        text: Text('Dashboard'),
        onTap: () => Navigator.pushReplacementNamed(context, Routes.dashboard),
      ),
      createDrawerItem(
        icon: Icons.view_agenda,
        text: Text('Estado de cuenta'),
        onTap: () =>
            Navigator.pushReplacementNamed(context, Routes.estado_cuenta),
      ),
      createDrawerItem(
        icon: Icons.calendar_today,
        text: Text('Asistencia'),
        onTap: () => Navigator.pushReplacementNamed(context, Routes.asistencia),
      ),
      createDrawerItem(
        icon: Icons.note,
        text: Text('Agenda'),
        onTap: () => Navigator.pushReplacementNamed(context, Routes.agenda),
        //onTap: () => Navigator.pushNamed(context, '/agenda'),
      ),
      createDrawerItem(
        icon: Icons.call_to_action,
        text: Text('Generar barcode'),
        onTap: () =>
            Navigator.pushReplacementNamed(context, Routes.generate_barcode),
      ),
      // createDrawerItem(
      //     icon: Icons.note,
      //     text: 'Test https',
      //     onTap: () =>
      //         Navigator.pushReplacementNamed(context, Routes.test_https)),
      // createDrawerItem(icon: Icons.account_circle, text: 'Perfil'),
      // createDrawerItem(icon: Icons.info, text: 'Acerca'),
      createDrawerItem(
        icon: Icons.power_settings_new,
        text: Text('Cerrar sesión'),
        onTap: () =>
            Navigator.pushReplacementNamed(context, Routes.login_signup),
      ),
    ];
  }

  List<Widget> getMenuChildrens(BuildContext context) {
    return this._misHijos.map((HijoModel res) {
      return createDrawerItem(
        icon: Icons.person,
        text: RichText(
            text: new TextSpan(
          style: new TextStyle(),
          children: <TextSpan>[
            new TextSpan(
              text: '${res.nombre} ${res.paterno} ${res.materno}',
              style: new TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            new TextSpan(
                text: '\n${res.institucionNombre ?? ''}',
                style:
                    new TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
          ],
        )),
        onTap: () {
          this.onChangeSeleted(res);
          this.changeMenu();
        },
      );
    }).toList();
  }

  Widget createDrawerItem(
      {IconData icon, Widget text, GestureTapCallback onTap}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: text,
          leading: Icon(
            icon,
            color: LambThemes.light.textTheme.body2.color,
          ),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
