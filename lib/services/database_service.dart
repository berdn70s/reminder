import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/Person.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';

class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future <void> addProject(Project projectData) async {
    projectData.id= _db.collection("projects").doc().id;
    await _db.collection("projects").doc(projectData.id).set(projectData.toMap());
  }
  Future <void> addUser(Person person) async {
    await _db.collection("users").doc(person.uid).set(person.toMap());
  }

  Future <void> updateProject(Project projectData) async {
    await _db
        .collection("projects")
        .doc(projectData.id)
        .update(projectData.toMap());
  }

  Future<void> deleteProject(Project projectData) async {
    await _db.collection("projects").doc(projectData.id).delete();
  }

  Future<List<Project>> retrieveProjects() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("projects").get();
    return snapshot.docs
        .map((docSnapshot) => Project.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  Future <void> addTask(Project project,Task taskData) async {
    await _db.collection("projects").doc(project.id).collection("tasks").doc(taskData.content).set(taskData.toMap());
  }

  Future <void> updateTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").update(taskData.toMap());
  }

  Future<void> deleteTask(Project project,Task taskData) async {
    await _db.collection("projects").doc(project.id).collection("tasks").doc(taskData.content).delete();
  }

  Future<List<Task>> retrieveTasks(Project projectData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection("projects").doc(projectData.id).collection("tasks").get();
    return snapshot.docs
        .map((docSnapshot) => Task.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
