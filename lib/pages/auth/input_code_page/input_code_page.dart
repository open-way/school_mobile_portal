import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

class InputCodePage extends StatefulWidget {
  InputCodePage(
      // {
      // @required this.authService,
      // @required this.storage,
      // @required this.misHijosService,
      // }
      );

  // static const String routeName = '/recovery_password';
  // final AuthService authService;
  // final MisHijosService misHijosService;
  // final FlutterSecureStorage storage;

  @override
  _InputCodePage createState() => _InputCodePage();
}

class _InputCodePage extends State<InputCodePage> {
  final _formKey = new GlobalKey<FormState>();

  String _code;
  // String _password;
  // String _passwordConfirm;
  // String _idTipodocumento;
  String _errorMessage;

  // bool _isLoginForm;
  bool _isLoading;

  // void _deleteAllStorage() {
  //   widget.storage.deleteAll();
  // }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    // _isLoginForm = true;
    // this._deleteAllStorage();
    super.initState();
  }

  // void resetForm() {
  //   _formKey.currentState.reset();
  //   // _errorMessage = "";
  // }

  // void toggleFormMode() {
  //   resetForm();
  //   setState(() {
  //     _isLoginForm = !_isLoginForm;
  //   });
  // }

  // void goToRecoveryPassword() {
  //   // resetForm();
  //   setState(() {
  //     _isLoginForm = !_isLoginForm;
  //   });
  // }

  // Check if form is valid before perform login or signup
  // bool validateAndSave() {
  //   final form = _formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     return true;
  //   }
  //   return false;
  // }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // _saveInfoUserLogged(UserSignInModel userSignIn) async {
  //   await widget.storage
  //       .write(key: 'user_sign_in', value: userSignIn.toString());
  //   await widget.storage.write(key: 'token', value: userSignIn.token);
  // }

  // _saveChildsUserLogged(List<HijoModel> hijos) async {
  //   if (hijos.length > 0) {
  //     await widget.storage
  //         .write(key: 'child_selected', value: hijos[0].toString());
  //   }
  //   await widget.storage.write(key: 'hijos', value: hijos.toString());
  // }

  // Perform login or signup
  // void validateAndSubmit() async {
  //   if (validateAndSave()) {
  //     setState(() {
  //       _errorMessage = '';
  //       _isLoading = true;
  //     });
  //     try {
  //       if (_isLoginForm) {
  //         UserSignInModel userSignIn =
  //             await widget.authService.signIn(_email, _password);

  //         if (userSignIn.accessToken.isNotEmpty && _isLoginForm) {
  //           await _saveInfoUserLogged(userSignIn);
  //           List<HijoModel> hijos = await widget.misHijosService.getAll$();
  //           await _saveChildsUserLogged(hijos);
  //           Navigator.pushReplacementNamed(context, Routes.dashboard);
  //         }
  //       } else {
  //         UserSignUpModel userSignUp = await widget.authService.signUp(
  //           _idTipodocumento,
  //           _email,
  //           _password,
  //           _passwordConfirm,
  //         );
  //         this.toggleFormMode();
  //       }
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     } catch (e) {
  //       print("Error: ${e.message}");
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = e.message;
  //         _formKey.currentState.reset();
  //       });
  //     }
  //   }
  // }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _errorMessage = '';
        _isLoading = true;
      });
      try {
        // UserSignInModel userSignIn =
        //     await widget.authService.signIn(_email, _password);

        // if (userSignIn.accessToken.isNotEmpty && _isLoginForm) {
        //   await _saveInfoUserLogged(userSignIn);
        //   List<HijoModel> hijos = await widget.misHijosService.getAll$();
        //   await _saveChildsUserLogged(hijos);
        //   Navigator.pushReplacementNamed(context, Routes.dashboard);
        // }

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print("Error: ${e.message}");
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(backgroundColor: LambThemes.dark.appBarTheme.color)),
      body: Stack(
        children: <Widget>[
          this._showForm(),
          this._showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget buttonBack() {
    return new FlatButton(
        child: new Text('Regresar',
            style: new TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            )),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  Widget _showForm() {
    List<Widget> widgetsRecoveryPassword = [
      Theme(
          data: LambThemes.dark.copyWith(),
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            decoration: BoxDecoration(
              image: new DecorationImage(
                image:
                    new ExactAssetImage('assets/images/chicos.png', scale: 1),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: <Widget>[
                  showLogo(),
                  showMessage(),
                  showInputCode(),
                  showPrimaryButton(),
                  buttonBack(),
                  showErrorMessage(),
                ],
              ),
            ),
          ))
    ];

    return new Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: widgetsRecoveryPassword,
        ),
      ),
    );
  }

  Widget showLogo() {
    var radius1 = MediaQuery.of(context).size.width / 4;
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: radius1,
          child: Image.asset(
            // _isLoginForm
            'assets/images/LAMB-blanco-01.png',
            // : 'assets/images/LAMB-color.png',
          ),
        ),
      ),
    );
  }

  Widget showMessage() {
    var margin1 = MediaQuery.of(context).size.height / 2.8;
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, margin1, 0.0, 0.0),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width / 1.5,
      child: new Column(
        children: <Widget>[
          new Text(
            'Ingrese el código que le llegó al correo eletrónico cruzjhonson@gmail.com.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(LambThemes.light.secondaryHeaderColor.value)),
          )
        ],
      ),
    );
  }

  Widget showInputCode() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 12.5, 0.0, 0.0),
      width: MediaQuery.of(context).size.width / 1.5,
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          labelText: 'Codigo',
          icon: null,
        ),
        validator: (value) => value.isEmpty ? 'No puede estar vacío.' : null,
        onSaved: (value) => _code = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0, 12.5, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          width: MediaQuery.of(context).size.width / 1.5,
          child: new RaisedButton(
            color: LambThemes.light.primaryColor,
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text(
              'Recuperar mi contraseña',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
            ),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
