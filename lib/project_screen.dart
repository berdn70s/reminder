import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/database_service.dart';
import 'package:remainder/models/people.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/repository/project_repository.dart';
import 'package:remainder/task_screen.dart';

class ProjectPersonViewScreen extends StatefulWidget {
  final List<People> includedPeople;

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
    projectList = service.retrieveProjects();
    retrievedProjectList = await service.retrieveProjects();
  }

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: projectList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrievedProjectList!.length,
                    separatorBuilder: (context, index) => const SizedBox(
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
                                  borderRadius: BorderRadius.circular(16.0)),
                              padding: const EdgeInsets.only(right: 28.0),
                              alignment: AlignmentDirectional.centerEnd,
                              child: const Text(
                                "DELETE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            resizeDuration: const Duration(milliseconds: 200),
                            key: UniqueKey(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 83, 80, 80),
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: ListTile(
                                onTap: () async {
                                  List<Task> tasks = await service.retrieveTasks(
                                      retrievedProjectList![index]);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => TaskPage(tasks,retrievedProjectList![index])));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                title: Text(
                                    retrievedProjectList![index].projectName),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    service.deleteProject(
                                        retrievedProjectList![index]);
                                    setState(() {
                                      _initRetrieval();
                                    });
                                  },
                                  child: Text('delete'),
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            controller: controller,
                          )
                        ],
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.done &&
                  retrievedProjectList!.isEmpty) {
                return Center(
                  child: TextField(
                    controller: controller,
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() async {
          addProject();
          setState(() {
            _initRetrieval();
          });
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  addProject() async {
    service.addProject(Project(controller.text, [], []));
  }
}
