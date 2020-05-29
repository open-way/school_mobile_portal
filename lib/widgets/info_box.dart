import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';
import 'package:school_mobile_portal/services/info.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';
import 'package:school_mobile_portal/widgets/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBox extends StatefulWidget {
  InfoBox({Key key}) : super(key: key);

  @override
  InfoBoxState createState() => InfoBoxState();
}

class InfoBoxState extends State<InfoBox> {
  final InfoService _infoService = new InfoService();
  List<Widget> _childrenInfo = [];
  List<Widget> _actionButtons = [];
  Widget _noInternet = Center();
  Widget _newVersion = Center();
  Widget _body = Center();

  @override
  void initState() {
    super.initState();
    this.getMasters();
  }

  void getMasters() {
    buildContainers();
  }

  void buildContainers() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected info_box');

        var platform = '';
        if (Platform.isAndroid) {
          platform = 'ANDROID';
        }
        if (Platform.isIOS) {
          platform = 'IOS';
        }
        var queryParameters = {
          'code_aplicacion': codeAppVersion,
          'platform': platform,
        };
        await this
            ._infoService
            .getVersion$(queryParameters)
            .then((onValue) {
          //if (onValue == info.version && Platform.isIOS) {
          if (onValue.version != info.version) {
            this._newVersion =
                _infoContainer('Descarga la nueva versión que tenemos para ti');
            this._childrenInfo.add(this._newVersion);
            this._actionButtons.add(_actionButton('Actualizar', () {
                  _launchInBrowser();
                }));
            this._actionButtons.add(_actionButton('Ahora no', () {
                  Navigator.of(context).pop();
                }));
          }
          setState(() {});
        }).catchError((err) {
          print(err);
        });
      }
    } on SocketException catch (_) {
      print('not connected $_ desde info_box');
      this._noInternet = _infoContainer(
          'Parece que no tienes acceso a internet. Por favor, revisa tu conexión e intenta nuevamente');
      this._childrenInfo.add(this._noInternet);
      this._actionButtons.add(_actionButton('Ok', () {
            Navigator.of(context).pop();
          }));
    }
    await this._bodyBuild();
  }

  Future<void> _launchInBrowser() async {
    String urlAndroid =
        'https://play.google.com/store/apps/details?id=pe.adventistas.lamb_school';
    String urlIOS = 'https://apps.apple.com/us/app/lamb-school/id1501194832';
    String url;
    if (Platform.isAndroid) {
      url = urlAndroid;
    }
    if (Platform.isIOS) {
      url = urlIOS;
    }
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
          forceWebView: true,
        );
      }
    } else {
      print('Could not launch $url');
    }
  }

  Widget _infoContainer(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      child: Text(
        '$title',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      ),
    );
  }

  Widget _actionButton(String text, void Function() onPressed) {
    return FlatButton(
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: LambThemes.light.primaryColor),
        ),
      ),
    );
  }

  _bodyBuild() {
    this._body = CustomDialog(
      title: 'Información',
      children: this._childrenInfo,
      actions: this._actionButtons,
      isDivider: true,
      width: 200,
    );
    setState(() {});
    if (this._childrenInfo.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return this._body;
  }
}
