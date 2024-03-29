 
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CompanyCard.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 
class CatalogMainRoute extends StatelessWidget {
  const CatalogMainRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        var companies = state.companies
            .where((element) => element.catalogs.length > 0)
            .toList();
        return Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                if(w >= 1024) const Navbar(),
                const SizedBox(height: 25),
                if (w < 1024)
                  Container(
                    padding: EdgeInsets.only(left: getContainerSize(w)),
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
                Container(
                  constraints: BoxConstraints(minHeight: size.height),
                  padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
                  child: GridView.builder(
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
                ),
                const SizedBox(height: 50),
                if(w >= 1024) const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
