import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImagePick extends StatefulWidget {
  const ImagePick({Key? key, required this.onPick}) : super(key: key);
 final void  Function( File ?_PickedImage) onPick;

  @override
  State<ImagePick> createState() => _ImagePickState();
}


class _ImagePickState extends State<ImagePick> {
  File ? _PickedImage ;
  void addImage() async {

      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 150 , imageQuality: 50 );
      if(pickedImage == null ){
        return ;
      }
      setState(() {
        _PickedImage = File(pickedImage.path);
      });
      widget.onPick(_PickedImage);



  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        foregroundImage:_PickedImage != null ? FileImage(_PickedImage!) : null,
      ),
     TextButton.icon(onPressed: addImage,
       icon: Icon(Icons.image),
       label: Text('add image ' , style:
     TextStyle( color : Theme.of(context).primaryColor,),),
     )
    ],);
  }
}
