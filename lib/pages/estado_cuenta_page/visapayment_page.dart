import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VisapaymentPage extends StatefulWidget {
  // VisapaymentPage({@required this.operation});
  VisapaymentPage();

  @override
  _VisapaymentPageState createState() => _VisapaymentPageState();
}

class _VisapaymentPageState extends State<VisapaymentPage> {
  InAppWebViewController webView;

  String url = "";

  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(operation['glosa']),
        title: Text('Pago con VISA'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrl:
                      'https://app08.vitmar.lamb-dev.upeu/lamb-financial-school-api/public/api/visapayment/tokens',
                  initialHeaders: {},
                  // initialData:
                  //     InAppWebViewInitialData(data: 'dato=vitmar&numero=2'),
                  initialOptions: InAppWebViewWidgetOptions(
                      // inAppWebViewOptions:
                      // crossPlatform: InAppWebViewOptions(
                      //   debuggingEnabled: true,
                      // ),
                      ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop:
                      (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
