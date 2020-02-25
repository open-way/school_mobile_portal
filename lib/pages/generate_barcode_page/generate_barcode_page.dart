import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/widgets/drawer.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

class GenerateBarcodePage extends StatefulWidget {
  GenerateBarcodePage({
    Key key,
    @required this.storage,
  }) : super(key: key);

  final FlutterSecureStorage storage;
  static const String routeName = '/generate_barcode';

  @override
  _GenerateBarcodePageState createState() => _GenerateBarcodePageState();
}

class _GenerateBarcodePageState extends State<GenerateBarcodePage> {
  String _currentIdChildSelected;

  @override
  void initState() {
    super.initState();
    this._loadChildSelectedStorageFlow();
    print('ESTOY EN GenerateBarcode');
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
        title: Text('Código de barras'),
      ),
      body: Center(
        child: Card(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                // leading: Icon(Icons.album),
                title: Text('80808080'),
                subtitle: Text('Vitmar Jhonson Aliaga Cruz.'),
              ),
              new BarCodeImage(
                params: Code39BarCodeParams(
                  '80808080',
                  lineWidth:
                      2.0, // width for a single black/white bar (default: 2.0)
                  barHeight:
                      90.0, // height for the entire widget (default: 100.0)
                  withText:
                      true, // Render with text label or not (default: false)
                ),
                onError: (error) {
                  // Error handler
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
