import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CompanyCard.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogMain extends StatelessWidget {
  const CatalogMain({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        var companies = state.companies
            .where((element) => element.catalogs.length > 0)
            .toList();
        return Material(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                const SizedBox(height: 25),
                if (w < 1024)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kataloqlar",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                const SizedBox(height: 20),
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: companies.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCatalogMainGrid(w),
                        childAspectRatio: 300 / 150, //(250 / 430),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemBuilder: ((context, index) {
                      return CompanyCard(
                        company: companies[index],
                      );
                    })),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
