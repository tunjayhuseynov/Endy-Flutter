import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xid/xid.dart';

class ListHomeRoute extends StatefulWidget {
  const ListHomeRoute({Key? key}) : super(key: key);

  @override
  State<ListHomeRoute> createState() => _ListHomeRouteState();
}

class _ListHomeRouteState extends State<ListHomeRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return ScaffoldWrapper(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  context.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios)),
            title: const Text("List",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: ListView(shrinkWrap: true, children: [
                    // const SizedBox(height: 20),
                    if (state.userData != null)
                      SingleChildScrollView(
                        child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.userData?.list.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child:
                                  ListItem(detail: state.userData!.list[index]),
                            );
                          },
                        ),
                      ),
                  ]),
                ),
                Positioned(
                  right: 0,
                  bottom: 20,
                  child: FloatingActionButton(
                    // heroTag: "addList",
                    backgroundColor: const Color(mainColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () async {
                      final response = await _showInputDialog();
                      if (response != null) {
                        final String text = response as String;
                        if (!mounted) return;
                        context.read<GlobalBloc>().addList(UserList(
                            id: Xid().toString(), name: text, details: []));
                      }
                    },
                    child: const Icon(Icons.add, size: 32, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showInputDialog() {
    TextEditingController editingController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Listin adını daxil edin',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                CupertinoTextField(
                  controller: editingController,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              child: const Text('Ləvğ et'),
              onPressed: () {
                context.pop(context);
              },
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              child: const Text('Hazır'),
              onPressed: () {
                if (editingController.text.isNotEmpty) {
                  context.pop(editingController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final UserList detail;
  const ListItem({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(APP_PAGE.SHOPPING_LIST_DETAIL.toName,
            pathParameters: {"id": detail.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Text(detail.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
