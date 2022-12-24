import 'package:remainder/models/people.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/models/task.dart';
import 'package:remainder/repository/project_friends.dart';
import 'package:remainder/repository/tasks_repository.dart';

class ProjectRepository{
  final List<Project> projects=[
    Project("Project1",[
      Task("Functional Req1","ananıs", [People("Ahmet", "Yalın")],),
     ],[
       People("Semih", "Yağcı"),
      People("Ahmet", "Yalın"),
      People("Mehmet", "Çakıcı")
    ]
    ),
  ];

  void downloadProject(){

  }
}
