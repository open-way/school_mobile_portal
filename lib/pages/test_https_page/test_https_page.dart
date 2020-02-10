import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class TestHttpsPage extends StatefulWidget {
  TestHttpsPage({Key key, this.authService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/agenda';
  final AuthService authService;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _TestHttpsPageState createState() => _TestHttpsPageState();
}

class _TestHttpsPageState extends State<TestHttpsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Test Https'),
      ),
      // body: ContactList());
      body: Card(
        child: Text('test https page'),
      ),
    );
  }
}
