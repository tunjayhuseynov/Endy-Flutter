// import 'dart:html' as html;
import 'dart:io';

 
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/Pages/main/bonus/Bonus_Add_Bloc.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/model/user.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';


class BonusAddRoute extends StatefulWidget {
  final String? code;
  const BonusAddRoute({Key? key,  this.code}) : super(key: key);

  @override
  State<BonusAddRoute> createState() => _BonusAddRouteState();
}

class _BonusAddRouteState extends State<BonusAddRoute>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController storeController = TextEditingController();
  late TextEditingController bonusController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    bonusController = TextEditingController(text: widget.code ?? "");
  }

  @override
  void dispose() {
    tabController.dispose();
    storeController.dispose();
    bonusController.dispose();
    super.dispose();
  }

  Future<void> onAdd() async {
    try {
      BonusCard card = await context.read<BonusAddBloc>().submit(
          context.read<GlobalBloc>().state.userData,
          context.read<GlobalBloc>().state.userData?.bonusCard,
          storeController.text,
          bonusController.text);
      if (!mounted) return;
      context.read<GlobalBloc>().addBonusCard(card);
      context.pop(context);
    } catch (e) {
      print(e);
      ShowTopSnackBar(
          error: true, context, e.toString().replaceAll("Exception: ", ""));
    }
  }

  onScan() async {
    if (!kIsWeb && await Permission.camera.request().isGranted) {
      await context.pushNamed(APP_PAGE.BONUS_CARD_CAMERA.toName);
    }

    // if (kIsWeb) {
    //   html.window.navigator.mediaDevices
    //       ?.getUserMedia([
    //     {"audio": false},
    //     {"video": true}
    //   ] as Map<dynamic, dynamic>)
    //       .then((value) {
    //     context.router.pushNamed('/bonus/camera');
    //   }).catchError((e) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text("Kamera icazə verilmədi")));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BonusAddBloc, BonusAddState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: state.isComponentLoading
              ? Center(
                  child: Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Color(mainColor),
                      strokeWidth: 3,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Əlavə etmək bölməsi",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 20),
                          CupertinoTextField(
                            controller: storeController,
                            placeholder: "Mağaza Adı",
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CupertinoTextField(
                            controller: bonusController,
                            placeholder: "Kart Nömrəsi",
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "Bonus kartınızın üzərindəki müştəri kodunu daxil edin",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 25),
                          // Card that has plus icon which let user know that he can add image to the card
                          GestureDetector(
                            onTap: () {
                              context.read<BonusAddBloc>().takePhotoFront();
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: state.front == null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.add_circle,
                                              color: Color(mainColor),
                                              size: 50),
                                          SizedBox(height: 10),
                                          Text(
                                            "Bonus kartınızın şəklini yükləyin",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "(İstəyə bağlı)",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    : Image.file(File(state.front!.path)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          Center(
                            child: PrimaryButton(
                                text: "+ Kartı əlavə et",
                                width: 150,
                                fontSize: 16,
                                isLoading: state.isLoading,
                                fn: onAdd),
                          ),
                          Center(
                              child: TextButton(
                                  onPressed: onScan,
                                  child: const Text("Barkod skan edin"))),
                          const SizedBox(height: 40),
                        ]),
                  ),
                ),
        );
      },
    );
  }
}
