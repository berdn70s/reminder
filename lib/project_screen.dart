import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class ProjectsScreen extends ConsumerWidget {
  ProjectsScreen({super.key, required this.title});

  final String title;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectRepository = ref.watch(projectProvider);
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
                title,
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
                                        builder: (context) => TaskPage(
                                            projectRepository
                                                .projects[index].tasks)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      style: GoogleFonts.nunito(fontSize: 20),
                                      projectRepository
                                          .projects[index].projectName),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectPersonViewScreen(
                                                        projectRepository
                                                            .projects[index]
                                                            .includedPeople)));
                                      },
                                      icon: const Icon(Icons.person_pin))
                                ],
                              ),
                            ),
                          ]),
                        ))),
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
    CollectionReference project = FirebaseFirestore.instance.collection(controller.text);
    return project
        .add({
          'taskName': 'fullName',
          'desc': 'i dont know',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
