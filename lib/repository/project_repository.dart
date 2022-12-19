import 'package:remainder/repository/project_friends.dart';
import 'package:remainder/repository/tasks_repository.dart';

class ProjectRepository{
  final List<Project> projects=[
    Project("Project1",2,[
      Task("Functional Req1",Friend("Semih","Yağcı") ,DateTime.now()),
      Task("Functional Req2", Friend("Ahmet","Güllü"), DateTime.now().subtract(Duration(days: 1)))
     ],[
       Friend("Semih", "Yağcı"),
      Friend("Ahmet", "Yalın"),
      Friend("Mehmet", "Çakıcı")
    ]
    ),
    Project("Project2",2,[
      Task("Functional Req5",Friend("Semih","Yağcı") ,DateTime.now()),
      Task("Functional Req6", Friend("Ahmet","Güllü"), DateTime.now().subtract(Duration(days: 1)))
    ],[
      Friend("Semih", "Yağcı"),
      Friend("Ahmet", "Yalın"),
      Friend("cakkıdı", "gaming")
    ]
    )
  ];
}



class Project {
  String projectName;
  int includedTaskNumber;
  List<Task> tasks;
  List<Friend> includedPeople;

  Project(this.projectName, this.includedTaskNumber, this.tasks,this.includedPeople);
}