import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components/defaults.dart';
import 'package:shop_app/shared/cubit/shop_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildCategoryItem(
              ShopCubit.get(context).categoriesModel.data.data[index]),
          separatorBuilder: (context, index) =>
              buildDivider(color: Colors.grey),
          itemCount: 10,
        );
      },
    );
  }

  Widget buildCategoryItem(Datum model) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image(
              image: NetworkImage("${model.image}"),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "${model.name}",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
}
