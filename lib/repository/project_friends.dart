import 'package:remainder/models/people.dart';

class ProjectFriendsRepository{
  static final List<People> friends=[
    People("Semih", "Yagci"),
    People("Ahmet", "Yalin"),
    People("Mehmet", "Cakici")
  ];

  void addFriend(People friend){
    friends.add(friend);
  }
}
