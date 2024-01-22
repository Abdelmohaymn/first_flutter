

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/cubit/social_cubit.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/models/social_models/user_model.dart';
import 'package:first_flutter/modules/social_app/chat_details_screen/chat_details_screen.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialChatsScreen extends StatelessWidget{
  const SocialChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, SocialStates state) {  },
      builder: (BuildContext context, SocialStates state) {
        var cubit = SocialCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConditionalBuilder(
            condition: cubit.users.isNotEmpty,
            builder: (context) => ListView.separated(
              itemBuilder: (BuildContext context, int index) => buildUserItem(cubit.users[index],context),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 15,),
              itemCount: cubit.users.length,
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator())
          ),
        );
      },
    );
  }

  Widget buildUserItem(UserModel user,BuildContext context) => InkWell(
    onTap: (){
      NavigateTo(context, ChatDetailsScreen(user: user));
    },
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(user.image!),
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 5,),
            const Text(
              'Hi, man how r u doing?',
              maxLines: 1,
              style: TextStyle(color: Colors.grey,height: 2,fontSize: 11),
            )
          ],
        ),
      ],
    ),
  );

}