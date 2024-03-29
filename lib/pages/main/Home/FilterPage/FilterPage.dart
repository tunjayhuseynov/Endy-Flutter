 
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FilterPage extends StatefulWidget {
  final bool? isModal;
  const FilterPage({Key? key, this.isModal}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late FilterPageState selectedInput;

  @override
  void initState() {
    selectedInput = context.read<FilterPageBloc>().state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterPageBloc, FilterPageState>(
      listener: (context, state) {
          setState(() {
            selectedInput = state;
          });
      },
      builder: (context, state) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Çeşidləmə",
                style:
                    TextStyle(fontWeight: FontWeight.w500, letterSpacing: .5)),
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
                      setState(() {
                        selectedInput = FilterPageState.lastDay;
                      });
                    } else {
                      setState(() {
                        selectedInput = FilterPageState.none;
                      });
                    }
                  },
                  value: selectedInput == FilterPageState.lastDay,
                  title:
                      const Text("Son bir gün", style: TextStyle(fontSize: 18)),
                ),
                const Divider(thickness: 1),
                CheckboxListTile(
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  activeColor: const Color(mainColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  onChanged: (res) {
                    if (res != null && res) {
                      setState(() {
                        selectedInput = FilterPageState.moreThan20;
                      });
                    } else {
                      setState(() {
                        selectedInput = FilterPageState.none;
                      });
                    }
                  },
                  value: selectedInput == FilterPageState.moreThan20,
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
                      setState(() {
                        selectedInput = FilterPageState.lastAdded;
                      });
                    } else {
                      setState(() {
                        selectedInput = FilterPageState.none;
                      });
                    }
                  },
                  value: selectedInput == FilterPageState.lastAdded,
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
                if (selectedInput != state)
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          context
                              .read<FilterPageBloc>()
                              .changeFilter(selectedInput);
                          if (widget.isModal != true) {
                            context.pop(selectedInput);
                          }
                        },
                        child: Text("Təsdiqlə",
                            style: const TextStyle(
                                fontSize: 18, color: Color(mainColor)))),
                  )
              ],
            ),
          )
        ]);
      },
    );
  }
}
