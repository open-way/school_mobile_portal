import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

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
        title: Text('Código de barras'),
      ),
      body: Center(
        child: Card(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                // leading: Icon(Icons.album),
                title: Text('12345678'),
                subtitle: Text('Vitmar Jhonson Aliaga Cruz.'),
              ),
              new BarCodeImage(
                params: Code39BarCodeParams(
                  '12345678',
                  lineWidth: 2.0,                // width for a single black/white bar (default: 2.0)
                  barHeight: 90.0,               // height for the entire widget (default: 100.0)
                  withText: true,                // Render with text label or not (default: false)
                ),
                onError: (error) {               // Error handler
                  print('error bar-code = $error');
                },
              ),
            ],
        ),
        ),
      ),
    );
  }
}
