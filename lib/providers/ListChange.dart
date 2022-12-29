import 'package:endy/providers/UserChange.dart';
import 'package:endy/types/user.dart';

class ListChange extends UserChange {


  void addList(UserList list) {
    if (user != null) {
      user!.list.add(list);
      // setPreference(user!);
      updateUser(user!);
    }
  }

  void removeList(UserList list) {
    if (user != null) {
      user!.list.remove(list);
      // setPreference(user!);
      updateUser(user!);
    }
  }

  void addListDetail(UserList userList, UserListDetail detail) {
    if (user != null) {
      user!.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .add(detail);
      // setPreference(user!);
      updateUser(user!);
    }
  }

  void changeDetailStatus(UserList userList, UserListDetail detail) {
    if (user != null) {
      user!.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .firstWhere((d) => d.id == detail.id)
          .isDone = !detail.isDone;
      // setPreference(user!);
      updateUser(user!);
    }
  }

  //delete detail from list
  void removeDetail(UserList userList, UserListDetail detail) {
    if (user != null) {
      user!.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .removeWhere((d) => d.id == detail.id);
      // setPreference(user!);
      updateUser(user!);
    }
  }
}
