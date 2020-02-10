import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/routes/routes.dart';

class DrawerHeader extends StatefulWidget {
  @override
  _DrawerHeaderState createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<DrawerHeader> {
  String strUserSignIn = '';
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
    // this._getMasters();
  }

  void _readToken() async {
    final storage = new FlutterSecureStorage();
    this.strUserSignIn = await storage.read(key: 'user_sign_in') ?? '';
    this.userSignInModel =
        UserSignInModel.fromJson(jsonDecode(this.strUserSignIn));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new UserAccountsDrawerHeader(
        accountName: Text(this.userSignInModel.oauthFullname),
        accountEmail: Text(this.userSignInModel.oauthEmail),
        onDetailsPressed: () {},
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image:
                new ExactAssetImage('assets/images/oauth-school.jpg', scale: 1),
            fit: BoxFit.cover,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          // backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/46.jpg'),
          // backgroundImage: NetworkImage('https://api-lamb.upeu.edu.pe/setup_files/users/7677.JPEG'),
          backgroundImage: ExactAssetImage('assets/images/man.png'),
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
          new CircleAvatar(
            backgroundImage: new ExactAssetImage('assets/images/man.png'),
            // backgroundImage: new ExactAssetImage('assets/images/girl.png'),
          ),
          new CircleAvatar(
            backgroundImage: new ExactAssetImage('assets/images/girl.png'),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(),
          createDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.dashboard)),
          createDrawerItem(
              icon: Icons.view_agenda,
              text: 'Estado de cuenta',
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.estado_cuenta)),
          createDrawerItem(
              icon: Icons.view_agenda,
              text: 'Asistencia',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.asistencia)),
          createDrawerItem(
              icon: Icons.note,
              text: 'Agenda',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.agenda)),
          Divider(),
          createDrawerItem(
              icon: Icons.note,
              text: 'Test https',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.test_https)),
          createDrawerItem(icon: Icons.account_circle, text: 'Perfil'),
          createDrawerItem(icon: Icons.info, text: 'Acerca'),
          createDrawerItem(
              icon: Icons.power_settings_new,
              text: 'Cerrar sesión',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.login_signup)),
          // ListTile(
          //   title: Text('0.0.1'),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }

  void getNameUser() async {
    final storage = new FlutterSecureStorage();

// Store password
    // await storage.write(key: "password", value: "my-secret-password");

// Read value
    String myPassword = await storage.read(key: 'token');
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
    print(myPassword);
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
    print('');
  }

  // Widget createHeader() {
  //   return
  // }

  Widget createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      // title: Row(
      //   children: <Widget>[
      //     Icon(icon),
      //     Padding(
      //       padding: EdgeInsets.only(left: 8.0),
      //       child: Text(text),
      //     )
      //   ],
      // ),
      onTap: onTap,
    );
  }
}
