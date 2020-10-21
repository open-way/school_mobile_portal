import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';

class TerminosCondiciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    var baseUrlWeb = baseAllUrl.substring(0, baseAllUrl.length - 10);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: WebviewScaffold(
        url: '${baseUrlWeb}terms-condiciones-reserva',
        appCacheEnabled: true,
        hidden: true,
        withZoom: true,
        // withLocalStorage: true,
        initialChild: Container(
          // color: Colors.redAccent,
          child: const Center(
            child: Text("Cargando...."),
          ),
        ),
      ),
    );
  }
}
