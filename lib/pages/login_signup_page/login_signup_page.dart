import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/theme/dark.theme.dart';
// import 'package:school_mobile_portal/routes/routes.dart';

class LoginSignupPage extends StatefulWidget {
  // LoginSignupPage({this.auth, this.loginCallback});
  LoginSignupPage({@required this.authService});

  static const String routeName = '/login_signup';
  final AuthService authService;
  // final VoidCallback loginCallback;

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _passwordConfirm;
  String _idTipodocumento;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    // print('form.toString()');
    // print(form.toString());
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _saveData(UserSignInModel userSignIn) async {
    final storage = new FlutterSecureStorage();
    // storage.deleteAll();
    print('______________');
    print('______________');
    print(userSignIn.toString());
    print('______________');
    await storage.write(key: 'user_sign_in', value: userSignIn.toString());
    await storage.write(key: 'token', value: userSignIn.token);
    // await storage.write(key: 'token', value: userSignIn.token);
    // await storage.write(key: 'oauth_fullname', value: userSignIn.oauthFullname);
    // await storage.write(key: 'oauth_email', value: userSignIn.oauthEmail);
    // await storage.write(key: 'imagen_url', value: userSignIn.imagenUrl);

    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    // print(await storage.read(key: 'token'));
    // print(await storage.read(key: 'oauth_fullname'));
    // print(await storage.read(key: 'oauth_email'));
    // print(await storage.read(key: 'imagen_url'));
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
    print('______________');
  }

  // Perform login or signup
  void validateAndSubmit() async {
    // widget.loginCallback();
    // Navigator.pushReplacementNamed(context, Routes.dashboard);
    // String userId = "";
    if (validateAndSave()) {
      setState(() {
        _errorMessage = '';
        _isLoading = true;
      });
      UserSignInModel userSignIn;
      try {
        if (_isLoginForm) {
          userSignIn = await widget.authService.signIn(_email, _password);
        } else {
          userSignIn = await widget.authService.signUp(
            _idTipodocumento,
            _email,
            _password,
            _passwordConfirm,
          );
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          // print('Signed up user: $userId');
        }

        // print(userSignIn.fullname);
        setState(() {
          _isLoading = false;
        });
        if (userSignIn.accessToken.isNotEmpty && _isLoginForm) {
          _saveData(userSignIn);
          Navigator.pushReplacementNamed(context, Routes.dashboard);
          // widget.loginCallback();
        }
        // if (userSignIn.length > 0 && userSignIn != null) {
        //   // widget.loginCallback();
        // }
      } catch (e) {
        print('Hola munof');
        print("Error: ${e.message}");
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          // _formKey.currentState.reset();
        });
      }
    }

    /*
        if (_isLoginForm) {
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        }
        // if (userId.length > 0 && userId != null && _isLoginForm) { }
    */
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      // appBar: AppBar(
      //   title: Text('Autenticación'),
      // ),
      // body: ContactList());
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

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    List<Widget> widgetsSignIn = [
      showLogo(),
      showDniInput(),
      showPasswordInput(),
      showPrimaryButton(),
      showSecondaryButton(),
      showErrorMessage(),
    ];
    List<Widget> widgetsSignUp = [
      showLogo(),
      showTipoDocumentoDropdownButton(),
      showDniInput(),
      showPasswordInput(),
      showPasswordConfirmInput(),
      showPrimaryButton(),
      showSecondaryButton(),
      showErrorMessage(),
    ];
    List<Widget> widgets = _isLoginForm ? widgetsSignIn : widgetsSignUp;

    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: widgets,
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

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/images/lamb-school-logo-full-color.png'),
        ),
      ),
    );
  }

  Widget showTipoDocumentoDropdownButton() {
    var cons = EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0);
    return Padding(
      // padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      padding: cons,
      child: InputDecorator(
        decoration: InputDecoration(
          icon: Icon(Icons.credit_card),
          labelText: 'Seleccione tipo documento',
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            // hint: new Text('Seleccione tipo documento'),
            value: this._idTipodocumento,
            // isExpanded: true,
            isDense: true,
            onChanged: (String newValue) {
              setState(() {
                this._idTipodocumento = newValue;
              });
            },
            items: [
              new DropdownMenuItem(
                value: '1',
                child: Text('DNI'),
              ),
              new DropdownMenuItem(
                value: '4',
                child: Text('CarEx'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showDniInput() {
    var opc = EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0);
    var opc2 = EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0);

    return Padding(
      padding: _isLoginForm ? opc : opc2,
      child: new TextFormField(
        maxLines: 1,
        // keyboardType: TextInputType.emailAddress,
        // keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            // hintText: 'DNI',
            labelText: 'Usuario(DNI)',
            icon: new Icon(
              Icons.perm_identity,
              color: Colors.grey,
            )),
        // validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        validator: (value) =>
            value.isEmpty ? 'El número de DNI no puede estar vacío.' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Contraseña',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        // validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        validator: (value) =>
            value.isEmpty ? 'La contraseña no puede estar vacío.' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPasswordConfirmInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Confirmar contraseña',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        // validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        validator: (value) =>
            value.isEmpty ? 'Debe confirmar la contraseña.' : null,
        onSaved: (value) => _passwordConfirm = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm
                ? 'Solicitar acceso'
                : '¿Ya tienes un usuario? Iniciar sesión',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            // color: Colors.blue,
            child: new Text(
              _isLoginForm ? 'Iniciar sesión' : 'Crear usuario',
              // semanticsLabel: 'Iniciar sesión',
              style: new TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
