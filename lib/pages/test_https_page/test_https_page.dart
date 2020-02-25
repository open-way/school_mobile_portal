import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/test_https_model.dart';
import 'package:school_mobile_portal/services/test-https.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class TestHttpsPage extends StatefulWidget {
  TestHttpsPage({Key key, this.testHttpsService, @required this.storage})
      : super(key: key);

  static const String routeName = '/test_https';
  final TestHttpsService testHttpsService;
  final FlutterSecureStorage storage;

  @override
  _TestHttpsPageState createState() => _TestHttpsPageState();
}

class _TestHttpsPageState extends State<TestHttpsPage> {
  String _currentIdChildSelected;

  @override
  void initState() {
    super.initState();
    this._loadChildSelectedStorageFlow();
  }

  void _loadChildSelectedStorageFlow() async {
    var idChildSelected = await widget.storage.read(key: 'id_child_selected');
    this._currentIdChildSelected = idChildSelected;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        storage: widget.storage,
        onChangeNewChildSelected: (HijoModel childSelected) {
          this._currentIdChildSelected = childSelected.idAlumno;
          setState(() {});
        },
      ),
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
