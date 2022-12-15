import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkingPasswordController = TextEditingController();
  bool visibilityCheck = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    checkingPasswordController.dispose();
    super.dispose();
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

    checkingPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 50,
          top: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                bottom: 35,
              ),
              child: Text(
                "Sign UP",
                style: TextStyle(fontSize: 35, fontStyle: FontStyle.normal),
              ),
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
              height: 10,
            ),
            TextField(
              controller: checkingPasswordController,
              obscureText: visibilityCheck ? true : false,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          checkingPasswordController.clear();
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
                  labelText: "Confirm Password",
                  hintText: "Enter the same password."),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 150,
              height: 35,
              child: ElevatedButton(
                onPressed: emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    checkingPasswordController.text.isEmpty
                    ? null
                    : () {
                  //Navigated to homepage and take the controller texts as a parameter to firebase registration.
                },
                child: Text(
                  'Sign UP',
                  style: GoogleFonts.arya(
                      textStyle: const TextStyle(color: Colors.black, fontSize: 22)),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const TextButton(
                onPressed: null
                //Navigated to login page.
                ,
                child: Text('Already have an Account? LOGIN!',
                    style: TextStyle(color: Colors.grey, fontSize: 15)))
          ],
        ),
      ),
    );
  }
}