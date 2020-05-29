// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class VisapaymentePage extends StatelessWidget {
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();
//   VisapaymentePage();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pago con VISA'),
//       ),
//       body: WebView(
//         // initialUrl: 'https://api-lamb.upeu.edu.pe/visa/tokens',
//         // initialUrl:
//         //     'http://app08.vitmar.lamb-dev.upeu/lamb-financial-school-api/public/mobile-api/visapayment/tokens',
//         initialUrl: 'https://es.wikipedia.org/wiki/Wikipedia:Portada',
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller.complete(webViewController);
//         },
//       ),
//     );
//   }
// }
