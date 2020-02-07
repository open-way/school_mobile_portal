import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key key, this.authService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/agenda';
  final AuthService authService;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      // body: ContactList());
      body: Card(
        child: Text('Agenda page'),
      ),
    );
  }
}
