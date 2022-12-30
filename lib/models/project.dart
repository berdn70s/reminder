import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/people.dart';
import 'package:remainder/models/task.dart';

class Project {
  String projectName;
  List<Task> tasks;
  List<People> contributors;
  String? id;

  Project(this.projectName, this.tasks,this.contributors);

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'tasks': tasks,
      'contributors': contributors,
      'id':id
    };
  }

  Project.fromMap(Map<String, dynamic> projectMap)
      : projectName = projectMap["projectName"],
        tasks = projectMap["tasks"],
        contributors = projectMap["contributors"],
        id=projectMap["id"]
  ;

  Project.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : projectName = doc.data()!["projectName"],
        id=doc.id,
        tasks = doc.data()?["tasks"] == null
            ? null
            : doc.data()?["tasks"].cast<Task>(),
        contributors = doc.data()?["contributors"] == null
            ? null
            : doc.data()?["contributors"].cast<People>();

}