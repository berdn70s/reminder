import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/screens/change_password_screen.dart';
import 'package:remainder/screens/register_screen.dart';
import 'package:remainder/screens/project_screen.dart';
import 'package:remainder/services/auth_service.dart';
import 'package:lottie/lottie.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool visibilityCheck = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  signIn() async {
    try {
      await authService.signIn(
          emailController.text, passwordController.text, context);
      if (!mounted) {}
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProjectsScreen()));
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });

    passwordController.addListener(() {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timelapse, color: Colors.black),
            const SizedBox(
              width: 10,
            ),
            Text(
              "REMINDER",
              style: GoogleFonts.barlow(color: Colors.black),
            ),
            const SizedBox(
              width: 10,
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
                                  Flexible(child: LottieBuilder.network('https://assets8.lottiefiles.com/packages/lf20_7urcggot.json')),
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
                      labelText: "Email",
                      hintText: "Enter a valid email."),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: visibilityCheck ? true : false,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              passwordController.clear();
                            },
                            icon: const Icon(Icons.clear_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                visibilityCheck = !visibilityCheck;
                              });
                            },
                            icon: !visibilityCheck
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ],
                      ),
                      labelText: "Password",
                      hintText: "Enter a valid password."),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 150,
                  height: 35,
                  child: ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black12),
                    onPressed: emailController.text.isEmpty ||
                        passwordController.text.isEmpty
                        ? null
                        : signIn,
                    child: Text(
                      'Login',
                      style: GoogleFonts.arya(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 20)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: 150,
                  height: 35,
                  child: ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black12),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                    },
                    child: Text('Forgot Password',
                        style: GoogleFonts.arya(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 17),
                        )),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text('Create an Account',
                        style: TextStyle(color: Colors.grey, fontSize: 15)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}