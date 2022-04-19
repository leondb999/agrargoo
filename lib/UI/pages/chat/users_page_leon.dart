import 'dart:async';

import 'package:agrargo/UI/pages/chat/chat_leon.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore.dart';
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
import 'package:searchfield/searchfield.dart';

/// UserPage | Quelle: https://github.com/flyerhq/flutter_firebase_chat_core/blob/main/example/lib/users.dart
class ChatUsersPage extends ConsumerStatefulWidget {
  static const routename = '/chat-users-page1';
  ChatUsersPage();

  @override
  _ChatUsersPageState createState() => _ChatUsersPageState();
}

class _ChatUsersPageState extends ConsumerState<ChatUsersPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;
  Icon _searchIcon = new Icon(Icons.search);
  User? user = FirebaseAuth.instance.currentUser;

  Widget _buildAvatar(UserModel userModel) {
    final color = Color(0xFF9FB98B);
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
    //ChatPageLeon.room = await FirebaseChatCore.instance.createRoom(otherUser);
    final userList = ref.watch(userModelFirestoreControllerProvider);
    final userModel =
        UserProvider().getUserNameByUserID(otherUser.id, userList!).first;

    if (userModel.profilImageURL != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPageLeon(
            friendName: "${userModel.name}",
            friendId: "${userModel.userID}",
            friendImage: "${userModel.profilImageURL}",
          ),
        ),
      );
    }

    if (userModel.profilImageURL == null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPageLeon(
            friendName: "${userModel.name}",
            friendId: "${userModel.userID}",
          ),
        ),
      );
    }

    /// 'createdAt': FieldValue.serverTimestamp(),
  }

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Kein Nutzer gefunden")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        searchResult.add(user.data());
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void getData() async {
    final data = await FirebaseFirestore.instance
        .collection("messages")
        .orderBy("updatetAt", descending: true)
        .limit(1)
        .get();
  }

  List<types.User> typesUserList = [];

  List<types.Room> userLoggedInRoomList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(microseconds: 10), () async {
      ///Get alle Rooms die es gibt
      String? userID = ref.read(authControllerProvider.notifier).state!.uid;

      await FirebaseChatCore.instance.rooms().forEach((rooms) {
        rooms.forEach((room) {
          room.users.forEach((user) {
            if (user.id == userID) {
              // print("room: $room");
              if (userLoggedInRoomList.contains(room) == false) {
                setState(() {
                  userLoggedInRoomList.add(room);
                });
              }
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection("messages").orderBy("createdAt");
    print("userLoggedInRoomList: ${userLoggedInRoomList}");
    print("typesUserList: $typesUserList");
    userLoggedInRoomList.forEach((room) {
      print("room: $room");
    });

    ///Authentication State check: Logged In or Logged Out
    User? authControllerState = ref.watch(authControllerProvider);

    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);
    //  print("userList:$userList");

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    print("userID: $userID");
    final userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;
    print("userLoggedIn: name: ${userLoggedIn.name}");

    /*
    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);
*/
    return Scaffold(
        appBar: appBar(context: context, ref: ref, home: false),
        bottomNavigationBar:
            navigationBar(index: 1, context: context, ref: ref, home: false),
        body: Column(children: [
          buildSearchBar(),
          SizedBox(height: MediaQuery.of(context).size.height / 50),
          Expanded(
            child: StreamBuilder(
              ///TODO knackpunkt
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user?.uid)
                  .collection("messages")
                  .snapshots(),

              ///FirebaseChatCore.instance.users(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                        bottom: 200,
                      ),
                      child: const Text('Kein Nutzer'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      var friendId = snapshot.data.docs[index].id;
                      // final room = snapshot.data![index];
                      var lastMsg = snapshot.data![index]['last_msg'];

                      final userModel = UserProvider()
                          .getUserNameByUserID(user.id, userList!)
                          .first;
                      //  print("user.id: ${user.id}, userModel.name: ${userModel.name}");

                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(friendId)
                              .get(),
                          builder: (context, AsyncSnapshot asynSnapshot) {
                            if (asynSnapshot.hasData) {
                              var friend = asynSnapshot.data;
                              return ListTile(
                                leading: CircleAvatar(
                                    child: _buildAvatar(userModel)),
                                title: Text(friend['name']),
                                subtitle: Text(
                                  "$lastMsg",
                                  style: TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }
                            return LinearProgressIndicator();
                          });
                    },
                  );
                }

                /*
                if (searchResult.length > 0) {
                  return ListView.builder(itemBuilder: (context, index) {
                    itemCount:
                    searchResult.length;
                    int ind = 0;

                    while (snapshot.data![ind].id !=
                        searchResult[index]["userID"]) {
                      ind = ind + 1;
                    }

                    final user = snapshot.data![ind];
                    final userModel = UserProvider()
                        .getUserNameByUserID(
                            searchResult[index]["userID"], userList!)
                        .first;

                    return FlatButton(
                      onPressed: () {
                        _handlePressed(user, context);
                      },
                      child: Column(
                        children: [
                          Row(children: [
                            Expanded(
                              flex: 1,
                              child: _buildAvatar(userModel),
                            ),
                            Expanded(
                              flex: 12,
                              child: Text("${searchResult[index]['name']}"),
                            ),
                          ]),
                        ],
                      ),
                    );
                  });
                }
                ;
                */
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ]));
  }

  Widget buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Suche nach Nutzern...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: IconButton(
            onPressed: () {
              onSearch();
            },
            icon: Icon(Icons.search),
            color: Colors.grey.shade600,
            iconSize: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
        ),
      ),
    );
  }
}
