import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/ProductList/components/GridBody.dart';
import 'package:endy/Pages/main/Home/ProductList/components/TopBody.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Loader.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:endy/Pages/main/Home/ProductList/components/TabBar.dart' as tab;
import 'package:collection/collection.dart';

class CompanyGrid extends StatefulWidget {
  final String? companyId;

  const CompanyGrid({
    Key? key,
    this.companyId,
  }) : super(key: key);

  @override
  State<CompanyGrid> createState() => _CompanyGridState();
}

class _CompanyGridState extends State<CompanyGrid> {
  TextEditingController editingController = TextEditingController();
  final client = Client(typesenseConfig);
  var focusNode = FocusNode();
  Company? company = null;

  Future<Map> fetchData(
      {required String companyId, required GlobalState state}) async {
    return {
      "company":
          state.companies.firstWhereOrNull((element) => element.id == companyId)
    };
  }

  @override
  void initState() {
    // if (context.router.stackData.length > 1) {
    //   context.read<FilterPageBloc>().changeFilter(FilterPageState.none);
    // }

    super.initState();
  }

  @override
  void dispose() {
    // context.read<CategoryCacheBloc>().setClose();
    editingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return FutureBuilder<Map>(
        future: fetchData(
          companyId: widget.companyId ?? "",
          state: context.read<GlobalBloc>().state,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasData == false || snapshot.error != null) {
            return Center(
              child: Text("Nəsə düzgün getmədi"),
            );
          }
          var company = snapshot.data!["company"];
          return ScaffoldWrapper(
            hPadding: 0,
            appBar: tab.AppBarCategoryList(
                category: null,
                company: company,
                subcategory: null,
                focusNode: focusNode,
                editingController: editingController,
                w: w),
            backgroundColor: Colors.white,
            body: w < 1024
                ? Column(
                    children: buildBody(w: w, company: company),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: buildBody(w: w, company: company),
                    ),
                  ),
          );
        });
  }

  List<Widget> buildBody({
    required double w,
    required Company? company,
  }) {
    return [
      if (w >= 1024) const Navbar(),
      if (company == null)
        Center(
          child: CircularProgressIndicator(
            color: Color(mainColor),
          ),
        ),
      if (w < 1024 && (company != null))
        Expanded(child: body(w: w, company: company)),
      if (w >= 1024 && (company != null)) body(w: w, company: company),
      if (w >= 1024) const Footer(),
    ];
  }

  Widget body({required double w, required Company company}) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
      children: [
        if (w >= 1024) const Padding(padding: EdgeInsets.only(top: 50)),
        const Padding(padding: EdgeInsets.only(top: 20)),
        TopBody(company: company),
        BlocBuilder<SearchPageBloc, SearchPageState>(
            buildWhen: (previous, current) => previous.search != current.search,
            builder: (context, searchState) {
              return searchState.search.isNotEmpty
                  ? SearchPageRoute(
                      companyId: widget.companyId,
                      noTabbar: true,
                      params: searchState.search,
                    )
                  : GridBody(
                      client: client,
                      companyId: company.id,
                    );
            })
      ],
    );
  }
}
