import 'package:endy/Pages/main/Home/FilterPage/FilterPage.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPageScaffold extends StatelessWidget {
  const FilterPageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                // Navigator.pushNamedAndRemoveUntil(context, "/home/main/all", (route) => false);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text('Filtrlər',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          actions: [
            TextButton(
                onPressed: () {
                  context
                      .read<FilterPageBloc>()
                      .changeFilter(FilterPageState.none);
                },
                child: const Text("Sıfırla"))
          ],
        ),
        body: FilterPage());
  }
}
