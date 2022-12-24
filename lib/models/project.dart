import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/people.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/repository/project_friends.dart';
import 'package:remainder/repository/tasks_repository.dart';

class Project {
  String projectName;
  List<Task> tasks;
  List<People> contributors;

  Project(this.projectName, this.tasks,this.contributors);


  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'tasks': tasks,
      'contributors': contributors,
    };
  }

  Project.fromMap(Map<String, dynamic> projectMap)
      : projectName = projectMap["projectName"],
        tasks = projectMap["tasks"],
        contributors = projectMap["contributors"];

  Project.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : projectName = doc.data()!["projectName"],
        tasks = doc.data()?["tasks"] == null
            ? null
            : doc.data()?["tasks"].cast<Task>(),
        contributors = doc.data()?["contributors"] == null
            ? null
            : doc.data()?["contributors"].cast<People>();

}
