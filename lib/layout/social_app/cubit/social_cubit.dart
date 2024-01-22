
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/models/social_models/comment_model.dart';
import 'package:first_flutter/models/social_models/post_model.dart';
import 'package:first_flutter/models/social_models/user_model.dart';
import 'package:first_flutter/modules/social_app/chats/chats_screen.dart';
import 'package:first_flutter/modules/social_app/home/home_screen.dart';
import 'package:first_flutter/modules/social_app/login/social_login.dart';
import 'package:first_flutter/modules/social_app/settings/settings_screen.dart';
import 'package:first_flutter/modules/social_app/users/users_screen.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class SocialCubit extends Cubit<SocialStates>{

  SocialCubit() : super(SocialInitialState());


  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  int currentIndex = 0;
  Color iconSendCommentColor = Colors.black;
  List<Widget> screens = [
    SocialHomeScreen(),
    const SocialChatsScreen(),
    SocialUsersScreen(),
    const SocialSettingsScreen(),
  ];
  List<BottomNavigationBarItem> items = [
    defaultBottomNavItem('Home', IconBroken.Home),
    defaultBottomNavItem('Chats', IconBroken.Chat),
    defaultBottomNavItem('Post', IconBroken.Upload),
    defaultBottomNavItem('Users', IconBroken.Location),
    defaultBottomNavItem('Settings', IconBroken.Setting),
  ];
  List<String> titles = ['Home','Chats','Users','Settings'];

  File? profileImage,coverImage,postImage,image;
  ImagePicker imagePicker = ImagePicker();

  List<PostModel> posts = [];
  List<bool> likedPosts = [];
  List<UserModel> users = [];
  List<List<CommentModel>> comments = [];

  var postsCollection = FirebaseFirestore.instance.collection('posts');
  var likesCollection = FirebaseFirestore.instance.collection('likes');

  Future<void> getImage({required String type}) async{
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image = File(pickedImage.path);
      if(type=='profile'){
        profileImage = image;
      }else if(type == 'postImage'){
        postImage = image;
      }
      else{
        coverImage = image;
      }
      emit(SocialPickImageSuccessState());
    }else{
      emit(SocialPickImageErrorState());
    }
  }

  void changeIconCommentColor(String text){
    if(text.isNotEmpty){
      iconSendCommentColor = defaultColor;
    }else{
      iconSendCommentColor = Colors.black;
    }
    emit(SocialChangeIconCommentColorState());
  }

  void changeBottomNavIndex(int index){
    currentIndex = index;
    if(index == 2){
      emit(SocialAddPostState());
    }else{
      emit(SocialChangeBottomNavIndexState());
    }
  }

  void getUserData(){
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get()
        .then((value) {
          userModel = UserModel.fromJson(value.data()!);
          emit(SocialGetUserSuccessState(userModel!));
    }).catchError((error){
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  Widget? defaultScreen(){
    if(currentIndex == 2) {
      return null;
    } else{
      if(currentIndex>2)return screens[currentIndex-1];
      return screens[currentIndex];
    }
  }
  String getTitle(){
    if(currentIndex>2) {
      return titles[currentIndex-1];
    } else if(currentIndex<2) {
      return titles[currentIndex];
    }
    return '';
  }

  ImageProvider defaultProfImage(){
    if(profileImage==null){
      return NetworkImage(userModel!.image??'https://i.pinimg.com/564x/09/e4/30/09e430cffab1d633f178e3228e9f9b81.jpg');
    }
    return FileImage(profileImage!);
  }

  ImageProvider defaultCoverImage(){
    if(coverImage==null){
      return NetworkImage(userModel!.cover??'https://venngage-wordpress.s3.amazonaws.com/uploads/2018/04/arrows-in-circles.png');
    }
    return FileImage(coverImage!);
  }

  Future<String?> uploadImageToStorage(File curImage) async{
    String? imageUrl;
    try{
      var value = await FirebaseStorage.instance.ref()
          .child('users/${Uri.file(curImage.path).pathSegments.last}')
          .putFile(curImage);
      imageUrl = await value.ref.getDownloadURL();
    }catch(error){}
    return imageUrl;
  }

  Future<void> updateUserData({
    required String name,
    required String bio,
    required BuildContext context,
  }) async {
    if(coverImage==null&&profileImage==null&&name==userModel!.name&&bio==userModel!.bio){
      onBackFromEditScreen(context);
      return;
    }
    if(!await checkInternet()){
      emit(SocialUpdateUserDataErrorState('no internet connection'));
      onBackFromEditScreen(context);
      return;
    }
    emit(SocialUpdateUserDataLoadingState());
    String? coverUrl,profUrl;
    if(coverImage!=null)coverUrl= await uploadImageToStorage(coverImage!);
    if(profileImage!=null)profUrl= await uploadImageToStorage(profileImage!);
    userModel!.name=name;
    userModel!.bio=bio;
    if(coverUrl!=null)userModel!.cover=coverUrl;
    if(profUrl!=null)userModel!.image=profUrl;
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId)
    .set(userModel!.toJson()).then((value) {
        onBackFromEditScreen(context);
        emit(SocialUpdateUserDataSuccessState());
    }).catchError((error){
        onBackFromEditScreen(context);
        emit(SocialUpdateUserDataErrorState(error.toString()));
    });
  }

  Future<void> createNewPost({
    required String text,
    required BuildContext context,
  }) async {

    if(!await checkInternet()){
      emit(SocialPostErrorState('no internet connection'));
      onBackFromAddPostScreen(context);
      return;
    }
    emit(SocialPostLoadingState());
    String? postImageUrl;
    if(postImage!=null)postImageUrl= await uploadImageToStorage(postImage!);
    PostModel postModel = PostModel(uId: userModel!.uId!, dateTime: DateTime.now().toString());
    postModel.text = text;
    if(postImageUrl!=null)postModel.postImage = postImageUrl;

    postsCollection.add(postModel.toJson()).then((value) {
      //print('CREATE NEW POST : ${value.id}');
      value.update({'pId':value.id});
      getPosts();
      onBackFromAddPostScreen(context);
      emit(SocialPostSuccessState());
    }).catchError((error){
      onBackFromEditScreen(context);
      emit(SocialPostErrorState(error.toString()));
    });
  }

  void onBackFromEditScreen(BuildContext context){
    coverImage=null;profileImage=null;
    Navigator.pop(context);
  }

  void onBackFromAddPostScreen(BuildContext context){
    changeBottomNavIndex(0);
    deletePostImage();
    Navigator.pop(context);
  }


  void deletePostImage(){
    postImage=null;
    emit(SocialDeletePostImageState());
  }
////////////////////////////////////
  void getPosts() {
    emit(SocialGetPostsLoadingState());

    postsCollection.orderBy('dateTime',descending: true).get().then((value) async{
      posts.clear(); likedPosts.clear();comments.clear();
      posts.addAll(value.docs.map((e) => PostModel.fromJson(e.data())));
      List<Future<void>> futures = [];
      for(int i=0; i<posts.length; i++){
        likedPosts.add(false);comments.add([]);
        PostModel post = posts[i];
        futures.add(FirebaseFirestore.instance.collection('users').doc(post.uId).get().then((value){
          post.user = UserModel.fromJson(value.data()!);
        }));
        futures.add(likesCollection.where('pId', isEqualTo: post.pId).get().then((value){
          post.likesCount = value.docs.length;
        }));
        futures.add(likesCollection.where('pId', isEqualTo: post.pId).where('uId', isEqualTo: uId)
            .get().then((value){
          if(value.docs.isNotEmpty){
            likedPosts[i] = true;
          }
        }));
      }
      await Future.wait(futures);
      emit(SocialGetPostsSuccessState());
    }).catchError((error){
      emit(SocialGetPostsErrorState());
    });
  }

  bool makeSurePostsIsOk(){
    if(posts.isEmpty)return false;
    for (var element in posts) {
      if(element.user==null){
        return false;
      }
    }
    return true;
  }

  String formatPostDate(String date){
    var difference = DateTime.now().difference(DateTime.parse(date));
    if(difference.inDays > 0){
      if(difference.inDays<7){
        return '${difference.inDays}days ago';
      }
      return DateFormat('dd-MM-yyyy  hh:mm a').format(DateTime.parse(date));
    }else if(difference.inHours>0){
      return '${difference.inHours}hours ago';
    }else if(difference.inMinutes>0){
      return '${difference.inMinutes}minutes ago';
    }else{
      return 'now';
    }
  }

  void likeAPost(int index)
  {
    String pId = posts[index].pId!;

    likedPosts[index]=!likedPosts[index];
    emit(SocialChangeLikePostState());

    likesCollection.where('uId', isEqualTo: uId).where('pId', isEqualTo: pId).get()
    .then((value){
      if(value.docs.isNotEmpty){
        String likeId = value.docs[0].id;
        likesCollection.doc(likeId).delete().then((value){
          getPostCount(index);
        }).catchError((error){
          likedPosts[index]=!likedPosts[index];
          emit(SocialChangeLikePostState());
        });
      }else{
        likesCollection.add({'uId':uId,'pId':pId}).then((value){
          getPostCount(index);
        }).catchError((error){
          likedPosts[index]=!likedPosts[index];
          emit(SocialChangeLikePostState());
        });
      }
    }).catchError((error){
      likedPosts[index]=!likedPosts[index];
      emit(SocialChangeLikePostState());
    });

  }

  getPostCount(int index){
    likesCollection.where('pId', isEqualTo: posts[index].pId).get().then((value){
      posts[index].likesCount = value.docs.length;
      emit(SocialLikePostSuccessState());
    });
  }

  void getUsers() {
    emit(SocialGetUsersLoadingState());

    FirebaseFirestore.instance.collection('users').get().then((value) async{
      users.clear();
      users.addAll(value.docs.map((e) => UserModel.fromJson(e.data())));
      emit(SocialGetUsersSuccessState());
    }).catchError((error){
      print('Erorrrrrrrrrrrrrrrrrr ${error.toString()}');
      emit(SocialGetUsersErrorState());
    });
  }

  void getComments(int index) {
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance.collection('posts').doc(posts[index].pId!)
        .collection('comments').orderBy('dateTime').snapshots().listen((event) {
      comments[index]=[];
      comments[index].addAll(event.docs.map((e) => CommentModel.fromJson(e.data())));
      List<Future<void>>futures=[];
      for(int i=0;i<comments[index].length;i++){
        futures.add(FirebaseFirestore.instance.collection('users')
            .doc(comments[index][i].uId).get().then((value){
              comments[index][i].user = UserModel.fromJson(value.data()!);
        }));
      }
      Future.wait(futures).then((value){
        emit(SocialGetCommentsSuccessState());
      });
    });
  }

  void addAComment(int index,String text)
  {
    String pId = posts[index].pId!;
    CommentModel commentModel = CommentModel(uId: uId!, pId: pId,text: text);
    FirebaseFirestore.instance.collection('posts').doc(pId)
        .collection('comments').add(commentModel.toJson()).then((value) => {
          getComments(index),
          emit(SocialAddCommentSuccessState())
    }).catchError((error){
      emit(SocialCommentsErrorState());
    });

  }

  Future checkInternet() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  void logout(BuildContext context){
    emit(SocialLogoutLoadingState());
    SharedPrefHelper.removeData(key: 'uId').then((value){
      if(value){
        uId=null;
        NavigateWithoutBack(context, SocialLoginScreen());
        emit(SocialLogoutSuccessState());
      }
    });
  }
}