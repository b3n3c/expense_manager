import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/expense_provider.dart';
import 'package:targyalo/screens/expense_list/form_parts/take_picture.dart';

class ReceiptPicture extends StatefulWidget {
  String path;

  ReceiptPicture({this.path=""});

  @override
  _ReceiptPictureState createState() => _ReceiptPictureState();
}

class _ReceiptPictureState extends State<ReceiptPicture> {
  File? image;


  @override
  void initState() {
    super.initState();
    if (widget.path != ""){
      image = File(widget.path);
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: Colors.white,
            ),
            child: Image(
              image: image?.existsSync() == true
                  ? Image.memory(
                image!.readAsBytesSync(),
                fit: BoxFit.fill,
              ).image : AssetImage("assets/receipt.png"),
              width: 300,
              height: 300,
            ),

          ),
          Positioned(
            child: GestureDetector(
              child: Icon(
                Icons.photo_camera,
                color: Colors.black,
              ),
              onTap: () async {
                File? newImage = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeProfilePictureScreen(),
                  ),
                );
                if (newImage != null) {
                  setImage(newImage);
                  context.read<ExpenseProvider>().setReceiptPath(newImage.path);
                }
              },
            ),
            right: 0,
            bottom: 0,
          ),
        ],
      ),
    );
  }
}