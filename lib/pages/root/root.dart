import 'package:flutter/material.dart';
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
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _userId = '21222121dds21';
    authStatus = AuthStatus.LOGGED_IN;

    // widget.auth.getCurrentUser().then((user) {
    //   setState(() {
    //     if (user != null) {
    //       _userId = user?.uid;
    //     }
    //     authStatus =
    //         user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    //   });
    // });
  }

  void loginCallback() {
    widget.authService.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = '';
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
        return new LoginSignupPage(
          authService: widget.authService,
          // loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new DashboardPage(
            userId: _userId,
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
