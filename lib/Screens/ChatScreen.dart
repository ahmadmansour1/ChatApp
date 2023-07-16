import 'package:chatappwithfirebase/Widget/ChatMessage.dart';
import 'package:chatappwithfirebase/Widget/LogoutButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widget/NewMessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setUpNotifications() async {
    final fcm = FirebaseMessaging.instance;
   await  fcm.requestPermission();
    final token = await fcm.getToken();

    print(token);

  }
  @override
  void initState() {
    super.initState();
    setUpNotifications();

  }
  //change this
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chat screen'), actions: [
        Logout(),
      ], ),
      body: const Column(
        children: [
          Expanded(child: ChatMasseges()),
          NewMasseges(),


        ],
      )
    );
  }
}

