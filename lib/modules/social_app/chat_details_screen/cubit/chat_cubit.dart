
import 'dart:io';

import 'package:blurhash/blurhash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter/models/social_models/image_model.dart';
import 'package:first_flutter/models/social_models/message_model.dart';
import 'package:first_flutter/modules/social_app/chat_details_screen/cubit/chat_states.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SocialChatCubit extends Cubit<SocialChatStates>{

  SocialChatCubit() : super(SocialChatInitialState());

  static SocialChatCubit get(context) => BlocProvider.of(context);

  List<MessageModel> messages=[];
  bool? isEmpty;
  File? image;
  ImagePicker imagePicker = ImagePicker();

  void sendMessage({
    required String receiverId,
    String? textMessage,
    ImageModel? imageModel,
}){
    emit(SendMessageLoadingState());

    MessageModel messageModel = MessageModel(
        senderId: uId!,
        receiverId: receiverId,
        textMessage: textMessage,
        dateTime: DateTime.now().toString()
    );
    if(imageModel!=null){
      messageModel.image = imageModel;
    }

    messageSenderReceiver(uId!,receiverId,messageModel);
    if(receiverId!=uId){
      messageSenderReceiver(receiverId,uId!,messageModel);
    }

  }

  void messageSenderReceiver(String first,String second,MessageModel message){
    FirebaseFirestore.instance
        .collection('users')
        .doc(first)
        .collection('chats')
        .doc(second)
        .collection('messages')
        .add(message.toJson())
        .then((value) => {
      emit(SendMessageSuccessState())
    })
        .catchError((error){
      print('Errrrrrrrrrrrrrror ${error.toString()}');
      emit(SendMessageErrorState());
    });
  }

  void getMessages({
    required String receiverId
}){
    FirebaseFirestore.instance.collection('users')
        .doc(uId).collection('chats').doc(receiverId).collection('messages')
        .orderBy('dateTime',descending: true)
        .snapshots().listen((event) {
          messages=[];
          messages.addAll(event.docs.map((e) => MessageModel.fromJson(e.data())));
          isEmpty=messages.isEmpty;
          emit(GetMessagesSuccessState());
    });
  }

  Future<void> getImage({required String receiverId}) async{
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image = File(pickedImage.path);
      String? downloadUrl = await uploadImageToStorage(image!);
      if(downloadUrl!=null){
        var bytes = await image!.readAsBytes();
        Uint8List pixels = bytes.buffer.asUint8List();
        BlurHash.encode(pixels, 4, 3).then((blurHash){
          ImageModel imageModel = ImageModel(
              hash: blurHash,
              downloadUrl: downloadUrl
          );
          sendMessage(receiverId: receiverId,imageModel: imageModel);
        });
      }
      emit(ChatPickImageSuccessState());
    }else{
      emit(ChatPickImageErrorState());
    }
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

}