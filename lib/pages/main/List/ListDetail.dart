import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/dialog.dart';
import 'package:endy/Pages/main/list/List_Bloc.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xid/xid.dart';

class ListDetail extends StatefulWidget {
  const ListDetail({Key? key}) : super(key: key);

  @override
  State<ListDetail> createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (globalContext, globalState) {
        return BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            final list = state.userList?.details
                .where((element) => !element.isDone)
                .map((e) => e.name)
                .toList();
            String sendText = "";
            if (list == null || state.userList == null) {
              return const SizedBox(
                child: Text("List is null"),
              );
            }
            if (list.isNotEmpty) {
              sendText = list.reduce((value, element) =>
                  "${state.userList?.name}:\n$value\n$element");
            }
            return ScaffoldWrapper(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios)),
                    title: const Text("List",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600)),
                    actions: <Widget>[
                      //Remove buttion
                      IconButton(
                        icon: const Icon(CupertinoIcons.delete),
                        tooltip: 'Remove',
                        onPressed: () async {
                          final response =
                              await Dialogs.showRemoveDialog(context);
                          if (response == true) {
                            if (!mounted) return;
                            context
                                .read<GlobalBloc>()
                                .removeList(state.userList!);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      //Shared Button
                      IconButton(
                        icon: const Icon(Icons.share),
                        tooltip: 'Share',
                        onPressed: () {
                          Share.share(sendText, subject: state.userList!.name);
                        },
                      ),
                    ]),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15),
                  child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Text(state.userList?.name ?? "",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 25),
                        if (state.userList != null &&
                            globalState.userData != null)
                          ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: state.userList!.details.length,
                              itemBuilder: (context, index) {
                                UserListDetail detail = globalState
                                    .userData!.list
                                    .firstWhere((element) =>
                                        element.id == state.userList!.id)
                                    .details[index];
                                return CheckboxListTile(
                                  secondary: Wrap(
                                    spacing: 25,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<GlobalBloc>()
                                              .removeDetail(
                                                  state.userList!, detail);
                                        },
                                        child: const Icon(Icons.remove_circle,
                                            color: Color(mainColor)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // user.removeDetail(widget.list, detail);
                                        },
                                        child: const Icon(Icons.menu,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                  activeColor: const Color(mainColor),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  key: Key(detail.id),
                                  title: Text(detail.name,
                                      style: TextStyle(
                                          decoration: detail.isDone
                                              ? TextDecoration.lineThrough
                                              : null)),
                                  value: detail.isDone,
                                  onChanged: (bool? value) {
                                    context
                                        .read<GlobalBloc>()
                                        .changeDetailStatus(
                                            state.userList!, detail);
                                  },
                                );
                              },
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }

                                context.read<GlobalBloc>().reorderDetail(
                                    state.userList!,
                                    state.userList!.details[oldIndex],
                                    newIndex);
                              }),
                        const SizedBox(height: 25),
                        CupertinoTextField(
                          controller: editingController,
                          onChanged: (value) => context
                              .read<ListBloc>()
                              .changeAddButton(value.isNotEmpty),
                          suffix: Visibility(
                            visible: state.showAddButton,
                            child: GestureDetector(
                              onTap: () {
                                context.read<GlobalBloc>().addListDetail(
                                    state.userList!,
                                    UserListDetail(
                                        id: Xid().toString(),
                                        name: editingController.text,
                                        isDone: false));
                                editingController.clear();
                                context.read<ListBloc>().changeAddButton(false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(mainColor),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        color: Colors.white,
                                        Icons.add,
                                        size: 24,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          placeholder: "Məhsul əlavə edin",
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ]),
                ));
          },
        );
      },
    );
  }
}
