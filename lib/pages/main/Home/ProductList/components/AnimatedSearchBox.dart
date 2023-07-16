import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimatedSearchBox extends StatelessWidget {
  const AnimatedSearchBox({
    Key? key,
    required this.focusNode,
    required this.editingController,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocBuilder<CategoryGridBarBloc, CategoryGridBarState>(
      builder: (context, state) {
        return AnimatedContainer(
          onEnd: () {
            if (!state.isClosing) {
              context.read<CategoryGridBarBloc>().setSuffixMode(true);
            } else {
              if (w < 768) {
                context.read<CategoryGridBarBloc>().changeTitleStatus(true);
                editingController.text = "";
              }
            }
          },
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 1000),
          padding: EdgeInsets.only(
              top: 20, left: state.isClosing ? 20 : 0, right: 20, bottom: 20),
          width: w < 768 ? state.searchWidth : 300,
          height: 80,
          color: Colors.white,
          child: SizedBox(
            height: 40,
            child: CupertinoSearchTextField(
              placeholder: "Axtarış",
              focusNode: focusNode,
              onTap: () {
                if (state.isClosing) {
                  context.read<CategoryGridBarBloc>().set(
                      width: MediaQuery.of(context).size.width - 57,
                      isClosing: false);
                  if (w < 768) {
                    context
                        .read<CategoryGridBarBloc>()
                        .changeTitleStatus(false);
                  }
                }
              },
              suffixIcon: const Icon(Icons.close),
              suffixMode: state.suffixMode
                  ? OverlayVisibilityMode.always
                  : OverlayVisibilityMode.never,
              suffixInsets: const EdgeInsets.only(right: 10),
              onSuffixTap: () {
                context
                    .read<CategoryGridBarBloc>()
                    .set(width: 80, suffixMode: false, isClosing: true);
                focusNode.unfocus();
                editingController.text = "";
                context.read<SearchPageBloc>().setSearch('');
              },
              onChanged: (value) {
                context.read<SearchPageBloc>().setSearch(value);
              },
              controller: editingController,
              prefixInsets: const EdgeInsets.only(left: 10),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
          ),
        );
      },
    );
  }
}
