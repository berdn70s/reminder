import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/services/database_service.dart';
import 'repository/project_friends.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class TaskPage extends StatefulWidget {
  final Project project;
  List<Task> tasks;


  TaskPage(
      this.tasks,
      this.project, {
        Key? key,
      }) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  bool  whoToDoCheck = false;
  var isAnimDisplay = false;
  var isTasksDisplay = true;
  final _textController = TextEditingController();
  DatabaseService service = DatabaseService();

  var isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future contributorSelector() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [Text('Contributors'), Icon(Icons.people_outline)],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: ListView.builder(
              itemCount: ProjectFriendsRepository.friends.length,
              itemBuilder: (context,i) {
                return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${ProjectFriendsRepository.friends[i].firstName} ${ProjectFriendsRepository.friends[i].lastName}"),
                    RoundCheckBox(
                      isChecked: false,
                      animationDuration: const Duration(milliseconds: 200),
                      checkedColor: Colors.black26,
                      onTap: (bool? selected) {
                        setState(() {

                        });
                      },
                    )
                  ],
                );
              }),
        ),
        actions: [
          TextButton(onPressed: submit, child: const Text('Submit')),
        ],
      ));

  Future popUp(Task taskData) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [Text('Task'), Icon(Icons.task)],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Write down a description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.2),
                  ),
                  labelText: 'Description'),
              autocorrect: false,
              cursorColor: Colors.black,
            ),
            Column(
              children: [
                Text('Who to do'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Is it done?'),
                  RoundCheckBox(
                    isChecked: isChecked,
                    animationDuration: const Duration(milliseconds: 600),
                    checkedColor: Colors.black26,
                    onTap: (selected) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: submit, child: const Text('Submit')),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context, widget.tasks),
          ),
          elevation: 0,
          backgroundColor: Colors.black54,
          title: Padding(
            padding: const EdgeInsets.only(right: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timelapse, color: Colors.black),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "REMAINDER",
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
                              isTasksDisplay = !isTasksDisplay;
                            });
                          }),
                    ],
                  ),
                  if (isTasksDisplay)
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
                                    icon:
                                    const Icon(Icons.delete_forever_outlined)),
                                label: const Text('Task'),
                                hintText: 'What u up to?',
                                icon: IconButton(
                                    icon: const Icon(Icons.task_alt_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                        shadows: [Shadow(blurRadius: 20.2)]),
                                    onPressed: (() {
                                      addTask();
                                      setState(() {});
                                    })),
                                border: const OutlineInputBorder()),
                            controller: _textController,
                          ),
                        ],
                      ),
                    ),
                  if (isAnimDisplay)
                    Expanded(
                        child: Center(
                          child: Lottie.network(
                              "https://assets8.lottiefiles.com/packages/lf20_W4M8Pi.json"),
                        )),
                  if (isTasksDisplay)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: ListView.builder(
                            itemCount: widget.tasks.length,
                            itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.indigo,
                                    shape: const BeveledRectangleBorder(
                                        side: BorderSide(
                                            width: 4,
                                            color: Colors.black12,
                                            style: BorderStyle.solid,
                                            strokeAlign: StrokeAlign.outside),
                                        borderRadius:
                                        BorderRadius.horizontal(left: Radius.elliptical(8, 8),right: Radius.elliptical(8,8))),
                                    foregroundColor: Colors.black,
                                    backgroundColor:Colors.grey),
                                onPressed: () {
                                  popUp(widget.tasks[index]);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.tasks[index].content),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: contributorSelector,
                                            icon: const Icon(Icons.people)),
                                        IconButton(
                                            icon: const Icon(Icons.highlight_off,
                                                color: Colors.grey,
                                                size: 30,
                                                shadows: [
                                                  Shadow(blurRadius: 20.2)
                                                ]),
                                            onPressed: () {
                                              deleteTask(widget.tasks[index]);
                                              setState(() {});
                                            })
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            ),
                          ),
                        ),
                      ),
                    )
                ]),
              ),
            )));
  }

  void submit() {
    Navigator.pop(context);
  }

  addTask() async {
    await service.addTask(
        widget.project, Task(_textController.text, 'description', []));
    widget.tasks = await service.retrieveTasks(widget.project);
    setState(() {});
  }

  deleteTask(Task taskData) async {
    await service.deleteTask(widget.project, taskData);
    widget.tasks = await service.retrieveTasks(widget.project);
    setState(() {});
  }
}

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => build(context)));
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}