
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_cubit.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/models/shop_models/search_model.dart';
import 'package:first_flutter/modules/shop_app/search/cubit/shop_search_cubit.dart';
import 'package:first_flutter/modules/shop_app/search/cubit/shop_search_states.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopSearchScreen extends StatelessWidget{

  final BuildContext homeContext;
  ShopSearchScreen({required this.homeContext,super.key});



  TextEditingController searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  final debouncer = Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ShopSearchCubit(),
        child: BlocConsumer<ShopSearchCubit,ShopSearchStates>(
          listener: (BuildContext context, ShopSearchStates state) {  },
          builder: (BuildContext context, ShopSearchStates state) {
            var cubit = ShopSearchCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    DefaultTextField(
                        controller: searchController,
                        type: TextInputType.text,
                        label: 'Search',
                        prefix: Icons.search,
                        validate: (value){
                          if(value==null||value.isEmpty)return 'Enter text to search';
                        },
                        onSubmit: (text){
                          if(formKey.currentState!.validate()){
                            cubit.searchProducts(text);
                          }
                        },
                        onChange: (text){
                          if(formKey.currentState!.validate()){
                            searchController.addListener(() => debouncer.value = text);
                            debouncer.values.listen((search) => cubit.searchProducts(search));
                          }
                        }
                    ),
                    const SizedBox(height: 20,),
                    if(state is ShopSearchLoadingState)
                      const LinearProgressIndicator(),
                      const SizedBox(height: 10,),
                    if(state is ShopSearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index) => searchItem(cubit.model!.data!.data![index], cubit),
                            separatorBuilder: (context,index) => const SizedBox(height: 20,),
                            itemCount: cubit.model!.data!.data!.length
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }

  Widget searchItem(SearchData model,ShopSearchCubit cubit) => SizedBox(
    height: 110,
    width: double.infinity,
    child: Row(
      children: [
        Image(
          image: NetworkImage(model.image!),
          height: 100,
          width: 100,
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
                    const Spacer(),
                    BlocProvider.value(
                      value: BlocProvider.of<ShopHomeCubit>(homeContext),
                      child: BlocConsumer<ShopHomeCubit,ShopHomeStates>(
                        listener: (BuildContext context, ShopHomeStates state) {  },
                        builder: (BuildContext context, ShopHomeStates state) {
                          var homeCubit = ShopHomeCubit.get(context);
                          return IconButton(
                            onPressed: (){
                              homeCubit.changeFavorite(model.id);
                            },
                            icon: CircleAvatar(
                                radius: 15,
                                backgroundColor: (homeCubit.favorites[model.id]!=null && homeCubit.favorites[model.id]!)?defaultColor:Colors.grey,
                                child: const Icon(Icons.favorite_border,color: Colors.white,size: 16,)
                            ),
                            color: Colors.grey,
                          );
                        },
                      ),
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