import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';

class GenerateBarcodePage extends StatefulWidget {
  GenerateBarcodePage({Key key, this.authService, this.userId, this.logoutCallback})
      : super(key: key);

  static const String routeName = '/generate_barcode';
  final AuthService authService;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _GenerateBarcodePageState createState() => _GenerateBarcodePageState();
}

class _GenerateBarcodePageState extends State<GenerateBarcodePage> {
  @override
  void initState() {
    super.initState();
    print('ESTOY EN GenerateBarcode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('GenerateBarcode'),
      ),
      body: Card(
        child: Text('GenerateBarcode page'),
      ),
    );
  }
}
