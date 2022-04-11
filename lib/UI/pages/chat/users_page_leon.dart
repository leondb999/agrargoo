import 'dart:async';

import 'package:agrargo/UI/pages/chat/chat_leon.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../../../allConstants/color_constants.dart';
import '../../../allConstants/size_constants.dart';
import '../../../repositories/firestore_user_model_riverpod_repository.dart';
import '../../../widgets/layout_widgets.dart';
import 'chatDetailPage.dart';

/// UserPage | Quelle: https://github.com/flyerhq/flutter_firebase_chat_core/blob/main/example/lib/users.dart
class ChatUsersPage extends ConsumerStatefulWidget {
  const ChatUsersPage({Key? key}) : super(key: key);
  static const routename = '/chat-users-page1';

  @override
  _ChatUsersPageState createState() => _ChatUsersPageState();
}

class _ChatUsersPageState extends ConsumerState<ChatUsersPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  StreamController<bool> buttonClearController = StreamController<bool>();
  String _textSearch = "";

  Widget _buildAvatar(UserModel userModel) {
    final color = Colors.green;
    final hasImage = userModel.profilImageURL != null;
    final name = userModel.name;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage:
            hasImage ? NetworkImage(userModel.profilImageURL!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name!.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    /// 'createdAt': FieldValue.serverTimestamp(),
    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPageLeon(
          room: room,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///Authentication State check: Logged In or Logged Out
    User? authControllerState = ref.watch(authControllerProvider);

    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);
    print("userList:$userList");

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    print("userID: $userID");
    final userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;
    print("userLoggedIn: name: ${userLoggedIn.name}");

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar:
          navigationBar(index: 1, context: context, ref: ref, home: false),
      body: StreamBuilder<List<types.User>>(
        ///TODO knackpunkt
        stream: FirebaseChatCore.instance
            .users() /*.where((event) {
          bool findUser = false;
          event.forEach((user) {
            if (user.id == 'e3id9w9bPecKea74Qpx4qnPAi2R2') {
              findUser = true;
              return findUser;
              break;
            }
            print("user: ${user.id}");
          });
          return findUser;
        })*/
        ,

        ///FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          buildSearchBar();
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No users'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];

              final userModel =
                  UserProvider().getUserNameByUserID(user.id, userList).first;
              print("user.id: ${user.id}, userModel.name: ${userModel.name}");

              return FlatButton(
                onPressed: () {
                  _handlePressed(user, context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      buildSearchBar(),
                      _buildAvatar(userModel),
                      Text("${userModel.name}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(Sizes.dimen_10),
      height: Sizes.dimen_50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: Sizes.dimen_10,
          ),
          const Icon(
            Icons.person_search,
            color: AppColors.white,
            size: Sizes.dimen_24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchTextEditingController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  buttonClearController.add(true);
                  setState(() {
                    _textSearch = value;
                  });
                } else {
                  buttonClearController.add(false);
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search here...',
                hintStyle: TextStyle(color: AppColors.white),
              ),
            ),
          ),
          StreamBuilder(
              stream: buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchTextEditingController.clear();
                          buttonClearController.add(false);
                          setState(() {
                            _textSearch = '';
                          });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.greyColor,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.dimen_30),
        color: AppColors.spaceLight,
      ),
    );
  }
}
