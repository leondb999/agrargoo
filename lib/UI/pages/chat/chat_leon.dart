import 'dart:io';
import 'package:agrargo/provider/user_provider.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'package:path_provider/path_provider.dart';

import '../../../models/user_model.dart';

///Quelle: https://github.com/flyerhq/flutter_firebase_chat_core/blob/main/example/lib/chat.dart
class ChatPageLeon extends ConsumerStatefulWidget {
  //static types.Room? room;
  final String? friendId;
  final String? friendName;
  final String? friendImage;

  const ChatPageLeon(
      {Key? key,
      //this.room,
      this.friendId,
      this.friendName,
      this.friendImage})
      : super(key: key);

  static const routename = '/chat';

  @override
  _ChatPageLeonState createState() => _ChatPageLeonState();
}

class _ChatPageLeonState extends ConsumerState<ChatPageLeon> {
  bool _isAttachmentUploading = false;
  late DocumentSnapshot userData;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getId() async {
    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider().userID)
        .get();
  }

  /*
  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance
        .updateMessage(updatedMessage, ChatPageLeon.room!.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      ChatPageLeon.room!.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("Room: ${widget.room}");
    final color = Color(0xFFA7BB7B);
    bool hasImage = false;

    if ('${widget.friendImage}' != "null") {
      hasImage = true;
    }

    final name = '${widget.friendName}';

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFFA7BB7B), //change your color here
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.09,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF9FB98B),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundColor: hasImage ? Colors.transparent : color,
                    backgroundImage:
                        hasImage ? NetworkImage('${widget.friendImage}') : null,
                    radius: 20,
                    child: !hasImage
                        ? Text(
                            name.isEmpty ? '' : name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${widget.friendName}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
            navigationBar(index: 1, context: context, ref: ref, home: false),
        body: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user?.uid)
                      .collection("messages")
                      .doc(widget.friendId)
                      .collection("chats")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(
                          child: Text("Keine Nachricht bisher"),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe = snapshot.data.docs[index]['senderId'] ==
                                user?.uid;
                            return SingleMessage(
                                message: snapshot.data.docs[index]['message'],
                                isMe: isMe);
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )),
            MessageTextField(user?.uid, widget.friendId),
          ],
        )

        /*
      StreamBuilder<types.Room>(
        initialData: ChatPageLeon.room!,
        stream: FirebaseChatCore.instance.room(ChatPageLeon.room!.id),
        builder: (context, snapshot) {
          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return SafeArea(
                bottom: false,
                child: Chat(
                  messages: snapshot.data ?? [],
                  //onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  user: types.User(
                    id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
