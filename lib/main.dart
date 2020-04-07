import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/pages/agenda_page/agenda_page.dart';
import 'package:school_mobile_portal/pages/asistencia_page/asistencia_page.dart';
import 'package:school_mobile_portal/pages/estado_cuenta_page/estado_cuenta_page.dart';
import 'package:school_mobile_portal/pages/generate_barcode_page/generate_barcode_page.dart';
import 'package:school_mobile_portal/pages/login_signup_page/login_signup_page.dart';
import 'package:school_mobile_portal/pages/dashboard_page/dashboard_page.dart';

import 'package:school_mobile_portal/pages/root_page/root_page.dart';
import 'package:school_mobile_portal/pages/test_https_page/test_https_page.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/services/test-https.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(0)));
    return new MaterialApp(
      title: 'Lamb School',
      debugShowCheckedModeBanner: false,
      theme: LambThemes.light,
      home: new RootPage(
        authService: AuthService(),
        misHijosService: MisHijosService(),
        storage: storage,
      ),
      routes: {
        Routes.dashboard: (context) => DashboardPage(
            // authService: AuthService(),
            storage: storage),
        Routes.estado_cuenta: (context) => EstadoCuentaPage(storage: storage),
        Routes.login_signup: (context) => LoginSignupPage(
              authService: AuthService(),
              misHijosService: MisHijosService(),
              storage: storage,
            ),
        Routes.asistencia: (context) => AsistenciaPage(
            // auth: AuthService(),
            storage: storage),
        Routes.agenda: (context) => AgendaPage(storage: storage),
        Routes.generate_barcode: (context) =>
            GenerateBarcodePage(storage: storage),
        Routes.test_https: (context) => TestHttpsPage(
              storage: storage,
              testHttpsService: TestHttpsService(),
            ),
      },
    );
  }
}
