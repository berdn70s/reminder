import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';

class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future <void> addProject(Project projectData) async {
    await _db.collection("projects").doc(projectData.projectName).set(projectData.toMap());
  }

  Future <void> updateProject(Project projectData) async {
    await _db
        .collection("projects")
        .doc(projectData.projectName)
        .update(projectData.toMap());
  }

  Future<void> deleteProject(Project projectData) async {
    await _db.collection("projects").doc(projectData.projectName).delete();
  }

  Future<List<Project>> retrieveProjects() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("projects").get();
    return snapshot.docs
        .map((docSnapshot) => Project.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  Future <void> addTask(Project project,Task taskData) async {
    await _db.collection("projects").doc(project.projectName).collection("tasks").doc(taskData.content).set(taskData.toMap());
  }

  Future <void> updateTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").update(taskData.toMap());
  }

  Future<void> deleteTask(Project project,Task taskData) async {
    await _db.collection("projects").doc(project.projectName).collection("tasks").doc(taskData.content).delete();
  }

  Future<List<Task>> retrieveTasks(Project projectData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection("projects").doc(projectData.projectName).collection("tasks").get();
    return snapshot.docs
        .map((docSnapshot) => Task.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
