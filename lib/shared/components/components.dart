
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/modules/news_app/web_view/web_view.dart';
import 'package:first_flutter/shared/cubit/cubit.dart';
import 'package:first_flutter/shared/news_cubit/news_cubit.dart';
import 'package:first_flutter/shared/news_cubit/news_states.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

Widget DefaultTextField({
    required TextEditingController controller,
    required TextInputType type,
    required String label,
    required IconData prefix,
    String? Function(String?)? validate,
    Function(String)? onSubmit,
    Function(String)? onChange,
    Function()? onTap,
    Function()? suffixPressed,
    IconData? suffix,
    Color iconsColor = Colors.grey,
    bool isPassword = false,
}) => TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted:onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          //color: iconsColor,
          fontSize: 13
        ),
        prefixIcon: Icon(
          prefix,
          //color:iconsColor ,
        ),
        suffixIcon: suffix != null?IconButton(
            onPressed: suffixPressed,
            icon: Icon(
              suffix,
              //color: iconsColor,
            ),
        ):null,
        border: const OutlineInputBorder(),
      ),
);

Widget defaultButton({
  required Function()? onClick,
  required String text,
  bool isUpper = true,
  double width = double.infinity,
  double radius = 10.0,
  color = defaultColor
}) => TouchRippleEffect(
  width: width,
  height: 40,
  borderRadius: BorderRadius.circular(radius),
  rippleColor: Colors.white,
  onTap: onClick,
  child: Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: Text(
      isUpper? text.toUpperCase():text,
      style: const TextStyle(
        color: Colors.white
      ),
    )
  ),
);

Widget defaultTextButton({
  required Function()? onClick,
  required String text
}) => TextButton(
  onPressed: onClick,
  child: Text(
    text.toUpperCase()
  ),
);


Widget TaskItem(Map task,context) =>
    Dismissible(
      key: Key(task['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                  '${task['time']}'
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                children: [
                  Text(
                      '${task['title']}'
                  ),
                  Text(
                      '${task['date']}'
                  )
                ],
              ),
            ),
            const SizedBox(width: 10,),
            IconButton(
                onPressed: (){
                  AppCubit.get(context).updateDatabaseState(status: 'done', id: task['id']);
                },
                icon: const Icon(Icons.check_box,color: Colors.green,)
            ),
            IconButton(
                onPressed: (){
                  AppCubit.get(context).updateDatabaseState(status: 'archive', id: task['id']);
                },
                icon: const Icon(Icons.archive,color: Colors.black45)
            ),
          ],
        ),
      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteFromDatabase(id: task['id']);
      } ,
    );

Widget ArticleItem(article,context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: InkWell(
    onTap: (){
      NavigateTo(context, WebViewScreen(article['url']));
    },
    child: Row(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover
              )
          ),
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: SizedBox(
            height: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${article['title']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${article['publishedAt']}',
                  style: const TextStyle(
                      color: Colors.grey
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  ),
);

Widget ListDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget NewsScreenItem(state , articles) => ConditionalBuilder(
    condition: state is !NewsLoadingDataState,
    builder: (context) => ListView.separated(
      itemBuilder: (context,index) => ArticleItem(articles[index],context),
      separatorBuilder: (context,index) => ListDivider(),
      itemCount: articles.length,
      physics: const BouncingScrollPhysics(),
    ),
    fallback: (context)=> const Center(child: CircularProgressIndicator(),)
);

Widget NewsMainConsumer() => BlocConsumer<NewsCubit,NewsStates>(
    listener: (context , state) {  },
    builder: (context , state) {
      return NewsScreenItem(state, NewsCubit.get(context).articles);
    }
);

void NavigateTo(context,Widget screen){
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen)
  );
}

void NavigateWithoutBack(context,Widget screen){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route)=>false
  );
}

void defaultToast({
  required String message,
  required ToastStates state
}) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 14.0
      );

enum ToastStates{SUCCESS,ERROR,WARNING,}

Color chooseToastColor(ToastStates state){
  Color color;
  switch (state){
    case ToastStates.SUCCESS :
      color = Colors.green;
      break;
    case ToastStates.ERROR :
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.red;
      break;
  }
  return color;
}

BottomNavigationBarItem defaultBottomNavItem(String text,IconData icon) =>
    BottomNavigationBarItem(
        icon: Icon(icon),
        label: text
    );

AppBar defaultAppBar({
  required BuildContext context,
  required String title,
  required void Function()  onBack,
  List<Widget>? actions
}) => AppBar(
  title: Text(title),
  leading: IconButton(
    onPressed: onBack,
    icon: const Icon(IconBroken.Arrow___Left_2),
  ),
  actions: actions,
  titleSpacing: 0,

);