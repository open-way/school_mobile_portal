import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_mobile_portal/pages/agenda_page/agenda_page.dart';
import 'package:school_mobile_portal/pages/asistencia_page/asistencia_page.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/estado_cuenta_page.dart';
import 'package:school_mobile_portal/pages/generate_barcode_page/generate_barcode_page.dart';
import 'package:school_mobile_portal/pages/login_signup_page/login_signup_page.dart';
import 'package:school_mobile_portal/pages/portal_padre_page/portal_padre_page.dart';
import 'package:school_mobile_portal/pages/dashboard_page/dashboard_page.dart';

import 'package:school_mobile_portal/pages/root_page/root_page.dart';
import 'package:school_mobile_portal/pages/test_https_page/test_https_page.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/services/test-https.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: LambThemes.light.appBarTheme.color));
    return new MaterialApp(
      title: 'Lamb school app',
      debugShowCheckedModeBanner: false,
      theme: LambThemes.light,
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
        Routes.agenda: (context) => AgendaPage(),
        Routes.generate_barcode: (context) => GenerateBarcodePage(),
        Routes.test_https: (context) => TestHttpsPage(
              testHttpsService: TestHttpsService(),
            ),
      },
    );
  }
}
