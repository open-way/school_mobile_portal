// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// Widget build(BuildContext context) {
//   return Center(
//     child: Card(
//       child: InkWell(
//         splashColor: Colors.blue.withAlpha(30),
//         onTap: () {
//           print('Card tapped.');
//         },
//         child: Container(
//           width: 300,
//           height: 100,
//           child: Text('A card that can be tapped'),
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Asistencia extends StatelessWidget {
  // MyAppBar({this.title});

  // Los campos en una subclase de Widgets siempre están marcados como "final".

  // final Widget title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('Aquí se va mostrar el calendario'),
            subtitle: Text('Con las asistencias marcadas por el ususario.'),
          ),
          // ButtonBar(
          //   children: <Widget>[
          //     FlatButton(
          //       child: const Text('BUY TICKETS'),
          //       onPressed: () { /* ... */ },
          //     ),
          //     FlatButton(
          //       child: const Text('LISTEN'),
          //       onPressed: () { /* ... */ },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
