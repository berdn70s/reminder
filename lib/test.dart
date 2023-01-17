import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:bubble/issue_clipper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const title = 'Bubble Demo';

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: title,
    theme: ThemeData(
      primarySwatch: Colors.teal,
    ),
    home: const MyHomePage(
      title: title,
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const styleSomebody = BubbleStyle(
    nip: BubbleNip.leftCenter,
    color: Colors.white,
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, right: 50),
    alignment: Alignment.topLeft,
  );

  static const styleMe = BubbleStyle(
    nip: BubbleNip.rightCenter,
    color: Color.fromARGB(255, 225, 255, 199),
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 8, left: 50),
    alignment: Alignment.topRight,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Container(
      color: Colors.yellow.withAlpha(64),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Bubble(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 212, 234, 244),
            borderColor: Colors.black,
            borderWidth: 2,
            margin: const BubbleEdges.only(top: 8),
            child: const Text(
              'TODAY',
              style: TextStyle(fontSize: 10),
            ),
          ),
          Bubble(
            style: styleSomebody,
            child: const Text(
                'Hi Jason. Sorry to bother you. I have a queston for you.'),
          ),
          Bubble(
            style: styleMe,
            child: const Text("Whats'up?"),
          ),
          Bubble(
            style: styleSomebody,
            child:
            const Text("I've been having a problem with my computer."),
          ),
          Bubble(
            style: styleSomebody,
            margin: const BubbleEdges.only(top: 4),
            showNip: false,
            child: const Text('Can you help me?'),
          ),
          Bubble(
            style: styleMe,
            child: const Text('Ok'),
          ),
          Bubble(
            style: styleMe,
            showNip: false,
            margin: const BubbleEdges.only(top: 4),
            child: const Text("What's the problem?"),
          ),
          Bubble(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 212, 234, 244),
            margin: const BubbleEdges.only(top: 32, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'The failed shadow',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Platform.,

              ],
            ),
          ),
          PhysicalShape(
            clipBehavior: Clip.antiAlias,
            clipper: IssueClipper(0),
            color: Colors.lightGreen,
            elevation: 2,
            child: const SizedBox(width: 80, height: 40),
          ),
          const Divider(),
          PhysicalShape(
            clipBehavior: Clip.antiAlias,
            clipper: IssueClipper(1),
            color: Colors.lightGreen,
            elevation: 2,
            child: const SizedBox(width: 80, height: 40),
          ),
          const Divider(),
          PhysicalShape(
            clipBehavior: Clip.antiAlias,
            clipper: IssueClipper(2),
            color: Colors.lightGreen.withAlpha(64),
            elevation: 2,
            child: const SizedBox(width: 80, height: 40),
          ),
          const Divider(),
          PhysicalShape(
            clipBehavior: Clip.antiAlias,
            clipper: IssueClipper(3),
            color: Colors.lightGreen.withAlpha(64),
            elevation: 2,
            child: const SizedBox(width: 80, height: 40),
          ),
          Bubble(
            margin: const BubbleEdges.only(top: 5),
            elevation: 10,
            shadowColor: Colors.red[900],
            alignment: Alignment.topRight,
            nip: BubbleNip.rightTop,
            color: Colors.green,
            child: const Text('dsfdfdfg'),
          )
        ],
      ),
    ),
  );
}






import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/models/person.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/services/database_service.dart';
import 'package:remainder/task_screen.dart';
class ProjectPersonViewScreen extends StatefulWidget {
  final List<Person> includedPeople;

  const ProjectPersonViewScreen(this.includedPeople, {Key? key})
      : super(key: key);

  @override
  State<ProjectPersonViewScreen> createState() =>
      _ProjectPersonViewScreenState();
}

class _ProjectPersonViewScreenState extends State<ProjectPersonViewScreen> {
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
                  width: 30,
                ),
                Text(
                  "REMINDER",
                  style: GoogleFonts.barlow(color: Colors.black),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Icon(
                  Icons.timelapse,
                  color: Colors.black,
                ),
                Icon(Icons.assistant_direction)
              ],
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: ListView.builder(
                          itemCount: widget.includedPeople.length,
                          itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Text(
                                  style: GoogleFonts.nunito(fontSize: 20),
                                  "${widget.includedPeople[index].firstName} ${widget.includedPeople[index].lastName}  ",
                                )
                              ])))))))
        ]));
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  DatabaseService service = DatabaseService();
  Future<List<Project>>? projectList;
  List<Project>? retrievedProjectList;
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    projectList = service.retrieveProjects(FirebaseAuth.instance.currentUser!.uid);
    retrievedProjectList = await service.retrieveProjects(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black54,
        title: Padding(
          padding: const EdgeInsets.only(left: 49),
          child: Row(
            children: [SizedBox(width: 65,),
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
              ), SizedBox(width: 54,),
              IconButton(onPressed:(){
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);}, icon: Icon(Icons.person_off , color: Colors.black45),)

            ],
          ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: projectList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Project>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            itemCount: retrievedProjectList!.length,
                            separatorBuilder: (context, index) =>
                            const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Dismissible(
                                    onDismissed: null,
                                    background: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(16.0)),
                                      padding:
                                      const EdgeInsets.only(right: 28.0),
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: const Text(
                                        "DELETE",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    resizeDuration:
                                    const Duration(milliseconds: 200),
                                    key: UniqueKey(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 83, 80, 80),
                                          borderRadius:
                                          BorderRadius.circular(16.0)),
                                      child: ListTile(
                                        onTap: () async {
                                          List<Task> tasks =
                                          await service.retrieveTasks(
                                              retrievedProjectList![index]);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TaskPage(
                                                          tasks,
                                                          retrievedProjectList![
                                                          index])));
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                        ),
                                        title: Text(retrievedProjectList![index]
                                            .projectName),
                                        trailing: ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                              MaterialStatePropertyAll<
                                                  Color>(Colors.blueGrey),
                                              shadowColor:
                                              MaterialStatePropertyAll<
                                                  Color>(Colors.redAccent)),
                                          onPressed: () {
                                            service.deleteProject(FirebaseAuth.instance.currentUser!.uid,
                                                retrievedProjectList![index]);
                                            setState(() {
                                              _initRetrieval();
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(constraints: BoxConstraints.loose(const Size.fromRadius(140),),
                                  hintText: "Project's name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.2),

                                  ),
                                  labelText: 'ADD A PROJECT'),
                              autocorrect: false,
                              cursorColor: Colors.black,
                              controller: controller,
                            ),IconButton(onPressed: (() async {
                              addProject();
                              setState(() {
                                _initRetrieval();
                                controller.text="";
                              });
                            }), icon: const Icon(Icons.add_circle_outlined , size: 35,color: Colors.grey,))
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    retrievedProjectList!.isEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(constraints: BoxConstraints.loose(const Size.fromRadius(140),),
                                  hintText: "Project's name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.2),

                                  ),
                                  labelText: 'ADD A PROJECT'),
                              autocorrect: false,
                              cursorColor: Colors.black,
                              controller: controller,
                            ),IconButton(onPressed: (() async {
                              addProject();
                              setState(() {
                                _initRetrieval();
                                controller.text="";
                              });
                            }), icon: const Icon(Icons.add_circle_outlined , size: 35,color: Colors.grey,))
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),

    );
  }

  addProject() async {
    Project project= Project(controller.text, [FirebaseAuth.instance.currentUser!.uid]);
    service.addProject(project);
    service.addProjectToUser(FirebaseAuth.instance.currentUser!.uid, project);

  }
}