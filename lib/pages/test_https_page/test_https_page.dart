import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/test_https_model.dart';
import 'package:school_mobile_portal/services/test-https.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class TestHttpsPage extends StatefulWidget {
  TestHttpsPage(
      {Key key, this.testHttpsService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/test_https';
  final TestHttpsService testHttpsService;
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
        child: FutureBuilder(
            future: widget.testHttpsService.testHttps$(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TestHttpsModel>> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                print('Has errors');
                // return Text(snapshot.error);
                // print(snapshot.data);
              }
              if (snapshot.hasData) {
                for (final persona in snapshot.data) {
                  print(persona.email);
                  return Text(persona.email);
                }
                // print(snapshot.data.);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
