
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_cubit.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/models/shop_models/ShopHomeModel.dart';
import 'package:first_flutter/models/shop_models/favorites_model.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopFavoritesScreen extends StatelessWidget{
  const ShopFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopHomeCubit,ShopHomeStates>(
        listener: (BuildContext context, ShopHomeStates state) {  },
        builder: (BuildContext context, ShopHomeStates state) {
          var cubit = ShopHomeCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.favoritesModel!=null,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => favoriteItem(cubit.favoritesModel!.data!.data![index].product!,cubit),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                    itemCount: cubit.favoritesModel!.data!.data!.length
                ),
              ),
              fallback: (context) => const Center(child: CircularProgressIndicator())
          );
        }
    );//
  }

  Widget favoriteItem(Product model,ShopHomeCubit cubit) => SizedBox(
    height: 120,
    width: double.infinity,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image!),
              height: 100,
              width: 100,
            ),
            if(model.discount!>0)
              Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const Text(
                  'DISCOUNT',
                  style: TextStyle(
                      fontSize: 8,
                      color: Colors.white
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      height: 1.5
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${model.price!.round()}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: defaultColor
                      ),
                    ),
                    const SizedBox(width: 5,),
                    if(model.discount!>0)
                      Text(
                          '${model.oldPrice!.round()}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black
                          )
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: (){
                        cubit.changeFavorite(model.id);
                      },
                      icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: (cubit.favorites[model.id]!=null && cubit.favorites[model.id]!)?defaultColor:Colors.grey,
                          child: const Icon(Icons.favorite_border,color: Colors.white,size: 16,)
                      ),
                      color: Colors.grey,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );

}