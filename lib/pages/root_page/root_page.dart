import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/pages/dashboard_page/dashboard_page.dart';
import 'package:school_mobile_portal/pages/login_signup_page/login_signup_page.dart';
import 'package:school_mobile_portal/services/auth.service.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.authService});

  final AuthService authService;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userToken = "";
  UserSignInModel userSignInModel;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    this._readToken();
    // _userToken = '21222121dds21';
    // authStatus = AuthStatus.LOGGED_IN;
    // widget.authService.getCurrentUser().then((user) {
    //   setState(() {
    //     if (user != null) {
    //       _userToken = user?.uid;
    //     }
    //     authStatus =
    //         user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    //   });
    // });
  }

  void _readToken() async {
    final strUserSignIn = await storage.read(key: 'user_sign_in') ?? '';
    if (strUserSignIn.isNotEmpty) {
      this.userSignInModel =
          UserSignInModel.fromJson(jsonDecode(strUserSignIn));
      // this._userToken = this.userSignInModel.token;
      if (this.userSignInModel.token != null) {
        _userToken = this.userSignInModel?.token;
      }
      authStatus = this.userSignInModel?.token == null
          ? AuthStatus.NOT_LOGGED_IN
          : AuthStatus.LOGGED_IN;
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
      _userToken = '';
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

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        // storage.deleteAll();
        return new LoginSignupPage(
          authService: widget.authService,
          // loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userToken.length > 0 && _userToken != null) {
          return new DashboardPage(
            userId: _userToken,
            authService: widget.authService,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
