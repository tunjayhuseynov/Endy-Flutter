import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/Labels/Company_Label_List_Bloc.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CompanyLabelListRoute extends StatefulWidget {
  const CompanyLabelListRoute({Key? key}) : super(key: key);

  @override
  State<CompanyLabelListRoute> createState() => _CompanyLabelListRouteState();
}

class _CompanyLabelListRouteState extends State<CompanyLabelListRoute> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CompanyLabelListBloc>().search("");
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocSelector<CompanyLabelListBloc, CompanyLabelListState,
        List<CompanyLabel>>(
      selector: (state) {
        print(context
            .read<GlobalBloc>()
            .state
            .companyLabels);
        return context
            .read<GlobalBloc>()
            .state
            .companyLabels
            .where((element) => state.searchValue != ""
                ? element.label
                    .toLowerCase()
                    .contains(state.searchValue.toLowerCase())
                : true)
            .toList();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            toolbarHeight: 80,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.pop(context);
                }),
            title: Text("Brend Növləri",
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          body: Column(
            children: [
              Container(
                width: w < 768 ? null : 300,
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  placeholder: "Axtarış",
                  onChanged: (value) {
                    context.read<CompanyLabelListBloc>().search(value);
                  },
                  controller: editingController,
                  prefixInsets: const EdgeInsets.only(left: 20),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CompanyLabelItem(
                        label: state[index],
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CompanyLabelItem extends StatelessWidget {
  final CompanyLabel label;
  const CompanyLabelItem({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final productAmount = label.subcategory.map((e) => e.products.length);
    // final amountOfSub = productAmount.isNotEmpty
    //     ? productAmount.reduce((value, element) => value + element)
    //     : 0;

    return Container(
      padding: w < 768 ? null : EdgeInsets.symmetric(horizontal: (w - 768) / 2),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          context.pushNamed(APP_PAGE.COMPANY_LIST.toName,
              pathParameters: {"id": label.label});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                width: 45,
                height: 45,
                // child: CachedNetworkImage(imageUrl: label.logo),
              ),
              Expanded(flex: 2, child: Text(label.label)),
              // Text(amountOfSub.toString(),
              //     style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
