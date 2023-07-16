import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widget/user_image_picker.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}
//controllers

class _LoginState extends State<Login> {
  bool _isLogin = false ;
  bool  _isAuthenicated  = false ;
  final  TextEditingController _EmailController = TextEditingController();
  final  TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _UsernameController = TextEditingController();

   File ? _SelecteImage ;
  String? _ValidateEmail(String ?  email){
    if(  email == null ||email.isEmpty   || !email.contains('@')){
      return 'your email is invalid  ';
    }
    else {
      return null;
    }


  }

  String? _Validatepassword(String ?  password){
    if(  password == null ||password.trim().isEmpty   || password.length < 6 ){
      return 'use a stronger password ';

    }
    else {
      return null;
    }
  }
  String? _ValidateUserName(String ?  username){
    if(  username == null ||username.isEmpty   ||username.trim().length<4 ){
      return 'enter at least a 4 characters username.   ';
    }
    else {
      return null;
    }


  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final auth = FirebaseAuth.instance;
    void Login(email , password ) async {
      final isValid = _formKey.currentState!.validate();

      if(!isValid || !_isLogin && _SelecteImage == null ){
        return;
      }
      setState(() {
        _isAuthenicated == true;
      });
      if(_isLogin) {
       try{

        final userCredintials = await auth.signInWithEmailAndPassword(email: _EmailController.text, password: _PasswordController.text);
         print(userCredintials);


       } catch(e){
         print(e);
       }
      }
      else {
       try{
         setState(() {
           _isAuthenicated = true;
         });
         final userCredintials = await auth.createUserWithEmailAndPassword(email: _EmailController.text, password: _PasswordController.text);
         final storageRef = FirebaseStorage.instance.ref().child('user_image')
             .child('${userCredintials.user!.uid}.jpg');
         await storageRef.putFile(_SelecteImage!);

        final imgUrl = await storageRef.getDownloadURL();

         await FirebaseFirestore.instance
             .collection('users')
             .doc(userCredintials.user!.uid)
             .set({
           'username' : _UsernameController.text,
           'email' : _EmailController.text,
           'imgUrl': imgUrl,
         });
       } on FirebaseAuthException catch(e) {
         if(e.code == 'email-already-in-use'){
           ScaffoldMessenger.of(context).clearSnackBars();
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('try another email')));
           setState(() {
             _isAuthenicated == false ;
           });
         }


       }


      }

    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 17, 177),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.only(
                    left: 20, top: 30, bottom: 20, right: 20),
                padding: EdgeInsets.only(top: 10),
                child: Image.asset('assets/images/chat.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 360,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Card(

                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,

                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if(!_isLogin)
                            ImagePick(onPick: (File? _PickedImage) {
                              _SelecteImage = _PickedImage ;
                            },),
                          TextFormField(
                            controller: _EmailController,

                            decoration: const InputDecoration(
                              label: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'email address',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                            onSaved: (value){
                              value = _EmailController.text;
                              },


                            validator: _ValidateEmail,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                          if(!_isLogin)
                          TextFormField(
                            controller: _UsernameController,
                            decoration:const InputDecoration(label: Text('username'),),
                            enableSuggestions: false,
                            onSaved: (value){
                              value = _UsernameController.text;
                            },
                            validator: _ValidateUserName ,

                          ),
                          TextFormField(
                            controller: _PasswordController,

                            decoration: const InputDecoration(
                              label: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Password',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                            validator:_Validatepassword,
                            obscureText: true,
                            onSaved: (value){
                              value = _PasswordController.text;
                            },
                          ),
                          Column(
                            children: [
                              if(_isAuthenicated)
                                const CircularProgressIndicator(),
                             if(!_isAuthenicated)
                              ElevatedButton(onPressed: (){
                                Login(_EmailController.text , _PasswordController.text);
                              }, child:Text( _isLogin ? 'login' : 'SignUp')),
                              if(!_isAuthenicated)
                              TextButton(onPressed:(){
                                setState(() {
                                  _isLogin = !_isLogin;
                                });

                                }, child: Text( _isLogin ? 'create a new account' : 'I already have an account ')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
