import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_mobile_portal/services/base.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  // Future<FirebaseUser> getCurrentUser();
  Future<dynamic> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class AuthenticationService implements BaseAuth {
  final String theUrl = '$baseUrl/auth';

  Future<String> signIn(String email, String password) async {
    // http.Response res = await http.get('$theUrl/sign-in');
    // if (res.statusCode == 200) {
    //   final body = jsonDecode(res.body);
    //   final data = body['data'].cast<Map<String, dynamic>>();
    //   return data.map<HijoModel>((json) => HijoModel.fromJson(json)).toList();
    // } else {
    //   throw "Can't get mis hijos.";
    // }
  }

  Future<String> signUp(String email, String password) async {}
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
