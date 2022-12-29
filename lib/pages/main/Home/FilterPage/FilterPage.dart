import 'package:endy/pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterPageBloc, FilterPageState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              toolbarHeight: 80,
              leading: IconButton(
                  onPressed: () {
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
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Çeşidləmə",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, letterSpacing: .5)),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    CheckboxListTile(
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      activeColor: const Color(mainColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onChanged: (res) {
                        if (res != null && res) {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(FilterPageState.lastDay);
                        } else {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(FilterPageState.none);
                        }
                      },
                      value: state == FilterPageState.lastDay,
                      title: const Text("Son bir gün",
                          style: TextStyle(fontSize: 18)),
                    ),
                    const Divider(thickness: 1),
                    CheckboxListTile(
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      activeColor: const Color(mainColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onChanged: (res) {
                        if (res != null && res) {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(FilterPageState.moreThan20);
                        } else {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(FilterPageState.none);
                        }
                      },
                      value: state == FilterPageState.moreThan20,
                      title: const Text("20%-dən çox endirim",
                          style: TextStyle(fontSize: 18)),
                    ),
                    const Divider(thickness: 1),
                    CheckboxListTile(
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      activeColor: const Color(mainColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onChanged: (res) {
                        if (res != null && res) {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(FilterPageState.lastAdded);
                        } else {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(FilterPageState.none);
                        }
                      },
                      value: state == FilterPageState.lastAdded,
                      title: const Text("Ən son əlavə olunanlar",
                          style: TextStyle(fontSize: 18)),
                    ),
                    const Divider(thickness: 1),
                    // CheckboxListTile(
                    //   onChanged: (res) {
                    //     if (res != null && res) {
                    //       filter.addNewModeWhNotify(Mode.nearby);
                    //     } else {
                    //       filter.removeModeWhNotify(Mode.nearby);
                    //     }
                    //   },
                    //   value: filter.mode.any((element) => element == Mode.nearby),
                    //   title: const Text("Sizə ən yaxınlar",
                    //       style: TextStyle(fontSize: 18)),
                    // ),
                    // const Divider(thickness: 1),
                  ],
                ),
              )
            ]));
      },
    );
  }
}