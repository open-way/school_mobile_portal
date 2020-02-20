import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.authService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/dashboard';
  final AuthService authService;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    print('ESTOY EN DASHBOARD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Card(
        child: Text('Dashboard page'),
      ),
    );
  }
}
