

class ProjectFriendsRepository{
  static final List<Friend> friends=[
    Friend("Semih", "Yagci"),
    Friend("Ahmet", "Yalin"),
    Friend("Mehmet", "Cakici")
  ];

  void addFriend(Friend friend){
    friends.add(friend);
  }
}

class Friend {
  String firstName;
  String lastName;

  Friend(this.firstName, this.lastName);
}