import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/screens/portal/agenda.dart';
import 'package:school_mobile_portal/screens/portal/asistencia.dart';
import 'package:school_mobile_portal/screens/portal/estado_cuenta.dart';

class TabBarMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.account_balance_wallet)),
                Tab(icon: Icon(Icons.perm_contact_calendar)),
              ],
            ),
            title: Text('MI PORTAL'),
          ),
          body: TabBarView(
            children: [
              Asistencia(),
              EstadoCuenta(),
              Agenda(),
            ],
          ),
        ),
      ),
    );
  }
}
