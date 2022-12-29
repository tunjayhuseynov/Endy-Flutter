import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          ImageProvider img = (state.userData != null &&
                  state.userData!.profilePic != null &&
                  state.userData!.profilePic!.isNotEmpty)
              ? NetworkImage(state.userData!.profilePic!)
              : const NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/endirimsebeti.appspot.com/o/noimage.jpg?alt=media&token=14382611-4d06-4301-baf0-a4a9da0f2ecd");
          return Container(
              padding: EdgeInsets.only(top: size.height * 0.1),
              width: size.width * 0.85,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Rounded image
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: img,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // User name
                      Text(
                        state.userData?.name ?? "İstifadəçi",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                          height: 35,
                          child: TextButton(
                            onPressed: () async => {
                              context.read<GlobalBloc>().logout(),
                              await FirebaseAuth.instance.signOut(),
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/sign/main", (route) => false)
                            },
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.grey[500]),
                                overlayColor: MaterialStateProperty.all<Color?>(
                                    Colors.transparent)),
                            child: const Text("Hesabdan çıxış"),
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 45,
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/setting/profile');
                          },
                          contentPadding: const EdgeInsets.all(0),
                          minLeadingWidth: 5,
                          leading: Icon(Icons.person, color: Colors.grey[800]),
                          title: const Text("Profil",
                              style: TextStyle(letterSpacing: .75)),
                        ),
                      ),
                      const Divider(thickness: 1),
                      SizedBox(
                        height: 45,
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/setting/notification');
                          },
                          contentPadding: const EdgeInsets.all(0),
                          minLeadingWidth: 5,
                          trailing: state.unseenNotificationCount > 0
                              ? Container(
                                  width: size.width * 0.05,
                                  height: size.width * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(mainColor),
                                  ),
                                  child: Center(
                                      child: Text(
                                    state.unseenNotificationCount > 9
                                        ? "9+"
                                        : state.unseenNotificationCount
                                            .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )))
                              : null,
                          leading: Icon(Icons.notifications,
                              color: Colors.grey[800]),
                          title: const Text('Bildirişlər',
                              style: TextStyle(letterSpacing: .75)),
                        ),
                      ),
                      const Divider(thickness: 1),
                      SizedBox(
                        height: 45,
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/setting/about');
                          },
                          contentPadding: const EdgeInsets.all(0),
                          minLeadingWidth: 5,
                          leading: ImageIcon(
                            const AssetImage('assets/icons/info.png'),
                            color: Colors.grey[800],
                          ),
                          title: const Text('Haqqımızda',
                              style: TextStyle(letterSpacing: .75)),
                        ),
                      ),
                      const Divider(thickness: 1),
                    ],
                  )
                ],
              ));
        },
      ),
    );
  }
}