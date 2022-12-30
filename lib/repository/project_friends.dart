import 'package:remainder/models/people.dart';

class ProjectFriendsRepository{
  static final List<People> friends=[
    People("firstName", "lastName", true)

  ];

  void addFriend(People friend){
    friends.add(friend);
  }
}
