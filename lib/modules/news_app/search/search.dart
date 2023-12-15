
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/news_cubit/news_cubit.dart';
import 'package:first_flutter/shared/news_cubit/news_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget{

  SearchScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (BuildContext context, NewsStates state) {  },
      builder: (BuildContext context, NewsStates state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DefaultTextField(
                    controller: searchController,
                    type: TextInputType.text,
                    label: 'Search',
                    prefix: Icons.search,
                    validate: (value){
                      if(value==null || value.isEmpty){
                        return 'Search must not be empty';
                      }
                    },
                  onChange: (value){
                      NewsCubit.get(context).getSearchArticles(search: value);
                  }
                ),
              ),
              Expanded(child: NewsScreenItem(state,NewsCubit.get(context).searchArticles)),
            ],
          ),
        );
      }
    );
  }

}