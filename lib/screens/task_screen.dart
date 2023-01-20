import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/screens/add_people_to_project_screen.dart';
import 'package:remainder/screens/chat_screen.dart';
import 'package:remainder/services/database_service.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class TaskPage extends StatefulWidget {
  Project project;
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
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
  bool whoToDoCheck = false;
  bool isChecked  = false;
  bool isAnimDisplay = false;
  bool isTasksDisplay = false;
  List<String>? fulls;
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    _textController.addListener(() {});
    super.initState();
    snapshots=getTasks();
    _initRetrieval();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks(){
    return FirebaseFirestore.instance
        .collection("projects")
        .doc(widget.project.id)
        .collection("tasks")
        .snapshots();
  }

  @override
  void dispose() {
    _textController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _initRetrieval() async {
    widget.project=await service.retrieveProject(widget.project);
    fulls = await getNameOfContributor();
  }

  String whoToDoToString(Task taskData) {
    String owners = "";
    for (int i = 0; i < taskData.whoToDo.length; i++) {
      if(!owners.contains(taskData.whoToDo[i]))
        {
          owners = "$owners --> ${taskData.whoToDo[i]}\n";
        }
    }
    return owners;
  }


  Future<List<String>> getNameOfContributor() async {
    List<String> temp = [];
    for (int i = 0; i < widget.project.contributors.length; i++) {
      String firstName = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: widget.project.contributors[i])
          .get()
          .then((value) => value.docs[0].data()["firstName"]);
      String lastName = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: widget.project.contributors[i])
          .get()
          .then((value) => value.docs[0].data()["lastName"]);
      String full = "$firstName $lastName";
      if (temp.contains(full)) {
        continue;
      } else {
        temp.add(full);
      }
    }
    return temp;
  }

  Future taskEditMenu(Task task) async {
    _nameController.text = task.content;
    _textController.text = task.description;
   _initRetrieval();
   task=await service.retrieveTask(widget.project, task);
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Expanded(child: Text("Task Editing Page")),
              Icon(Icons.people_outline)
            ],
          ),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    hintText: "Write down a name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.2),
                    ),
                  ),
                  autocorrect: false,
                  cursorColor: Colors.black,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'DESCRIPTION',
                    hintText: "Write down a description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.2),
                    ),
                  ),
                  autocorrect: false,
                  cursorColor: Colors.black,
                ),
                SizedBox(
                  height: 30,
                ),
                Text('Select Who To DO'),
                Expanded(
                  child: ListView.builder(
                      itemCount: fulls!.length,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(fulls![i]),
                            RoundCheckBox(
                              borderColor: Colors.black,
                              isChecked: isChecked =
                              task.whoToDo.contains(fulls![i])
                                  ? true
                                  : false,
                              animationDuration:
                              const Duration(milliseconds: 200),
                              checkedColor: Colors.blueGrey,
                              onTap: (bool? selected) async {
                                task= await service.retrieveTask(widget.project, task);
                                if(task.whoToDo.contains(fulls![i])){
                                  task.whoToDo.remove(fulls![i]);
                                  updateTask(task);
                                }else{
                                  task.whoToDo.add(fulls![i]);
                                  updateTask(task);
                                }
                                setState(() {

                                });
                              },
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: ()  {
                 updateTask(task);
                 _textController.text = "";
                 Navigator.of(context).pop(task);
                },
                child: const Text('Submit')),
          ],
        ));
  }

  Future popUp(Task taskData) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        backgroundColor: Colors.grey,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: const [Text('Task'), Icon(Icons.task)],
            ),
          ],
        ),
        content: Column(
          children: [
            SizedBox(
              height: 32,
              child: Row(
                children: const [
                  Text(
                    ' Who To Do?:',
                    style: TextStyle(color: Colors.black, fontSize: 21),
                  ),
                ],
              ),
            ),
            Text(
              whoToDoToString(taskData),
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            SizedBox(
              height: 82,
              child: Column(
                children: const [
                  Text(
                    "",
                    style: TextStyle(fontSize: 3),
                  ),
                ],
              ),
            ),
            Row(
              children: const [
                SizedBox(
                  height: 42,
                  child: Text(' Project Description:',
                      style: TextStyle(color: Colors.black, fontSize: 21)),
                ),
              ],
            ),
            Column(
              children: [
                Text(taskData.description,
                    style: TextStyle(color: Colors.black, fontSize: 17))
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed:(){
            Navigator.of(context).pop(taskData);
          }, child: const Text('Submit')),
        ],
      )
  );


  addTask() async {
    await service.addTask(widget.project,
        Task(_textController.text, '', [], isItDone: isChecked));
    widget.tasks = await service.retrieveTasks(widget.project);
    setState(() {});
  }

  updateTask(Task taskData) async {
    taskData.content = _nameController.text;
    taskData.description = _textController.text;
    await service.updateTask(widget.project, taskData);
    widget.tasks = await service.retrieveTasks(widget.project);
    setState(() {});
  }

  deleteTask(Task taskData) async {
    await service.deleteTask(widget.project, taskData);
    widget.tasks = await service.retrieveTasks(widget.project);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context,widget.project.contributors),
          ),
          elevation: 0,
          backgroundColor: Colors.black54,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 45),
                child: Row(
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
                    ),
                  ],
                ),
              ),
              SizedBox(width: 85),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatPage(widget.project)));
                    },
                    icon: Icon(
                      Icons.chat,
                      color: Colors.black,
                    )),
              )
            ],
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
                      AnimatedButton(
                          width: 140,
                          height: 40,
                          selectedTextColor: Colors.black87,
                          selectedBackgroundColor: Colors.black12,
                          isReverse: true,
                          transitionType: TransitionType.BOTTOM_TO_TOP,
                          borderRadius: 60,
                          borderWidth: 2,
                          text: 'INVITE PEOPLE',
                          textStyle: GoogleFonts.nunito(
                              fontSize: 16,
                              letterSpacing: 1,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300),
                          onPress: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddPeopleToProject(widget.project)));
                            });
                          })
                    ],
                  ),
                  SizedBox(height: 10),
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
                                hintText: 'Keep it tight',
                                icon: IconButton(
                                    icon: const Icon(Icons.task_alt_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                        shadows: [Shadow(blurRadius: 20.2)]),
                                    onPressed: (() {
                                      if (_textController.text == "") {
                                      } else {
                                        addTask();
                                        setState(() {
                                          _textController.text = "";
                                        });
                                      }
                                    })),
                                border: const OutlineInputBorder()),
                            controller: _textController,
                          ),
                        ],
                      ),
                    ),
                  if (widget.tasks.isEmpty)
                    Expanded(
                        child: Center(
                          child: Lottie.network(
                              "https://assets8.lottiefiles.com/packages/lf20_W4M8Pi.json"),
                        )),
                  if (widget.tasks.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: StreamBuilder(
                              stream: snapshots,
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: ((context, index) {
                                      var ds = snapshot.data!.docs[index];
                                      return Padding(
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
                                                  borderRadius: BorderRadius.horizontal(
                                                      left: Radius.elliptical(8, 8),
                                                      right: Radius.elliptical(8, 8))),
                                              foregroundColor: Colors.black,
                                              backgroundColor: Colors.grey),
                                          onPressed: () {
                                            popUp(widget.tasks[index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(ds["content"]),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      iconSize: 20,
                                                      onPressed: () async {
                                                        await _initRetrieval();
                                                        widget.tasks[index]=await service.retrieveTask(widget.project, widget.tasks[index]);
                                                        taskEditMenu(widget.tasks[index]);
                                                        setState(() {
                                                        });
                                                      },
                                                      icon: const Icon(Icons.edit)),
                                                  IconButton(
                                                      icon: const Icon(
                                                          Icons.highlight_off,
                                                          color: Colors.grey,
                                                          size: 25,
                                                          shadows: [
                                                            Shadow(blurRadius: 20.2)
                                                          ]),
                                                      onPressed: () {
                                                        deleteTask(widget.tasks[index]);
                                                        setState(() {});
                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  );}
                                else {
                                  return CircularProgressIndicator();
                                }
                              }
                          ),
                        ),
                      ),
                    )
                ]),
              ),
            )));
  }
}