

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/cubit/cubit.dart';
import 'package:first_flutter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class HomeLayout extends StatelessWidget{

  const HomeLayout({super.key});


  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static GlobalKey<FormState> formKEy = GlobalKey<FormState>();
  static TextEditingController titleController = TextEditingController();
  static TextEditingController timeController = TextEditingController();
  static TextEditingController dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(BuildContext context, AppStates state){
          if(state is InsertDatabaseState){
            Navigator.pop(context);
          }
        } ,
        builder: (BuildContext context, AppStates state){

          AppCubit cubit  = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKEy.currentState!.validate()){
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    cubit.changeBottomSheetState(value: false);
                  }
                }else{
                  cubit.changeBottomSheetState(value: true);
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child: Form(
                        key: formKEy,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DefaultTextField(
                                controller: titleController,
                                type: TextInputType.text,
                                label: 'Task title',
                                prefix: Icons.title,
                                validate: (value){
                                  if(value==null || value.isEmpty)return 'Title must not be empty';
                                  return null;
                                }
                            ),
                            const SizedBox(height: 15,),
                            DefaultTextField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                label: 'Task time',
                                prefix: Icons.watch_later_outlined,
                                validate: (value){
                                  if(value==null || value.isEmpty)return 'Time must not be empty';
                                  return null;
                                },
                                onTap: (){
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value) =>
                                  timeController.text = value!.format(context).toString()
                                  );
                                }
                            ),
                            const SizedBox(height: 15,),
                            DefaultTextField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                label: 'Task date',
                                prefix: Icons.calendar_today,
                                validate: (value){
                                  if(value==null || value.isEmpty)return 'Date must not be empty';
                                  return null;
                                },
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2024-01-01')
                                  ).then((value) =>
                                  dateController.text = DateFormat.yMMMd().format(value!)
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(value: false);
                  });
                }
                /*setState(() {

              });*/
              },
              child: Icon(
                  cubit.isBottomSheetShown?Icons.add:Icons.edit
              ),
            ),
            body: ConditionalBuilder(
              condition: state is !GetDatabaseLoadingState,
              builder:(context) => cubit.screens[cubit.currentIndex],
              fallback:(context) => const Center(child: CircularProgressIndicator(),) ,
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index){
                  cubit.changeBottomIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'Tasks'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: 'Done'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archive'
                  ),
                ]
            ),
          );
        }
      ),
    );
  }


}


