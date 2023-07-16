import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMasseges extends StatefulWidget {
  const NewMasseges({Key? key}) : super(key: key);

  @override
  State<NewMasseges> createState() => _NewMassegesState();
}

class _NewMassegesState extends State<NewMasseges> {
 final TextEditingController _MesssageController = TextEditingController();

 @override
  void dispose() {
   _MesssageController.dispose();
    super.dispose();
  }

  Future<void> _SubmitMessage() async {
   final enteredMessage = _MesssageController.text;
   if(enteredMessage.trim().isEmpty){
     return;
   }
   FocusScope.of(context).unfocus();
   final user = FirebaseAuth.instance.currentUser!;
  final userData =  await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
   FirebaseFirestore.instance.collection('chat').add({
     'text' : _MesssageController.text,
     'CreatedAt' : Timestamp.now(),
     'user' : user.uid,
     'username': userData.data()!['username'],
     'userImage':userData.data()!['imgUrl'],
   });



   _MesssageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left:15 , right: 1 , bottom: 14),
      child:  Row(children: [
        Expanded(
          child: TextField(
            controller: _MesssageController,
            decoration: const  InputDecoration(
              label:  Text('send message'),),
            enableSuggestions: false,
              autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        IconButton(onPressed:_SubmitMessage,color:Theme.of(context).primaryColor , icon: Icon(Icons.send)),

      ],) ,
    );
  }
}
