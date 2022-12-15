import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:remainder/login.dart';
import 'package:remainder/project_screen.dart';
import 'package:remainder/repository/project_friends.dart';
import 'package:remainder/repository/project_repository.dart';
import 'package:remainder/repository/tasks_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remainder/task_screen.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const MyHomePage(title: 'REMAINDER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ProjectsScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProjectsScreen> {
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
              widget.title,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[Login()],
        ),
      ),
    );
  }
}

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final projectRepository = ref.watch(projectProvider);
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
                title,
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
        body: Column(children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: ListView.builder(
                    itemCount: projectRepository.projects.length,
                    itemBuilder: ((context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskPage(projectRepository.projects[index].tasks)));
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  style: GoogleFonts.nunito(fontSize: 20),
                                  projectRepository.projects[index].projectName),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectPersonViewScreen(projectRepository.projects[index].includedPeople)));
                                  },
                                  icon: const Icon(Icons.person_pin))
                            ],
                          ),
                        ),
                      ]),
                    ))),
              ),
            ),
          ),
        ]));
  }
}

