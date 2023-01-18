import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/services/database_service.dart';

class AddPeopleToProject extends StatefulWidget {
  Project project;

  AddPeopleToProject(this.project, {super.key});

  @override
  State<AddPeopleToProject> createState() => _AddPeopleToProjectState();
}

class _AddPeopleToProjectState extends State<AddPeopleToProject> {
  bool isSubmitted = true;

  DatabaseService service = DatabaseService();

  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget animation = isSubmitted
        ? Lottie.network(
        'https://assets1.lottiefiles.com/packages/lf20_ojvdktpp.json')
        : Lottie.network(
        'https://assets7.lottiefiles.com/packages/lf20_ru9rYQ.json',
        repeat: false);

    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black54, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
         ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back))
              ],
            ),
            SizedBox(
              height: 240,
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                  constraints: const BoxConstraints(
                      minHeight: 10,
                      maxWidth: 320,
                      maxHeight: 100,
                      minWidth: 30),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.delete_forever_outlined),
                    onPressed: () {
                      textController.clear();
                    },
                  ),
                  label: const Text('Email'),
                  hintText: 'Enter a valid email adress ',
                  border: const OutlineInputBorder()),
              onChanged: (String a) {
                setState(() {
                  isSubmitted = true;
                });

              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AnimatedButton(
                  width: 140,
                  height: 40,
                  selectedTextColor: Colors.black87,
                  selectedBackgroundColor: Colors.black12,
                  isReverse: true,
                  transitionType: TransitionType.BOTTOM_TO_TOP,
                  borderRadius: 60,
                  borderWidth: 2,
                  text: 'SUBMIT',
                  textStyle: GoogleFonts.nunito(
                      fontSize: 16,
                      letterSpacing: 1,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300),
                  onPress: () {
                    setState(() {
                      isSubmitted = false;
                    });
                    service.addUserToProject(
                        textController.text, widget.project);
                    Navigator.of(context).pop(widget.project);
                  }),
            ),
            SizedBox(height: 200, width: 400, child: animation)
          ],
        ),
      ),
    );
  }
}