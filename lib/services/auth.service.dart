import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/models/user_signin_model.dart';
import 'package:school_mobile_portal/enviroment.dev.dart';

abstract class BaseAuth {
  Future<UserSignInModel> signIn(String email, String password);

  Future<UserSignInModel> signUp(String email, String password);

  // Future<FirebaseUser> getCurrentUser();
  Future<dynamic> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class AuthService implements BaseAuth {
  final String theUrl = '$baseUrl/auth';

  Future<UserSignInModel> signIn(String username, String password) async {
    http.Response res = await http.post(
      '$theUrl/sign-in',
      body: {'username': username, 'password': password, 'no_caduca': 'true'},
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      // print(body.toString());
      final data = new UserSignInModel.fromJson(body['data']);
      return data;
    } else {
      throw 'No es posible iniciar sesión.';
    }
  }

  Future<UserSignInModel> signUp(String username, String password) async {
    http.Response res = await http.post('$theUrl/sign-up', body: {
      'username': username,
      'password': password,
    });
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      // print(body.toString());
      final data = new UserSignInModel.fromJson(body['data']);
      return data;
    } else {
      throw 'No es posible crear al usuario sesión.';
    }

    // AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
    //     email: email, password: password);
    // FirebaseUser user = result.user;
    // return user.uid;
  }

  Future<dynamic> getCurrentUser() async {}

  Future<void> signOut() async {}
  Future<void> sendEmailVerification() async {}
  Future<bool> isEmailVerified() async {}
}
/*
class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
*/
