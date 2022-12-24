import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';

class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addProject(Project projectData) async {
    await _db.collection("projects").doc(projectData.projectName).set(projectData.toMap());
  }

  updateProject(Project projectData) async {
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
    print(snapshot.docs
        .map((docSnapshot) => Project.fromDocumentSnapshot(docSnapshot))
        .toList());
    return snapshot.docs
        .map((docSnapshot) => Project.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  addTask(Project project,Task taskData) async {
    await _db.collection("projects").doc(project.projectName).collection("tasks").add(taskData.toMap());
  }

  updateTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").update(taskData.toMap());
  }

  Future<void> deleteTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").collection(taskData.content).doc().delete();
  }

  Future<List<Task>> retrieveTasks(Project projectData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection("projects").doc(projectData.projectName).collection("tasks").get();
    return snapshot.docs
        .map((docSnapshot) => Task.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
