import 'package:endy/Pages/main/Home/CategoryGrid/Category_Cache_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryListItem.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class ScrollableAllButton extends StatelessWidget {
  const ScrollableAllButton({
    Key? key,
    required this.category,
    required this.subcategory,
    required this.company,
    required this.fnSetState,
    required this.selectedId,
    required this.client,
  }) : super(key: key);

  final Category? category;
  final Subcategory? subcategory;
  final Company? company;
  final Function(String selectedId) fnSetState;
  final String selectedId;
  final Client client;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return BlocBuilder<FilterPageBloc, FilterPageState>(
          builder: (filterContext, filterState) {
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
                            context.read<CategoryGridBarBloc>().deleteCache();
                            context.read<CategoryGridBloc>().set(
                                category: category,
                                subcategory: null,
                                company: company);

                            context.read<CategoryCacheBloc>().reset();
                            context.read<CategoryCacheBloc>().getResult(
                                category, company, null, client,
                                mode: filterState);
                          });
                    }
                    final curr =
                        category!.subcategory[index - 1] as Subcategory;
                    return CategoryFilterItem(
                        isSelected: selectedId == curr.id,
                        subcategory: curr,
                        fn: (Subcategory subcategory) {
                          context.read<CategoryGridBarBloc>().deleteCache();

                          fnSetState(selectedId == curr.id ? "" : curr.id);

                          context.read<CategoryGridBloc>().set(
                              category: category,
                              subcategory: selectedId == curr.id ? null : curr,
                              company: company);

                          context.read<CategoryCacheBloc>().reset();

                          context.read<CategoryCacheBloc>().getResult(
                              category,
                              company,
                              selectedId == curr.id ? null : curr,
                              client,
                              mode: filterState);
                        });
                  }),
            );
          },
        );
      },
    );
  }
}
