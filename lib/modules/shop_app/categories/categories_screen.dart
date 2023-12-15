
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_cubit.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/models/shop_models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCategoriesScreen extends StatelessWidget{
  const ShopCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopHomeCubit,ShopHomeStates>(
      listener: (BuildContext context, ShopHomeStates state) {  },
      builder: (BuildContext context, ShopHomeStates state) {
        var cubit = ShopHomeCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.categoriesModel!=null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => categoryItem(cubit.categoriesModel!.data!.data![index]),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                itemCount: cubit.categoriesModel!.data!.data!.length
              ),
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator())
        );
      }
    );
  }

  Widget categoryItem(CategoriesData model)=>Row(
    children: [
      Image(
        image: NetworkImage(model.image!),
        width: 100,
        height: 100,
      ),
      const SizedBox(width: 10,),
      Text(
        model.name!,
        style: const TextStyle(color: Colors.black,fontSize: 15),
      ),
      const Spacer(),
      IconButton(
          onPressed: (){},
          icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,)
      )
    ],
  );

}