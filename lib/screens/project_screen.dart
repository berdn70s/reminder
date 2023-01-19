import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/screens/task_screen.dart';
import 'package:remainder/services/database_service.dart';


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
    projectList =
        service.retrieveProjects(FirebaseAuth.instance.currentUser!.uid);
    retrievedProjectList =
    await service.retrieveProjects(FirebaseAuth.instance.currentUser!.uid);
  }

  addProject() async {
    Project project =
    Project(controller.text, [FirebaseAuth.instance.currentUser!.uid]);
    service.addProject(project);
    service.addProjectToUser(FirebaseAuth.instance.currentUser!.uid, project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black54,
        title: Padding(
          padding: const EdgeInsets.only(left: 49),
          child: Row(
            children: [
              SizedBox(
                width: 65,
              ),
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
              SizedBox(
                width: 54,
              ),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.person_off, color: Colors.black45),
              )
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
                                          onPressed: () async {
                                            await service.deleteProject(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  constraints: BoxConstraints.loose(
                                    const Size.fromRadius(140),
                                  ),
                                  hintText: "Project's name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.2),
                                  ),
                                  labelText: 'ADD A PROJECT'),
                              autocorrect: false,
                              cursorColor: Colors.black,
                              controller: controller,
                            ),
                            IconButton(
                                onPressed: (() async {
                                  if (controller.text == "") {
                                  } else {
                                    addProject();
                                    setState(() {
                                      _initRetrieval();
                                      controller.text = "";
                                    });
                                  }
                                }),
                                icon: const Icon(
                                  Icons.add_circle_outlined,
                                  size: 35,
                                  color: Colors.grey,
                                ))
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  constraints: BoxConstraints.loose(
                                    const Size.fromRadius(140),
                                  ),
                                  hintText: "Project's name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.2),
                                  ),
                                  labelText: 'ADD A PROJECT'),
                              autocorrect: false,
                              cursorColor: Colors.black,
                              controller: controller,
                            ),
                            IconButton(
                                onPressed: (() async {
                                  if (controller.text == "") {
                                  } else {
                                    addProject();
                                    setState(() {
                                      _initRetrieval();
                                      controller.text = "";
                                    });
                                  }
                                }),
                                icon: const Icon(
                                  Icons.add_circle_outlined,
                                  size: 35,
                                  color: Colors.grey,
                                ))
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
}