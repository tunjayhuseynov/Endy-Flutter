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

class ScrollableCategory extends StatelessWidget {
  const ScrollableCategory({
    Key? key,
    required this.company,
    required this.subcategory,
    required this.selectedId,
    required this.category,
    required this.fnSetState,
    required this.client,
  }) : super(key: key);

  final Company? company;
  final Subcategory? subcategory;
  final Category? category;
  final String selectedId;
  final Function(String selectedId) fnSetState;
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
                  itemCount: company!.subcategories.length,
                  itemBuilder: (context, index) {
                    final curr = company!.subcategories[index];
                    return CategoryFilterItem(
                        isSelected: selectedId == curr.id,
                        subcategory: curr,
                        fn: (Subcategory subcategory) {
                          context.read<CategoryGridBarBloc>().deleteCache();
                          fnSetState(subcategory.id);
                          context.read<CategoryCacheBloc>().reset();
                          context.read<CategoryCacheBloc>().getResult(
                              category, company, subcategory, client,
                              mode: filterState);
                          context.read<CategoryGridBloc>().set(
                              company: company,
                              subcategory: subcategory,
                              category: category);
                        });
                  }),
            );
          },
        );
      },
    );
  }
}
