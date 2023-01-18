import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remainder/login_screen.dart';
import 'package:remainder/models/person.dart';
import 'package:remainder/services/database_service.dart';
import 'package:flutter/material.dart';

class AuthService {
  DatabaseService service = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future register(String firstName, String lastName, String email,
      String password, String checker, BuildContext context) async {
    if (password == checker) {
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await service
            .addUser(Person(firstName, lastName, email, user.user!.uid, []));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Login()));
      } on FirebaseAuthException catch (error) {
        Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Password does not match.', gravity: ToastGravity.TOP);
      password = '';
      checker = '';
    }
  }

  Future signIn(String email, String password, BuildContext context) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }
}
