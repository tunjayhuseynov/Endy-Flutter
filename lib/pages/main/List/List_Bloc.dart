import 'package:endy/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListState {
  bool showAddButton;
  UserList? userList;

  ListState({
    this.showAddButton = false,
    this.userList,
  });

  ListState copyWith({bool? showAddButton, UserList? userList}) {
    return ListState(
        showAddButton: showAddButton ?? this.showAddButton,
        userList: userList ?? this.userList);
  }
}

class ListBloc extends Cubit<ListState> {
  ListBloc() : super(ListState(showAddButton: false));

  void changeAddButton(bool showAddButton) {
    emit(state.copyWith(showAddButton: showAddButton));
  }

  void changeUserList(UserList userList) {
    emit(state.copyWith(userList: userList));
  }
}
