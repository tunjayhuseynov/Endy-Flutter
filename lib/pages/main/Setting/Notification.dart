import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPageRoute extends StatefulWidget {
  const NotificationPageRoute({Key? key}) : super(key: key);

  @override
  State<NotificationPageRoute> createState() => _NotificationPageRouteState();
}

class _NotificationPageRouteState extends State<NotificationPageRoute> {
  @override
  void initState() {
    timeago.setLocaleMessages('az', timeago.AzMessages());
    context.read<GlobalBloc>().updateNotificationSeenTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  context.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text('Bildirişlər',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          body: ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: state.userData != null
                      ? Text(state.notifications[index].title)
                      : const Text(''),
                  subtitle: state.userData != null
                      ? Text(timeago
                          .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  state.notifications[index].createdAt * 1000),
                              locale: 'az')
                          .toString())
                      : const Text(''),
                  onTap: () {
                    if (state.notifications[index].onClick != null) {
                      context.pushNamed("/home/detail/" +
                          state.notifications[index].onClick!);
                    }
                  },
                );
              }),
        );
      },
    );
  }
}
