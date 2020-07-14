import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/pages/dashboard_page/dashboard_page.dart';
import 'package:school_mobile_portal/pages/auth/login_signup_page/login_signup_page.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/widgets/info_box.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage(
      {@required this.authService,
      @required this.storage,
      @required this.misHijosService});

  final AuthService authService;
  final FlutterSecureStorage storage;
  final MisHijosService misHijosService;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  // String _userToken = '';
  UserSignInModel userSignInModel;
  // final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    this._readToken();
    WidgetsBinding.instance.addPostFrameCallback((_) => showNewDialog());
  }

  void _readToken() async {
    final strUserSignIn = await widget.storage.read(key: 'user_sign_in') ?? '';
    //final strAll = await widget.storage.readAll() ?? '';
    // await storage.deleteAll();
    //print(strUserSignIn.toString() + '??????????');
    //print(strAll.toString() + '??????????');
    if (strUserSignIn.isNotEmpty) {
      this.userSignInModel =
          UserSignInModel.fromJson(jsonDecode(strUserSignIn));
      // this._userToken = this.userSignInModel.token;
      if (this.userSignInModel.token != null) {
        // _userToken = this.userSignInModel?.token;
      }
      authStatus = this.userSignInModel?.token == null
          ? AuthStatus.NOT_LOGGED_IN
          : AuthStatus.LOGGED_IN;
    } else {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    }
    setState(() {});
  }

  void loginCallback() {
    // widget.authService.getCurrentUser().then((user) {
    //   setState(() {
    //     _userToken = user.uid.toString();
    //   });
    // });
    // setState(() {
    //   authStatus = AuthStatus.LOGGED_IN;
    // });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      // _userToken = '';
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future showNewDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        //widget.storage.delete(key: 'auth_status');
        //widget.storage.write(key: 'auth_status', value: authStatus.toString());
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        //widget.storage.delete(key: 'auth_status');
        //widget.storage.write(key: 'auth_status', value: authStatus.toString());
        // storage.deleteAll();
        return new LoginSignupPage(
          authService: widget.authService,
          storage: widget.storage,
          misHijosService: widget.misHijosService,
          // loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        //widget.storage.delete(key: 'auth_status');
        //widget.storage.write(key: 'auth_status', value: authStatus.toString());
        // if (_userToken.length > 0 && _userToken != null) {
        return new DashboardPage(
          // userId: _userToken,
          // authService: widget.authService,
          storage: widget.storage,
          // logoutCallback: logoutCallback,
        );
      // } else
      //   return buildWaitingScreen();
      // break;
      default:
        //widget.storage.delete(key: 'auth_status');
        //widget.storage.write(key: 'auth_status', value: 'AuthStatus.NOT_DETERMINED');
        return buildWaitingScreen();
    }
  }
}
