import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGrid.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGridWeb.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Cache_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBlocProvider extends StatelessWidget {
  const CategoryBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return MultiBlocProvider(providers: [
      BlocProvider<SearchPageBloc>(
        create: (context) => SearchPageBloc(),
      ),
      BlocProvider<CategoryGridBarBloc>(
        create: (context) => CategoryGridBarBloc(),
      ),
      BlocProvider<CategoryCacheBloc>(
        create: (context) => CategoryCacheBloc(),
      ),
    ], child: w < 1024 ? CategoryGrid() : CategoryGridWeb());
  }
}
