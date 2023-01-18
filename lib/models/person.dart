import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remainder/models/project.dart';

class Person {
  String firstName;
  String lastName;
  String email;
  String uid;
  List<Project> projects;
   bool? isDoingTask = false;
  final _user = FirebaseAuth.instance.currentUser;

  Person(this.firstName, this.lastName, this.email, this.uid, this.projects,
      {this.isDoingTask});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': _user!.email,
      'projects': projects,
      'uid': _user!.uid,
    };
  }

  Person.fromMap(Map<String, dynamic> peopleMap)
      : firstName = peopleMap["firstName"],
        lastName = peopleMap["lastName"],
        email = peopleMap["email"],
        projects = peopleMap["projects"],
        uid = peopleMap["uid"];

  Person.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : firstName = doc.data()!["firstName"],
        lastName = doc.data()!["lastName"],
        email = doc.data()!["email"],
        projects = doc.data()?["projects"] == null
            ? null
            : doc.data()?["projects"].cast<Project>(),
        uid = doc.data()!["uid"];
}
