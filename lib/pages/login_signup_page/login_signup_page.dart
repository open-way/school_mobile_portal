import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_mobile_portal/models/hijo_model.dart';
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/models/user_signup_model.dart';
import 'package:school_mobile_portal/routes/routes.dart';
import 'package:school_mobile_portal/services/auth.service.dart';
import 'package:school_mobile_portal/services/mis-hijos.service.dart';
import 'package:school_mobile_portal/theme/lamb_themes.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage(
      {@required this.authService,
      @required this.storage,
      @required this.misHijosService});

  static const String routeName = '/login_signup';
  final AuthService authService;
  final MisHijosService misHijosService;
  final FlutterSecureStorage storage;

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

  void _deleteAllStorage() {
    widget.storage.deleteAll();
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    this._deleteAllStorage();
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

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _saveInfoUserLogged(UserSignInModel userSignIn) async {
    await widget.storage
        .write(key: 'user_sign_in', value: userSignIn.toString());
    await widget.storage.write(key: 'token', value: userSignIn.token);
  }

  _saveChildsUserLogged(List<HijoModel> hijos) async {
    if (hijos.length > 0) {
      await widget.storage
          .write(key: 'child_selected', value: hijos[0].toString());
    }

    await widget.storage.write(key: 'hijos', value: hijos.toString());
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _errorMessage = '';
        _isLoading = true;
      });
      try {
        if (_isLoginForm) {
          UserSignInModel userSignIn =
              await widget.authService.signIn(_email, _password);

          if (userSignIn.accessToken.isNotEmpty && _isLoginForm) {
            await _saveInfoUserLogged(userSignIn);
            List<HijoModel> hijos = await widget.misHijosService.getAll$();
            await _saveChildsUserLogged(hijos);
            Navigator.pushReplacementNamed(context, Routes.dashboard);
          }
        } else {
          UserSignUpModel userSignUp = await widget.authService.signUp(
            _idTipodocumento,
            _email,
            _password,
            _passwordConfirm,
          );
          this.toggleFormMode();
        }
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
          child: AppBar(
              // Here we create one to set status bar color
              backgroundColor: _isLoginForm
                  ? LambThemes.dark.appBarTheme.color
                  : LambThemes.light.accentColor)),
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

  Widget _showForm() {
    List<Widget> widgetsSignIn = [
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
                  showDniInput(),
                  showPasswordInput(),
                  showPrimaryButton(),
                  showSecondaryButton(),
                  showErrorMessage(),
                ],
              ),
            ),
          ))
    ];
    List<Widget> widgetsSignUp = [
      Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: <Widget>[
              new Container(
                height: 235,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: LambThemes.light.accentColor,
                  gradient: new LinearGradient(
                      colors: [
                        LambThemes.light.accentColor,
                        LambThemes.light.scaffoldBackgroundColor
                      ],
                      begin: Alignment(0, 2100),
                      end: Alignment(0, 0),
                      tileMode: TileMode.repeated),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: MediaQuery.of(context).size.width / 1.25,
                    height: 100,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: LambThemes.light.primaryColor,
                          width: 6),
                      color: LambThemes.light.scaffoldBackgroundColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: new Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.925,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: LambThemes.light.scaffoldBackgroundColor,
                        ),
                        child: showLogo(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.125),
                child: Column(
                  children: <Widget>[
                    showTipoDocumentoDropdownButton(),
                    showDniInput(),
                    showPasswordInput(),
                    showPasswordConfirmInput(),
                    showPrimaryButton(),
                    showSecondaryButton(),
                    showErrorMessage(),
                  ],
                ),
              ),
              /*Container(
                    padding: EdgeInsets.fromLTRB(0.0, 27.0, 0.0, 0.0),
                    color: LambThemes.light.accentColor,
                    height: 75,
                  ),*/
            ],
          ))
    ];
    List<Widget> widgets = _isLoginForm ? widgetsSignIn : widgetsSignUp;
    return new Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: widgets,
        ),
      ),
    );
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
    var radius1 = MediaQuery.of(context).size.width / 4;
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: radius1,
          child: Image.asset(_isLoginForm
              ? 'assets/images/LAMB-blanco-01.png'
              : 'assets/images/LAMB-color.png'),
        ),
      ),
    );
  }

  Widget showTipoDocumentoDropdownButton() {
    var cons = EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0);
    return Padding(
      padding: cons,
      child: InputDecorator(
        decoration: InputDecoration(
          icon: Icon(
            Icons.credit_card,
            color: LambThemes.light.primaryColor,
          ),
          labelText: 'Seleccione tipo documento',
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
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
    var margin1 = MediaQuery.of(context).size.height / 2.125;
    var margin2 = 30.0;
    var width1 = MediaQuery.of(context).size.width / 2;
    var width2 = double.infinity;
    var opc = EdgeInsets.fromLTRB(0.0, margin1, 0.0, 0.0);
    var opc2 = EdgeInsets.fromLTRB(0.0, margin2, 0.0, 0.0);
    var icon = Icon(
      Icons.perm_identity,
      color: LambThemes.light.primaryColor,
    );

    return Container(
      margin: _isLoginForm ? opc : opc2,
      width: _isLoginForm ? width1 : width2,
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          labelText: 'Usuario(DNI)',
          icon: _isLoginForm ? null : icon,
        ),
        validator: (value) => value.isEmpty ? 'No puede estar vacío.' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    var width1 = MediaQuery.of(context).size.width / 2;
    var width2 = double.infinity;
    var margin1 = 12.5;
    var margin2 = 30.0;
    var opc = EdgeInsets.fromLTRB(0.0, margin1, 0.0, 0.0);
    var opc2 = EdgeInsets.fromLTRB(0.0, margin2, 0.0, 0.0);
    var icon = Icon(
      Icons.lock,
      color: LambThemes.light.primaryColor,
    );
    return Container(
      width: _isLoginForm ? width1 : width2,
      child: Padding(
        padding: _isLoginForm ? opc : opc2,
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
            labelText: 'Contraseña',
            icon: _isLoginForm ? null : icon,
          ),
          validator: (value) => value.isEmpty ? 'No puede estar vacío.' : null,
          onSaved: (value) => _password = value.trim(),
        ),
      ),
    );
  }

  Widget showPasswordConfirmInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Confirmar contraseña',
            icon: new Icon(
              Icons.lock,
              color: LambThemes.light.primaryColor,
            )),
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
            style: new TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            )),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    var margin1 = 12.5;
    var margin2 = 60.0;
    var opc = EdgeInsets.fromLTRB(0.0, margin1, 0.0, 0.0);
    var opc2 = EdgeInsets.fromLTRB(0.0, margin2, 0.0, 0.0);
    return new Padding(
        padding: _isLoginForm ? opc : opc2,
        child: SizedBox(
          height: 40.0,
          width: MediaQuery.of(context).size.width / 2,
          child: new RaisedButton(
            color: LambThemes.light.primaryColor,
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text(
              _isLoginForm ? 'Iniciar sesión' : 'Crear usuario',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
            ),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
