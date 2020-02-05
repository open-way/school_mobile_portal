import 'package:flutter/material.dart';
import 'package:school_mobile_portal/routes/routes.dart';

// class AppDrawer extends StatefulWidget {
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createHeader(),
          createDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.dashboard)),
          createDrawerItem(
              icon: Icons.view_agenda,
              text: 'Portal padre',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.portal_padre)),
          createDrawerItem(
              icon: Icons.view_agenda,
              text: 'Estado de cuenta',
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.estado_cuenta)),
          // createDrawerItem(
          //     icon: Icons.note,
          //     text: 'Notes',
          //     onTap: () =>
          //         Navigator.pushReplacementNamed(context, Routes.notes)),
          Divider(),
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

  Widget createHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text('Vitmar J. Aliaga Cruz'),
      accountEmail: Text('vitmar.aliaga@adventistas.org'),
      onDetailsPressed: () {},
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image:
              new ExactAssetImage('assets/images/oauth-school.jpg', scale: 1),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        // // backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/46.jpg'),
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
    );
  }

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
