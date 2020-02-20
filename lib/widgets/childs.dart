import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';

class Childs extends StatefulWidget {
  Childs({Key key, @required this.misHijosService}) : super(key: key);

  final MisHijosService misHijosService;

  @override
  _ChildsState createState() => _ChildsState();
}

class _ChildsState extends State<Childs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: FutureBuilder(
      //     future: widget.misHijosService.getAll$(),
      //     builder:
      //         (BuildContext context, AsyncSnapshot<List<HijoModel>> snapshot) {
      //       if (snapshot.hasError) print(snapshot.error);
      //       if (snapshot.hasData) {
      //         List<HijoModel> children = snapshot.data;
      //         return children
      //             .map((HijoModel res) => new ListTile(
      //                   title: 'Hola',
      //                   leading: Icon(Icons.person),
      //                   onTap: () {},
      //                 ))
      //             .toList();
      //         // return children;
      //         // }}
      //       }
      //     }),
    );
  }
}
