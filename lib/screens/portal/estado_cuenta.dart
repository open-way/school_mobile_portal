import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Operacion {
  final String glosa;
  final String fecha;
  final double importe;
  const Operacion({this.glosa, this.fecha, this.importe});
}

class _OperacionListItem extends ListTile {
  _OperacionListItem(Operacion operacion)
      // : super(
      //       title: Text(operacion.fullName),
      //       subtitle: Text(operacion.email),
      //       leading: CircleAvatar(child: Text(operacion.fullName[0])));
      : super(
            title: Text(operacion.glosa),
            subtitle: Text(operacion.fecha),
            trailing: Text('S/. ${operacion.importe.toString()}'),
            leading: CircleAvatar(child: Icon(Icons.check_box)));
            // leading: Icon(Icons.check_box));
}

class OperacionList extends StatelessWidget {
  final List<Operacion> _contacts;

  OperacionList(this._contacts);

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _buildOperacionList());
  }

  List<_OperacionListItem> _buildOperacionList() {
    return _contacts.map((contact) => _OperacionListItem(contact)).toList();
  }
}

class EstadoCuenta extends StatelessWidget {
  final kContacts = const <Operacion>[
    const Operacion(glosa: 'Por pensión', fecha: '00/00/0000', importe: 20),
    const Operacion(
        glosa: 'Por la compra de matricula', fecha: '00/00/0000', importe: 50)
  ];

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       const ListTile(
    //         leading: Icon(Icons.album),
    //         title: Text('The Enchanted Nightingale'),
    //         subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
    //       ),
    //       ButtonBar(
    //         children: <Widget>[
    //           FlatButton(
    //             child: const Text('BUY TICKETS'),
    //             onPressed: () {/* ... */},
    //           ),
    //           FlatButton(
    //             child: const Text('LISTEN'),
    //             onPressed: () {/* ... */},
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    // return Card(
    //   child: ListTile(
    //   leading: CircleAvatar(
    //     child: Text(_contact.fullName[0])
    //   ),
    //   title: Text(_contact.fullName),
    //   subtitle: Text(_contact.email)
    // ) ,
    // )
    return Card(
      child: OperacionList(kContacts),
    );
  }
}
