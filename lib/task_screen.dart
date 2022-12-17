import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'repository/project_friends.dart';
import 'repository/tasks_repository.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class TaskPage extends StatefulWidget {
  final List<Task> tasks;

  const TaskPage(this.tasks, {Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var isAnimDisplay = false;
  var isTasksDisplay = true;
  final _textController = TextEditingController();

  var isChecked = false;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  Future popUp() => showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
            title: Text('Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  autofocus: true,
                  decoration:
                      InputDecoration(hintText: 'Enter your description'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Is it done?'),
                      RoundCheckBox(
                        isChecked: isChecked,
                        animationDuration: Duration(milliseconds: 600),
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
              TextButton(onPressed: submit, child: Text('Submit')),
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
                                onPressed: () {
                                  setState(() {
                                    widget.tasks.add(Task(
                                        _textController.text.toString(),
                                        Friend("Semih", "Yagci"),
                                        DateTime.now()));
                                  });
                                }),
                            border: const OutlineInputBorder()),
                        controller: _textController,
                      ),
                      IconButton(
                          icon: const Icon(Icons.highlight_off,
                              color: Colors.grey,
                              size: 30,
                              shadows: [Shadow(blurRadius: 20.2)]),
                          onPressed: () {
                            setState(() {
                              if (widget.tasks.isNotEmpty) {
                                widget.tasks.removeLast();
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
              if (isTasksDisplay)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: ListView.builder(
                          itemCount: widget.tasks.length,
                          itemBuilder: ((context, index) => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey),
                                onPressed: () {
                                  popUp();
                                },
                                child: Center(
                                  child: Text(
                                      style: GoogleFonts.nunito(fontSize: 20),
                                      widget.tasks[index].content),
                                ),
                              ))),
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
