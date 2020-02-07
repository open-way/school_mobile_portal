import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:school_mobile_portal/models/operation_model.dart';
// import 'package:school_mobile_portal/screens/portal/operation_detail.dart';
import 'package:school_mobile_portal/services/portal-padres.dart';

class EstadoCuentaScreen extends StatelessWidget {
  final PortalPadresService portalPadresService = new PortalPadresService();

  @override
  Widget build(BuildContext context) {
    // child: MyCustomForm(),
    // return Container(
    //   child: Card(
    //     child: MyCustomForm(),
    //   ),
    // );
    return Column(
      children: <Widget>[
        Container(
          child: Card(
            child: Text('Vimar'),
          ),
        ),
        Container(
          child: Card(borderOnForeground: true, child: Text('Hol')),
        )
        // Card(
        //   borderOnForeground: true,
        //   child: FutureBuilder(
        //       future: portalPadresService.getEstadoCuenta(),
        //       builder: (BuildContext context,
        //           AsyncSnapshot<List<OperationModel>> snapshot) {
        //         if (snapshot.hasError) print(snapshot.error);
        //         if (snapshot.hasData) {
        //           List<OperationModel> operations = snapshot.data;
        //           return ListView(
        //             children: operations
        //                 .map(
        //                   (OperationModel operacion) => ListTile(
        //                     title: Text(operacion.glosa),
        //                     subtitle: Text("${operacion.fecha}"),
        //                     trailing:
        //                         Text('S/. ${operacion.importe.toString()}'),
        //                     leading: CircleAvatar(child: Icon(Icons.check_box)),
        //                     onTap: () => Navigator.of(context).push(
        //                       MaterialPageRoute(
        //                         builder: (context) => OperationDetail(
        //                           operation: operacion,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 )
        //                 .toList(),
        //           );
        //         } else {
        //           return Center(child: CircularProgressIndicator());
        //         }
        //       }),
        // ),
      ],
    );

    // return Container(
    //   child:
    // );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ));
  }
}
