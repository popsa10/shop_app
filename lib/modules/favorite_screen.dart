import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/fav_product_model.dart';
import 'package:shop_app/shared/components/defaults.dart';
import 'package:shop_app/shared/cubit/shop_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_cubit/states.dart';
import 'package:shop_app/shared/styles/constants.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopGetFavouriteLoading,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildFavItem(
                ShopCubit.get(context)
                    .favouritesProductModel
                    .data
                    .data[index]
                    .product,
                context),
            separatorBuilder: (context, index) =>
                buildDivider(color: Colors.grey),
            itemCount:
                ShopCubit.get(context).favouritesProductModel.data.data.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildFavItem(Product model, context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 120,
          child: Row(
            children: [
              Stack(alignment: AlignmentDirectional.bottomStart, children: [
                Image(
                  height: 120,
                  image: NetworkImage(model.image),
                  width: 120,
                ),
                if (model.discount != 0)
                  Container(
                    color: Colors.red,
                    child: Text(
                      "Discount",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
              ]),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.2),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${model.price.round()}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: appColor),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        if (model.discount != 0)
                          Text(
                            "${model.oldPrice.round()}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough),
                          ),
                        Spacer(),
                        IconButton(
                            icon: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  ShopCubit.get(context).favorites[model.id]
                                      ? appColor
                                      : Colors.grey,
                              child: Icon(
                                Icons.favorite_border,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              ShopCubit.get(context)
                                  .addOrDeleteFavourite(model.id);
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
