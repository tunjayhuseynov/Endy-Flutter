import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CompanyCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogMain extends StatelessWidget {
  const CatalogMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const ScrollPhysics(),
              children: [
                const SizedBox(height: 25),
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
                LayoutBuilder(builder: (context, constraints) {
                  var companies = state.companies
                      .where((element) => element.catalogs.length > 0)
                      .toList();
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: companies.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              constraints.maxWidth * 0.66 / 175, //(250 / 430),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15),
                      itemBuilder: ((context, index) {
                        return CompanyCard(
                          company: companies[index],
                        );
                      }));
                }),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
