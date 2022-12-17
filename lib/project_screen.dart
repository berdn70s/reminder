import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remainder/repository/project_friends.dart';
import 'package:remainder/repository/project_repository.dart';
import 'package:remainder/task_screen.dart';

class ProjectPersonViewScreen extends StatefulWidget {
  final List<Friend> includedPeople;

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
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController controller = TextEditingController();
  ProjectRepository projectRepository = ProjectRepository();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                FirebaseAuth.instance.currentUser!.displayName.toString(),
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
                child: StreamBuilder(
                    stream: db.collection('projects').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var documentSnapShot= snapshot.data!.docs[index];
                          return Padding(
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
                                          builder: (context) => Text('data')));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        style: GoogleFonts.nunito(fontSize: 20),
                                        documentSnapShot['whotodo'].toString()),
                                  ],
                                ),
                              ),
                            ]),
                          );
                        }),
                      );
                    }),
              ),
            ),
          ),
          TextField(
            controller: controller,
          ),
          ElevatedButton(
              onPressed: addProject, child: const Text('Add project'))
        ]));
  }

  addProject() async {
    final docUser = db.collection('projects').doc(controller.text);
    final tasks = docUser.collection('tasks');
    final task = {'name': 'task1', 'desc': 'blabalbaba', 'whotodo': 'mehmet'};
    final project = {'whotodo': 'hamza'};
    await docUser.set(project);
    await tasks.add(task);
  }
}
