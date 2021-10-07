/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/models/Message.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';
import 'dart:io';

import 'package:ofy_flutter/groupMsg/uploader/FileHandler.dart';

class PhotoMessageSender extends StatefulWidget
{

  File imageFile;

  final gUser currentUser;
  final String receiver;
  final String messageReceiverType;


  PhotoMessageSender({this.imageFile, this.currentUser, this.receiver, this.messageReceiverType});
  
  @override
  _PhotoMessageSenderState createState() => _PhotoMessageSenderState();
}

class _PhotoMessageSenderState extends State<PhotoMessageSender>
{

  attachFileAndSendMessage(BuildContext context) async
  {
    String download_url = await FileHandler(folder_name: "attached_images",
        file_name: DateTime.now().millisecondsSinceEpoch.toString(),
        file: widget.imageFile).startUpload();

    DatabaseService().addChat(Message(
        senderID: CurrentUser.user.uid,
        receiverID: widget.receiver ?? "",
        receivedAt: DateTime.now().toString(),
        message: download_url,
        messageType: "image",
        messageReceiverType: widget.messageReceiverType,
        read: false
    ));

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        child: Image.file(widget.imageFile),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send
        ),
        onPressed: (){
           attachFileAndSendMessage(context);
        },
      )

    );
  }
}
