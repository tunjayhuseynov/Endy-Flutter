import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryListItem.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Cache_Bar_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ScrollableAllButton extends StatelessWidget {
  const ScrollableAllButton({
    Key? key,
    required this.category,
    required this.subcategory,
    required this.company,
    required this.fnSetState,
    required this.selectedId,
  }) : super(key: key);

  final Category? category;
  final Subcategory? subcategory;
  final Company? company;
  final Function(String selectedId) fnSetState;
  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return SizedBox(
          width: size.maxWidth,
          height: 35,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: category!.subcategory.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryFilterItem(
                      isSelected: selectedId == "",
                      subcategory: Subcategory(
                          id: "all",
                          createdAt: DateTime.now().millisecondsSinceEpoch,
                          products: [],
                          name: "Hamısı",
                          category: category!.id),
                      fn: (Subcategory subcategory) {
                        fnSetState("");
                        context.read<CategoryGridCacheBloc>().deleteCache();
                        context.read<CategoryGridBloc>().set(
                            category: category,
                            subcategory: null,
                            company: company);
                      });
                }
                final curr = category!.subcategory[index - 1] as Subcategory;
                return CategoryFilterItem(
                    isSelected: selectedId == curr.id,
                    subcategory: curr,
                    fn: (Subcategory subcategory) {
                      context.read<CategoryGridCacheBloc>().deleteCache();
                      if (selectedId == curr.id) {
                        fnSetState("");
                        context.read<CategoryGridBloc>().set(
                            category: category,
                            subcategory: null,
                            company: company);
                      } else {
                        fnSetState(curr.id);
                        context.read<CategoryGridBloc>().set(
                            category: category,
                            subcategory: curr,
                            company: company);
                      }
                    });
              }),
        );
      },
    );
  }
}
