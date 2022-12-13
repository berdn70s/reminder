import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/repository/project_friends.dart';
import 'package:remainder/repository/project_repository.dart';
import 'package:remainder/repository/tasks_repository.dart';
// ignore_for_file: prefer_const_constructors

void main() {
  runApp(const MyApp());
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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TasksRepository tasksRepository= TasksRepository();
  ProjectFriendsRepository projectFriendsRepository= ProjectFriendsRepository();
  ProjectRepository projectRepository= ProjectRepository();

  bool isTasksDisplay = true;
  final _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timelapse, color: Colors.black),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.title,
              style: GoogleFonts.barlow(color: Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.timelapse,
              color: Colors.black,
            )
          ],
        ),
      ),
      backgroundColor: Colors.indigo,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: const [Colors.indigo, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                 isTasksDisplay = !isTasksDisplay;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Exam Dates',
                      style: GoogleFonts.barlow(color: Colors.black)),
                  Icon(Icons.timeline_outlined)
                ],
              ),
            ),
            if(isTasksDisplay == true)
                Flexible(
                  child: ListView(
                  children: const [Text('SE 323'), Text('SE 380')],
              ),
                ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isTasksDisplay = !isTasksDisplay;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Exam Dates',
                        style: GoogleFonts.barlow(color: Colors.black)),
                    Icon(Icons.timeline_outlined)
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
