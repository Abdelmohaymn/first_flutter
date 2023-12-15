
import 'package:first_flutter/modules/todo_app/archive/arcive_screen.dart';
import 'package:first_flutter/modules/todo_app/done/done_screen.dart';
import 'package:first_flutter/modules/todo_app/tasks/tasks_screen.dart';
import 'package:first_flutter/shared/cubit/states.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit():super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];
  List<String> titles = ['Tasks','Done','Archive'];
  bool isBottomSheetShown = false;

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];


  void changeBottomIndex(int index){
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void createDatabase() {
    print('db created');
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (db, version){
          db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error){
            print('Error happened when creating table ${error.toString()}');
          });
        },
        onOpen:(db) {
          getDataFromDatabase(db);
          print('db opened');
        }
    ).then((value){
      database = value;
      emit(CreateDatabaseState());
    });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {

     await database.transaction((txn) =>
         txn.rawInsert(
             'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "new")')).then((value){
       emit(InsertDatabaseState());
       print('$value inserted successfully');
       getDataFromDatabase(database);
     }).catchError((error){
       print('Error: $error');
     });

  }

  void getDataFromDatabase(Database db) {
    emit(GetDatabaseLoadingState());
     db.rawQuery('SELECT * FROM tasks').then((value){
       newTasks.clear();
       doneTasks.clear();
       archiveTasks.clear();
       for (var element in value) {
         if(element['status']=='new'){
           newTasks.add(element);
         }else if(element['status']=='done'){
           doneTasks.add(element);
         }else{
           archiveTasks.add(element);
         }
       }
       emit(GetDatabaseState());
     });
  }

  void changeBottomSheetState({required bool value}){
    isBottomSheetShown = value;
    emit(ChangeBottomSheetState());
  }

  void updateDatabaseState({
    required String status,
    required int id
}){
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',[status,id])
        .then((value){
      emit(UpdateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void deleteFromDatabase({
    required int id
  }){
    database.rawDelete('DELETE FROM tasks WHERE id = ?',[id])
        .then((value){
      emit(DeleteFromDatabaseState());
      getDataFromDatabase(database);
    });
  }

  bool isDark = false;

  void changeAppThemeMode(){
    isDark = !isDark;
    SharedPrefHelper.saveData(key: 'isDark', value: isDark).then((value) => {
      emit(ChangeAppThemeModeState())
    });
  }


}