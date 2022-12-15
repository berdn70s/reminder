import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
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
  ProjectRepository projectRepository = ProjectRepository();

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
        body: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black54, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),

        ), child: Column(children: [
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
                                          builder: (context) => TaskPage()));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        style: GoogleFonts.nunito(fontSize: 20),
                                        "${projectRepository.projects[index].projectName}"),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProjectPersonViewScreen()));
                                        },
                                        icon: Icon(Icons.person_pin))
                                  ],
                                ),
                              ),
                            ]),
                          ))),
                ),
              ),
            ),
          ]),
        ));
  }
}

class ProjectPersonViewScreen extends StatefulWidget {
  const ProjectPersonViewScreen({Key? key}) : super(key: key);

  @override
  State<ProjectPersonViewScreen> createState() => _ProjectPersonViewScreenState();
}

class _ProjectPersonViewScreenState extends State<ProjectPersonViewScreen> {
  ProjectRepository projectRepository = ProjectRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        title: Padding(
          padding: EdgeInsets.only(right: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timelapse, color: Colors.black),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Remainder",
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
      ),
      body: Text("Ali,Ahmet,Veli")
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TasksRepository tasksRepository = TasksRepository();
  ProjectFriendsRepository projectFriendsRepository = ProjectFriendsRepository();
  ProjectRepository projectRepository = ProjectRepository();
  bool _speechEnabled = false;
  String _lastWords = '';

  var isAnimDisplay = false;
  var isListDisplay = true;
  final _textController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
          title: Padding(
            padding: EdgeInsets.only(right: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timelapse, color: Colors.black),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Remainder",
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
        ),
        body: Center(
            child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.redAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedButton(
                      width: 140,
                      height: 40,
                      selectedTextColor: Colors.black87,
                      selectedBackgroundColor: Colors.black12,
                      isReverse: true,
                      transitionType: TransitionType.BOTTOM_TO_TOP,
                      borderRadius: 60,
                      borderWidth: 2,
                      text: 'ADD A TASK',
                      textStyle: GoogleFonts.nunito(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300),
                      onPress: () {
                        setState(() {
                          isAnimDisplay = !isAnimDisplay;
                          isListDisplay = !isListDisplay;
                        });
                      }),

                ],
              ),
              if (isListDisplay)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            constraints: const BoxConstraints(
                                minHeight: 10,
                                maxWidth: 320,
                                maxHeight: 100,
                                minWidth: 30),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _textController.clear();
                                },
                                icon: Icon(Icons.delete_forever_outlined)),
                            label: Text('Task'),
                            hintText: 'What u up to?',
                            icon: IconButton(
                                icon: const Icon(Icons.task_alt_outlined,
                                    color: Colors.grey,
                                    size: 30,
                                    shadows: [Shadow(blurRadius: 20.2)]),
                                onPressed: () {
                                  setState(() {
                                    tasksRepository.task.add(Task(
                                        _textController.text.toString(),
                                        Friend("Semih", "Yağcı"),
                                        DateTime.now()));
                                  });
                                }),
                            border: OutlineInputBorder()),
                        controller: _textController,
                      ),
                      IconButton(
                          icon: const Icon(Icons.highlight_off,
                              color: Colors.grey,
                              size: 30,
                              shadows: [Shadow(blurRadius: 20.2)]),
                          onPressed: () {
                            setState(() {
                              if (tasksRepository.task.isNotEmpty) {
                                tasksRepository.task.removeLast();
                              }
                            });
                          })
                    ],
                  ),
                ),
              if (isAnimDisplay)
                Expanded(
                    child: Center(
                  child: Lottie.network(
                      "https://assets8.lottiefiles.com/packages/lf20_W4M8Pi.json"),
                )),
              if (isListDisplay)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: ListView.builder(
                          itemCount: tasksRepository.task.length,
                          itemBuilder: ((context, index) => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProjectScreen()));
                                },
                                child: Center(
                                  child: Text(
                                      style: GoogleFonts.nunito(fontSize: 20),
                                      tasksRepository.task[index].content),
                                ),
                              ))),
                    ),
                  ),
                )
            ]),
          ),
        )));
  }

  String displayList(List l, int j) {
    for (int i = 0; i < l.length; i++) {
      if (i == j) {
        return '${l.elementAt(i)}';
      }
    }
    return '';
  }
}

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROJECTS'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => build(context)));
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}
