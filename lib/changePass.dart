 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final emailController = TextEditingController();
  bool visibilityCheck = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  sendRequest() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      Fluttertoast.showToast(
          msg: 'Password request has been sent!', gravity: ToastGravity.TOP);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'There is no user responding to this e-mail.',
            gravity: ToastGravity.TOP);
      } else {
        Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.timelapse, color: Colors.black),
            const SizedBox(
              width: 5,
            ),
            Text(
              "REMAINDER",
              style: GoogleFonts.barlow(color: Colors.black),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.timelapse,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black54, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 20,
              bottom: 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(fontSize: 35, fontStyle: FontStyle.normal),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Text(
                    'Enter your email address so we can send a password reset request.',
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: emailController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          emailController.clear();
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                      labelText: 'Email',
                      hintText: 'Enter a valid email.'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: sendRequest,
                    child: const Text('Send Request',
                        style: TextStyle(color: Colors.grey, fontSize: 15)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
