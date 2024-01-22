
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/cubit/social_cubit.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/models/social_models/comment_model.dart';
import 'package:first_flutter/models/social_models/post_model.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class SocialHomeScreen extends StatelessWidget{
  SocialHomeScreen({super.key});

  TextEditingController commetnsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, SocialStates state) {  },
      builder: (BuildContext context, SocialStates state) {
        var cubit = SocialCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async{
            cubit.getPosts();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                /*Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(8),
                  child: const Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                          image: NetworkImage('https://katiecouric.com/wp-content/uploads/2022/09/men-and-women-communication-1.png?crop=1410:870,smart&width=720&disable=upscale&format=webp&quality=90&dpr=1.25'),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Communicate with your friends'),
                        )
                      ]
                  ),
                ),*/
                ConditionalBuilder(
                  condition: (cubit.makeSurePostsIsOk()),
                  builder: (context)=> ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index) => buildPostItem(cubit.posts[index],cubit,index,context,state),
                      separatorBuilder:(context,index) => const SizedBox(height: 8,),
                      itemCount: cubit.posts.length
                  ),
                  fallback: (context) => const Center(child: CircularProgressIndicator())
                ),
                const SizedBox(height: 5,)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPostItem(PostModel post,SocialCubit cubit,int index,context,state) => Card(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 5,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(post.user!.image??defaultProfileImage),
              ),
              const SizedBox(width: 10,),
               Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.user!.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5,),
                          const Icon(Icons.check_circle,color: Colors.blue,size: 16,)
                        ],
                      ),
                      Text(
                        cubit.formatPostDate(post.dateTime),
                        maxLines: 1,
                        style: const TextStyle(color: Colors.grey,height: 2,fontSize: 11),
                      )
                    ],
                  )
              ),
              const Spacer(),
              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.more_horiz,color: Colors.black,size: 16,)
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Text(
            post.text??"",
            textAlign: TextAlign.start,
          ),
          /*Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            child: Wrap(
              children: [
                Container(
                  child: MaterialButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    minWidth: 1,
                    child: const Text(
                      '#Aboanlaga',
                      style: TextStyle(
                          color: defaultColor,
                          fontSize: 12
                      ),
                    ),
                  ),
                  height: 20,
                  padding: const EdgeInsetsDirectional.only(end: 8),
                ),
                Container(
                  height: 20,
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: MaterialButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    minWidth: 1,
                    child: const Text(
                      '#cyber_security',
                      style: TextStyle(
                          color: defaultColor,
                          fontSize: 12
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: MaterialButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    minWidth: 1,
                    child: const Text(
                      '#Hacking',
                      style: TextStyle(
                          color: defaultColor,
                          fontSize: 12
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: MaterialButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    minWidth: 1,
                    child: Text(
                      '#عمده_فين_الِApi؟',
                      //textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          color: defaultColor,
                          fontSize: 12
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          if(post.postImage!=null)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post.postImage!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Expanded(
                  child:InkWell(
                    onTap: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(IconBroken.Heart,color: Colors.red,size: 16,),
                          const SizedBox(width: 5,),
                          Text(
                            cubit.posts[index].likesCount.toString(),
                            style: const TextStyle(color: Colors.black,fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              Expanded(
                  child:InkWell(
                    onTap: (){},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(IconBroken.More_Circle,color: Colors.red,size: 16,),
                          SizedBox(width: 5,),
                          Text('comments',style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(post.user!.image??defaultProfileImage),
                      ),
                      const SizedBox(width: 10,),
                      const Text(
                        'write a comment...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: (){
                    showComments(context,commetnsController,cubit,index,state);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey[300],
                ),
              ),
              TouchRippleEffect(
                width: 50,
                height: 30,
                rippleColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(5),
                onTap: (){
                  cubit.likeAPost(index);
                },
                child: Center(
                  child: Row(
                    children: [
                      Icon(
                        cubit.likedPosts[index]?CupertinoIcons.heart_fill:CupertinoIcons.heart,
                        color: cubit.likedPosts[index]?Colors.red:Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 5,),
                      const Text('Like',style: TextStyle(color: Colors.black,fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget buildCommentItem(
    CommentModel comment,
    SocialCubit cubit,
    )=>  Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(comment.user.image!),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Container(
            //color: Colors.grey[300],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
                color: Colors.grey[300]
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.user.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(comment.text!),
                  Text(
                    cubit.formatPostDate(comment.dateTime),
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey,height: 2,fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
  );

  void showComments(
      BuildContext context,
      TextEditingController controller,
      SocialCubit cubit,
      int postIndex,
      SocialStates state
  ){
    cubit.getComments(postIndex);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
          return ConditionalBuilder(
              condition: state is !SocialGetCommentsLoadingState,
              builder: (context)=>Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height-30
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      //if(cubit.messages.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index)=>buildCommentItem(cubit.comments[postIndex][index],cubit),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8,),
                          itemCount: cubit.comments[postIndex].length,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      //if(cubit.messages.isEmpty)
                      //const Spacer(),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 0.2*MediaQuery.of(context).size.height,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Scrollbar(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                              controller: controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write a comment...',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send,color: cubit.iconSendCommentColor,),
                                    onPressed: (){
                                      if(controller.text.isNotEmpty){
                                        cubit.addAComment(postIndex, controller.text);
                                        controller.text='';
                                      }
                                    },
                                  )
                              ),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal
                              ),
                              onTapOutside: (value){
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              onChanged: (value){
                                if(value.isNotEmpty){
                                  cubit.changeIconCommentColor(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              fallback: (context)=>const Center(child: CircularProgressIndicator(),)
          );
        },
    );
  }

}