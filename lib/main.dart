import 'package:flutter/material.dart';
import 'package:school_mobile_portal/pages/asistencia_page/asistencia_page.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/estado_cuenta_page.dart';
import 'package:school_mobile_portal/pages/login_signup_page/login_signup_page.dart';
import 'package:school_mobile_portal/pages/portal_padre_page/portal_padre_page.dart';
import 'package:school_mobile_portal/pages/dashboard_page/dashboard_page.dart';

import 'package:school_mobile_portal/pages/root/root.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/auth.service.dart';

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
        authService: AuthService(),
      ),
      routes: {
        Routes.dashboard: (context) => DashboardPage(),
        Routes.portal_padre: (context) => PortalPadrePage(),
        Routes.estado_cuenta: (context) => EstadoCuentaPage(),
        Routes.login_signup: (context) =>
            LoginSignupPage(authService: AuthService()),
        Routes.asistencia: (context) => AsistenciaPage(
            // auth: AuthService(),
            ),
      },
    );
  }
}
