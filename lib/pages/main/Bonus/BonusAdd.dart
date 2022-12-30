import 'dart:io';

import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/Pages/main/bonus/Bonus_Add_Bloc.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BonusAdd extends StatefulWidget {
  final String? code;
  const BonusAdd({Key? key, this.code}) : super(key: key);

  @override
  State<BonusAdd> createState() => _BonusAddState();
}

class _BonusAddState extends State<BonusAdd>
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BonusAddBloc(),
      child: BlocBuilder<BonusAddBloc, BonusAddState>(
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
                                  fn: () async {
                                    try {
                                      BonusCard card = await context
                                          .read<BonusAddBloc>()
                                          .submit(
                                              context
                                                  .read<GlobalBloc>()
                                                  .state
                                                  .userData,
                                              context
                                                  .read<GlobalBloc>()
                                                  .state
                                                  .userData
                                                  ?.bonusCard,
                                              storeController.text,
                                              bonusController.text);
                                      if (!mounted) return;
                                      context
                                          .read<GlobalBloc>()
                                          .addBonusCard(card);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      showTopSnackBar(
                                        Overlay.of(context)!,
                                        CustomSnackBar.error(
                                          message: e
                                              .toString()
                                              .replaceAll("Exception: ", ""),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            Center(
                                child: TextButton(
                                    onPressed: () async {
                                      if (await Permission.camera
                                          .request()
                                          .isGranted) {
                                        await Navigator.pushNamed(
                                            context, '/bonus/camera');
                                      }
                                    },
                                    child: const Text("Barkod skan edin"))),
                            const SizedBox(height: 40),
                          ]),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
