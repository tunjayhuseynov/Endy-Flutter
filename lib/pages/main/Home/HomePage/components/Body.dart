import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/components/MostViewed.dart';
import 'package:endy/Pages/main/Home/HomePage/components/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:typesense/typesense.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          if (context.read<GlobalBloc>().state.isMostViewedDisabled == false)
            MostViwed(),
          ProductListFourGrid(),
        ],
      ),
    ));
  }
}
