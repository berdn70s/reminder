import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/login_screen.dart';
import 'package:remainder/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkingPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  AuthService authService = AuthService();
  bool visibilityCheck = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    checkingPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  register() async {
    await authService.register(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
        checkingPasswordController.text,
        context);
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
    firstNameController.addListener(() {
      setState(() {});
    });
    lastNameController.addListener(() {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 36,
                  ),
                  child: Text(
                    "Sign UP",
                    style: TextStyle(fontSize: 35, fontStyle: FontStyle.normal),
                  ),
                ),
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                controller: firstNameController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        firstNameController.clear();
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
                    labelText: "Name",
                    hintText: "Enter your name."),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                controller: lastNameController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        lastNameController.clear();
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
                    labelText: "Last name",
                    hintText: "Enter your last name."),
              ),
              const SizedBox(
                height: 10,
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
                      : register,
                  child: Text(
                    'Sign UP',
                    style: GoogleFonts.arya(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 22)),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()));
                  }
                  //Navigated to login page.
                  ,
                  child: const Text('Already have an Account? LOGIN!',
                      style: TextStyle(color: Colors.grey, fontSize: 15)))
            ],
          ),
        ),
      ),
    );
  }
}
