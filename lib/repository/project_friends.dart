import 'package:remainder/models/people.dart';

class ProjectFriendsRepository{
  static final List<People> friends=[
    People("Wajahat", "Karim", false),
    People("Gazihan", "Alankus", true),
    People("Hamza", "Cekirdek", true)

  ];

  void addFriend(People friend){
    friends.add(friend);
  }
}
