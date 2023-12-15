
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_cubit.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/models/shop_models/ShopHomeModel.dart';
import 'package:first_flutter/models/shop_models/categories_model.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopProductsScreen extends StatelessWidget{
  const ShopProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopHomeCubit,ShopHomeStates>(
      listener: (context,state){
        if(state is ShopHomeChangeFavoriteSuccessState){
          if(!state.model.status!){
            defaultToast(message: state.model.message!, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context,state){
        return ConditionalBuilder(
            condition: ShopHomeCubit.get(context).model!=null && ShopHomeCubit.get(context).categoriesModel!=null,
            builder: (context) => productsBuilder(ShopHomeCubit.get(context).model!,ShopHomeCubit.get(context).categoriesModel!),
            fallback: (context) => const Center(child: CircularProgressIndicator())
        );
      }
    );
  }


  Widget productsBuilder(ShopHomeModel model,CategoriesModel categoriesModel) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      children: [
        CarouselSlider(
            items:
              model.data!.banners!.map((e) => Image(
                  image: NetworkImage(e.image!),
                  width: double.infinity,
                  fit: BoxFit.cover,
              ),).toList()
            ,
            options: CarouselOptions(
              height: 250,
              initialPage: 0,
              enableInfiniteScroll: true,
              viewportFraction: 1.0,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal
            )
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Categories',
                style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 100,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index)=> categoryItem(categoriesModel.data!.data![index]),
                    separatorBuilder: (context,index)=> const SizedBox(width: 10,),
                    itemCount: categoriesModel.data!.data!.length
                ),
              ),
              const SizedBox(height: 20,),
              const Text(
                'New products',
                style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1/1.75,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            children: List.generate(
                model.data!.products!.length,
                (index) => gridItem(model.data!.products![index])
            ),

        )
      ],
    ),
  );

  Widget categoryItem(CategoriesData model) => SizedBox(
    height: 100,
    width: 100,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image(
          image: NetworkImage(model.image!),
          height: 100,
          width: 100,
        ),
        Container(
          color: Colors.black.withOpacity(.6),
          width: double.infinity,
          child: Text(
            model.name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ],
    ),
  );

  Widget gridItem(Products model)=> Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Image(
            image: NetworkImage(model.image!),
            height: 200,
            width: double.infinity,
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
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
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
            Row(
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
                BlocConsumer<ShopHomeCubit,ShopHomeStates>(
                  listener: (BuildContext context, ShopHomeStates state) {  },
                  builder: (BuildContext context, ShopHomeStates state) {

                    return  IconButton(
                        onPressed: (){
                          ShopHomeCubit.get(context).changeFavorite(model.id);
                        },
                        icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: ShopHomeCubit.get(context).favorites[model.id]!?defaultColor:Colors.grey,
                            child: const Icon(Icons.favorite_border,color: Colors.white,size: 16,)
                        ),
                        color: Colors.grey,
                    );
                  },
                )
              ],
            ),
          ],
        ),
      )
    ],
  );

}