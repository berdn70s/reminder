import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:remainder/chat_screen.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/services/database_service.dart';
import 'repository/project_friends.dart';
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


  String taskOwnerToString() {
    String owners = "";

    for (int i = 0; i < ProjectFriendsRepository.friends.length; i++) {
      owners =
          "$owners --> ${ProjectFriendsRepository.friends[i].firstName} ${ProjectFriendsRepository.friends[i].lastName}\n";
    }
    return owners;
  }

  bool whoToDoCheck = false;
  bool isChecked = false;
  bool isAnimDisplay = false;
  bool isTasksDisplay = false;
  final _textController = TextEditingController();
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    _textController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<String> getNameOfContributor(Project projectData,String id) async {
   Future<String> tempFirstName=await FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: id).get().then((value) => value.docs[0].data()["firstName"]);
   Future<String> tempLastName=await FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: id).get().then((value) => value.docs[0].data()["lastName"]);
   String firstName= await tempFirstName;
   String lastName= await tempLastName;
    return "$firstName $lastName";
  }

  String realGetNameOfContributor(Project projectData,String id){
    String output = getNameOfContributor(projectData, id) as String;
    return output;
  }


  Future contributorSelector(Project project) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.grey,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22.0))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Contributors'),
                Icon(Icons.people_outline)
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: ListView.builder(
                  itemCount: project.contributors.length,
                  itemBuilder: (context, i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(project.contributors[i]),
                        RoundCheckBox(
                          borderColor: Colors.black,
                          isChecked: isChecked,
                          animationDuration: const Duration(milliseconds: 200),
                          checkedColor: Colors.blueGrey,
                          onTap: (bool? selected) {
                            setState(() {
                              ProjectFriendsRepository.friends[i].isDoingTask =
                                  !ProjectFriendsRepository
                                      .friends[i].isDoingTask!;
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
                        ' Contributors:',
                        style: TextStyle(color: Colors.black, fontSize: 21),
                      ),
                    ],
                  ),
                ),
                Text(
                  ' ',
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
                SizedBox(
                  height: 82,
                  child: Column(
                    children: [
                      Text(
                        taskOwnerToString(),
                        style: TextStyle(fontSize: 17),
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
                  children: [Text(taskData.description)],
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
                 child: IconButton(onPressed: (){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => ChatPage()));
                 }, icon: Icon(
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
                                  builder: (context) => AddPeopleToProject(widget.project)));
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
                                  addTask();
                                  setState(() {
                                    _textController.text = "";
                                  });
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
                                    Text(widget.tasks[index].content),
                                    Row(
                                      children: [
                                        IconButton(
                                            iconSize: 20,
                                            onPressed: (){
                                              contributorSelector(widget.project);
                                            },
                                            icon: const Icon(Icons.people)
                                        ),
                                        IconButton(
                                            iconSize: 20,
                                            onPressed: () {
                                              descriptionCreater(
                                                  widget.tasks[index]);
                                            },
                                            icon:
                                                const Icon(Icons.description)),
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
                            )),
                      ),
                    ),
                  ),
                )
            ]),
          ),
        )));
  }

  void submit() {
    _textController.text = "";
    Navigator.of(context).pop();
  }

  addTask() async {
    await service.addTask(widget.project,
        Task(_textController.text, '', [], isItDone: isChecked));
    widget.tasks = await service.retrieveTasks(widget.project);
    setState(() {});
  }

  updateTask(Task taskData) async {
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

  Future descriptionCreater(Task taskData) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.grey,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22.0))),
            content: SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: TextField(
                  controller: _textController,
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
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    updateTask(taskData);
                    setState(() {});
                    submit();
                  },
                  child: const Text('Submit')),
            ],
          ));
}

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
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

class AddPeopleToProject extends StatefulWidget {
  Project project;
  AddPeopleToProject(this.project, {super.key});

  @override
  State<AddPeopleToProject> createState() => _AddPeopleToProjectState();
}

class _AddPeopleToProjectState extends State<AddPeopleToProject> {
  bool isSubmitted = true;

  DatabaseService service = DatabaseService();

  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
     Widget animation = isSubmitted ? Lottie.network('https://assets1.lottiefiles.com/packages/lf20_ojvdktpp.json'):Lottie.network('https://assets7.lottiefiles.com/packages/lf20_ru9rYQ.json',repeat: false);

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
            children: [SizedBox(height:20),
              Row(children: [IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))],),
              SizedBox(height: 240,),
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
              onChanged: (String a){
                  setState(() {
                    isSubmitted = true;
                  });
              },),
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
                    onPress: ()  {
                     setState(() {
                       isSubmitted= false;
                     });
                      service.addUserToProject(textController.text, widget.project);
                    }),
              ),  SizedBox(height: 200,width: 400,
                  child: animation)
            ],
          ),
        ),
      );
  }
}
