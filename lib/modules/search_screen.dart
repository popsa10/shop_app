import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/shared/components/defaults.dart';
import 'package:shop_app/shared/cubit/search_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/search_cubit/states.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var formKey = GlobalKey<FormState>();
          var searchController = TextEditingController();
          SearchModel cubit = SearchCubit.get(context).model;
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      defaultFormField(
                          controller: searchController,
                          label: "Search",
                          validate: (String value) {
                            if (formKey.currentState.validate()) {
                              return " Enter Product To Search";
                            }
                          },
                          prefix: Icons.search,
                          type: TextInputType.text,
                          onSubmit: (String value) {
                            SearchCubit.get(context).getSearch(value);
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      if (state is SearchLoadingState)
                        LinearProgressIndicator(),
                      SizedBox(
                        height: 15,
                      ),
                      if (state is SearchSuccessState)
                        Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    buildProductItem(cubit.data.data[index]),
                                separatorBuilder: (context, index) =>
                                    buildDivider(color: Colors.grey),
                                itemCount: cubit.data.data.length))
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buildProductItem(Product model) => Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: Colors.grey[200],
          child: ListTile(
            leading: Image(
              width: 100,
              image: NetworkImage(model.image),
              fit: BoxFit.cover,
            ),
            title: Text(
              model.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text("Price is ${model.price.round()}"),
          ),
        ),
      );
}
