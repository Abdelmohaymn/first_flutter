
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/models/social_models/message_model.dart';
import 'package:first_flutter/models/social_models/user_model.dart';
import 'package:first_flutter/modules/social_app/chat_details_screen/cubit/chat_cubit.dart';
import 'package:first_flutter/modules/social_app/chat_details_screen/cubit/chat_states.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class ChatDetailsScreen extends StatelessWidget{
  
  final UserModel user;
  ChatDetailsScreen({super.key, required this.user});

  var textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialChatCubit()..getMessages(receiverId: user.uId!),
      child: BlocConsumer<SocialChatCubit,SocialChatStates>(
        listener: (BuildContext context, SocialChatStates state) {  },
        builder: (BuildContext context, SocialChatStates state) {
          var cubit = SocialChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: Row(
                children: [
                  const SizedBox(width: 3,),
                  TouchRippleEffect(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(20),
                    rippleColor: Colors.grey[600],
                    child: Center(
                      widthFactor: 1.1,
                      heightFactor: 1.2,
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back),
                          const SizedBox(width: 3,),
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(user.image!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: SizedBox(
                width: 120,
                child: Text(
                  user.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              titleSpacing: 0,
              leadingWidth: 78,
              elevation: 10,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConditionalBuilder(
                  condition: cubit.isEmpty!=null,
                  builder: (context) => Column(
                    //alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      if(cubit.messages.isNotEmpty)
                        Expanded(
                          child: ListView.separated(
                            reverse:true ,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if(cubit.messages[index].senderId==uId){
                                return buildSenderItem(cubit.messages[index],context);
                              }
                              return buildReceiverItem(cubit.messages[index],context);
                            },
                            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8,),
                            itemCount: cubit.messages.length,
                          ),
                        ),
                        const SizedBox(height: 10,),
                      if(cubit.messages.isEmpty)
                        const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 0.2*MediaQuery.of(context).size.height
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.newline,
                                        maxLines: null,
                                        controller: textController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Type a message...',
                                        ),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal
                                        ),
                                        onFieldSubmitted: (value){
                                          if(value.isNotEmpty){
                                            cubit.sendMessage(receiverId: user.uId!, textMessage: value);
                                            textController.text='';
                                          }
                                        },
                                        onTapOutside: (value){
                                          FocusScope.of(context).requestFocus(FocusNode());
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    TouchRippleEffect(
                                      width: 30,
                                      height: 30,
                                      rippleColor: Colors.white,
                                      onTap: (){
                                        cubit.getImage(receiverId: user.uId!);
                                      },
                                      child: const Icon(
                                        IconBroken.Camera,
                                        color: defaultColor,
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          TouchRippleEffect(
                              onTap: (){
                                cubit.sendMessage(receiverId: user.uId!, textMessage: textController.text);
                                textController.text='';
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              rippleColor: Colors.white,
                              backgroundColor: defaultColor,
                              width: 50,
                              height: 50,
                              borderRadius: BorderRadius.circular(25),
                              child: Positioned(
                                right: 3,
                                bottom: 1,
                                top: 3,
                                left: 1,
                                child: Icon(
                                  IconBroken.Send,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                              )
                          )
                        ],
                      )
                    ],
                  ),
                  fallback: (context) => const Center(child: CircularProgressIndicator(),)
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildReceiverItem(MessageModel message,context)=>Align(
    alignment: AlignmentDirectional.topStart,
    child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        constraints: BoxConstraints(
            maxWidth: 3/4 * (MediaQuery.of(context).size.width)
        ),
        decoration: BoxDecoration(
            color: HexColor('#d3d3d3'),
            borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(5),
                topStart: Radius.circular(5),
                bottomEnd: Radius.circular(5)
            )
        ),
        child: message.textMessage!=null? Text(message.textMessage!)
                : AspectRatio(
                    aspectRatio: 1.6,
                    child: BlurHash(
                      hash: message.image!.hash,
                      image: message.image!.downloadUrl,
                    ),
                  ),

    ),
  );

  Widget buildSenderItem(MessageModel message,context)=>Align(
    alignment: AlignmentDirectional.topEnd,
    child: Container(
        constraints: BoxConstraints(
          maxWidth: 3/4 * (MediaQuery.of(context).size.width)
        ),
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: const BoxDecoration(
            color: defaultColor,
            borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(5),
                topStart: Radius.circular(5),
                bottomStart: Radius.circular(5)
            )
        ),
      child: message.textMessage!=null? Text(message.textMessage!)
          : AspectRatio(
              aspectRatio: 1.6,
              child: BlurHash(
                hash: message.image!.hash,
                image: message.image!.downloadUrl,
              ),
            ),
    ),
  );
  
}