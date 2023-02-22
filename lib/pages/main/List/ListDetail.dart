import 'package:auto_route/auto_route.dart';
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
import 'package:collection/collection.dart';

class ListDetailRoute extends StatefulWidget {
  final String? id;
  const ListDetailRoute({Key? key, @pathParam this.id}) : super(key: key);

  @override
  State<ListDetailRoute> createState() => _ListDetailRouteState();
}

class _ListDetailRouteState extends State<ListDetailRoute> {
  TextEditingController editingController = TextEditingController();
  UserList? list;
  String sendText = "";
  @override
  void initState() {
    list = context
        .read<GlobalBloc>()
        .state
        .userData
        ?.list
        .firstWhereOrNull((element) => element.id == widget.id);

    if (list != null && list!.details.isNotEmpty) {
      sendText = list!.details
          .map((e) => e.name + " " + (e.isDone ? "+" : "-"))
          .join("\n");
    }
    super.initState();
  }

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
            if (list == null) {
              return const SizedBox(
                child: Text("Bu list sizə məxsus deyil"),
              );
            }
            return ScaffoldWrapper(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    leading: GestureDetector(
                        onTap: () {
                          context.router.pop(context);
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
                            context.read<GlobalBloc>().removeList(list!);
                            context.router.pop(context);
                          }
                        },
                      ),
                      //Shared Button
                      IconButton(
                        icon: const Icon(Icons.share),
                        tooltip: 'Share',
                        onPressed: () {
                          Share.share(sendText, subject: list!.name);
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
                        Text(list?.name ?? "",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 25),
                        if (list != null && globalState.userData != null)
                          ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: list!.details.length,
                              itemBuilder: (context, index) {
                                UserListDetail detail = globalState
                                    .userData!.list
                                    .firstWhere(
                                        (element) => element.id == list!.id)
                                    .details[index];
                                return CheckboxListTile(
                                  secondary: Wrap(
                                    spacing: 25,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<GlobalBloc>()
                                              .removeDetail(list!, detail);
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
                                        .changeDetailStatus(list!, detail);
                                  },
                                );
                              },
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }

                                context.read<GlobalBloc>().reorderDetail(
                                    list!, list!.details[oldIndex], newIndex);
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
                                    list!,
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
