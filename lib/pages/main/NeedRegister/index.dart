import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class NeedRegister extends StatelessWidget {
  const NeedRegister({super.key, this.activeTab});
  final bool? activeTab;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      appBar: activeTab != null && activeTab!
          ? AppBar(
              surfaceTintColor: Colors.white,
              toolbarHeight: 80,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          : null,
      body: Center(
        child: Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Bu xidməti istifadə etmək üçün zəhmət olmasa qeydiyyatdan keçin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/sign/registration", (route) => false);
                },
                child: const Text("Qeydiyyatdan keç",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(mainColor),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
