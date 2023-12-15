
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/cubit/cubit.dart';
import 'package:first_flutter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksScreen extends StatelessWidget{
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener:(context, state){},
        builder: (context, state){
          return ListView.separated(
            itemBuilder: (context,index) => TaskItem(AppCubit.get(context).newTasks[index],context),
            separatorBuilder: (context,index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            itemCount: AppCubit.get(context).newTasks.length,
          );
        }
    );
  }

}

