import 'package:flutter/material.dart';
import 'package:school_mobile_portal/module/estado_cuenta_page/estado_cuenta_page.dart';
import 'package:school_mobile_portal/module/login_signup_page/login_signup_page.dart';
import 'package:school_mobile_portal/module/portal_padre_page/portal_padre_page.dart';
// import 'package:school_mobile_portal/module/autenticacion/autenticacion.dart';
import 'package:school_mobile_portal/module/root/root.dart';
import 'package:school_mobile_portal/routes/routes.dart';

import 'package:school_mobile_portal/module/dashboard/dashboard.dart';
import 'package:school_mobile_portal/services/authentication.dart';

void main() {
  // Injector.configure(Flavor.PRO);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lamb school app',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.blue),
      // home: new DashboardPage(),
      home: new RootPage(
        auth: AuthenticationService(),
      ),
      routes: {
        Routes.dashboard: (context) => DashboardPage(),
        Routes.portal_padre: (context) => PortalPadrePage(),
        Routes.estado_cuenta: (context) => EstadoCuentaPage(),
        Routes.login_signup: (context) => LoginSignupPage(
              auth: AuthenticationService(),
            ),
      },
    );
  }
}
