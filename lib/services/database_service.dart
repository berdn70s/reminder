import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:remainder/models/message.dart';
import 'package:remainder/models/person.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProject(Project projectData) async {
    projectData.id = _db.collection("projects").doc().id;
    await _db
        .collection("projects")
        .doc(projectData.id)
        .set(projectData.toMap());

    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.docs[0].data()["firstName"]);
    String lastName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.docs[0].data()["lastName"]);
    String full = firstName + " " + lastName;

    Message message= Message("${full} is created this project.", "Admin", "1", DateTime.now().millisecondsSinceEpoch);
    await _db
        .collection("projects")
        .doc(projectData.id)
        .collection("messages")
        .doc()
        .set(message.toMap());
  }

  Future<void> addUser(Person person) async {
    await _db.collection("users").doc(person.uid).set(person.toMap());
  }

  Future<void> updateUser(Person person) async {
    await _db.collection("users").doc(person.uid).update(person.toMap());
  }

  Future<void> addProjectToUser(String id, Project project) async {
    await _db.collection("users").doc(id).update({
      'projects': FieldValue.arrayUnion([project.id])
    });
    project.contributors.add(id);
  }

  Future<void> addUserToProject(String email, Project project) async {
    String id = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs[0].data()['uid'].toString());
    await _db.collection("projects").doc(project.id).update({
      'contributors': FieldValue.arrayUnion([id])
    });
    addProjectToUser(id, project);
    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["firstName"]);
    String lastName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["lastName"]);
    String full = firstName + " " + lastName;

    Message message= Message("${full} is joined", "Admin", "1", DateTime.now().millisecondsSinceEpoch);
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("messages")
        .doc()
        .set(message.toMap());
  }

  Future<void> updateProject(Project projectData) async {
    await _db
        .collection("projects")
        .doc(projectData.id)
        .update(projectData.toMap());
  }

  Future<void> deleteProject(String id, Project projectData) async {
    await _db.collection("users").doc(id).update({
      'projects': FieldValue.arrayRemove([projectData.id])
    });
    await _db.collection("projects").doc(projectData.id).update({
      'contributors': FieldValue.arrayRemove([id])
    });

    if (projectData.contributors.length == 1) {
      await _db.collection("projects").doc(projectData.id).delete();
      deleteMessages(projectData);
      deleteTasks(projectData);
    }else{
      String firstName = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: id)
          .get()
          .then((value) => value.docs[0].data()["firstName"]);
      String lastName = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: id)
          .get()
          .then((value) => value.docs[0].data()["lastName"]);
      String full = firstName + " " + lastName;

      Message message= Message("${full} is left", "Admin", "1", DateTime.now().millisecondsSinceEpoch);
      await _db
          .collection("projects")
          .doc(projectData.id)
          .collection("messages")
          .doc()
          .set(message.toMap());
    }
  }

  Future<void> deleteMessages(Project projectData) async {
    await _db
        .collection("projects")
        .doc(projectData.id)
        .collection("messages")
        .get()
        .then((value) {
      for (var ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> deleteTasks(Project project) async {
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("tasks")
        .get()
        .then((value) {
      for (var ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<List<Project>> retrieveProjects(String id) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("projects")
        .where("contributors", arrayContains: id)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Project.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> addTask(Project project, Task taskData) async {
    taskData.id =
        _db.collection("projects").doc(project.id).collection("tasks").doc().id;
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("tasks")
        .doc(taskData.id)
        .set(taskData.toMap());
    String id=FirebaseAuth.instance.currentUser!.uid;
    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["firstName"]);
    String lastName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["lastName"]);
    String full = firstName + " " + lastName;

    Message message= Message("${full} is added task ${taskData.content}", "Admin", "1", DateTime.now().millisecondsSinceEpoch);
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("messages")
        .doc()
        .set(message.toMap());
  }

  Future<void> updateTask(Project project, Task taskData) async {
    String oldName= await FirebaseFirestore.instance
        .collection("projects").doc(project.id).collection("tasks")
        .where("id", isEqualTo: taskData.id)
        .get()
        .then((value) => value.docs[0].data()["content"]);
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("tasks")
        .doc(taskData.id)
        .update(taskData.toMap());
    String id=FirebaseAuth.instance.currentUser!.uid;
    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["firstName"]);
    String lastName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["lastName"]);
    String full = firstName + " " + lastName;

    Message message= Message("${full} is edited task ${oldName} to ${taskData.content}", "Admin", "1", DateTime.now().millisecondsSinceEpoch);
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("messages")
        .doc()
        .set(message.toMap());
  }

  Future<void> deleteTask(Project project, Task taskData) async {
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("tasks")
        .doc(taskData.id)
        .delete();
    String id=FirebaseAuth.instance.currentUser!.uid;
    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["firstName"]);
    String lastName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["lastName"]);
    String full = firstName + " " + lastName;

    Message message= Message("${full} is deleted the task  ${taskData.content}", "Admin", "1", DateTime.now().millisecondsSinceEpoch);
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("messages")
        .doc()
        .set(message.toMap());
  }

  Future<List<Task>> retrieveTasks(Project projectData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("projects")
        .doc(projectData.id)
        .collection("tasks")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Task.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> addMessage(Project project, Message messageData) async {
    await _db
        .collection("projects")
        .doc(project.id)
        .collection("messages")
        .doc()
        .set(messageData.toMap());
  }

  Future<List<Message>> retrieveMessage(Project projectData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("projects")
        .doc(projectData.id)
        .collection("messages")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Message.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
