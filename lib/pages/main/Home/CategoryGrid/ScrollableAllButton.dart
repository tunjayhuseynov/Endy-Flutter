import 'package:async/async.dart';
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

class ScrollableAllButton extends StatefulWidget {
  ScrollableAllButton({
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
  State<ScrollableAllButton> createState() => _ScrollableAllButtonState();
}

class _ScrollableAllButtonState extends State<ScrollableAllButton> {
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
                  itemCount: widget.category!.subcategory.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CategoryFilterItem(
                          isSelected: widget.selectedId == "",
                          subcategory: Subcategory(
                              id: "all",
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              products: [],
                              name: "Hamısı",
                              category: widget.category!.id),
                          fn: (Subcategory subcategory) async {
                            final ctx = context.read<CategoryCacheBloc>();
                            final state = ctx.state;
                            if (state.cancellableOperation != null) {
                              state.cancellableOperation?.cancel();
                            }
                            widget.fnSetState("");
                            context.read<CategoryGridBarBloc>().deleteCache();
                            context.read<CategoryGridBloc>().set(
                                category: widget.category,
                                subcategory: null,
                                company: widget.company);

                            context.read<CategoryCacheBloc>().reset();
                            var c = CancelableOperation.fromFuture(
                                ctx.getResult(widget.category, widget.company,
                                    null, widget.client,
                                    mode: filterState));
                            ctx.setCancelableoperation(c);

                            final newState = await c.value;
                            if (newState != null) {
                              ctx.setState(newState);
                            }
                          });
                    }
                    final curr =
                        widget.category!.subcategory[index - 1] as Subcategory;
                    return CategoryFilterItem(
                        isSelected: widget.selectedId == curr.id,
                        subcategory: curr,
                        fn: (Subcategory subcategory) async {
                          final ctx = context.read<CategoryCacheBloc>();
                          final state = ctx.state;
                          if (state.cancellableOperation != null) {
                            state.cancellableOperation?.cancel();
                          }
                          context.read<CategoryGridBarBloc>().deleteCache();

                          widget.fnSetState(
                              widget.selectedId == curr.id ? "" : curr.id);

                          context.read<CategoryGridBloc>().set(
                              category: widget.category,
                              subcategory:
                                  widget.selectedId == curr.id ? null : curr,
                              company: widget.company);

                          context.read<CategoryCacheBloc>().reset();
                          var c = CancelableOperation.fromFuture(ctx.getResult(
                              widget.category,
                              widget.company,
                              widget.selectedId == curr.id ? null : curr,
                              widget.client,
                              mode: filterState));
                          ctx.setCancelableoperation(c);

                          final newState = await c.value;
                          if (newState != null) {
                            ctx.setState(newState);
                          }
                        });
                  }),
            );
          },
        );
      },
    );
  }
}
