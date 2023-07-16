import 'package:chatappwithfirebase/Widget/BubbleMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMasseges extends StatelessWidget {
  const ChatMasseges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authinicatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(stream:FirebaseFirestore.instance.collection('chat').orderBy(
      'CreatedAt',
      descending: true,
    ).snapshots()
        ,builder:(ctx , chatSnapshots){
      if(chatSnapshots.connectionState == ConnectionState.waiting){
        return Center(child: const CircularProgressIndicator());
      }
      if(!chatSnapshots.hasData|| chatSnapshots.data!.docs.isEmpty){
        return const Center(child: Text('no massege found'),);
      }
      if(chatSnapshots.hasError){
        return const Center(child : Text( 'something went wrong..'),);
          }
      final loadedChat = chatSnapshots.data!.docs;
      return ListView.builder(padding: const EdgeInsets.only(bottom: 10,left: 20) ,reverse : true , itemCount: loadedChat.length ,
          itemBuilder: ( context, index) {
            final chatMessage = loadedChat[index].data();
            final nextMessage = index +1 <loadedChat.length
                ? loadedChat[index +1].data() : null;
            final currentMessageUsername = chatMessage['user'];
            final nextMessageUsername = nextMessage!= null ? nextMessage['user'] : null;
           final nextUserIsSame = nextMessageUsername == currentMessageUsername;
           if(nextUserIsSame){
             return MessageBubble.next(message: chatMessage['text'], isMe:authinicatedUser.uid ==currentMessageUsername);
           }
           else{
             return MessageBubble.first(userImage:chatMessage['userImage'] , username: chatMessage['username'], message: chatMessage['text'], isMe: authinicatedUser.uid ==currentMessageUsername);
           }



          });



    });


  }
}
