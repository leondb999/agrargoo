import 'dart:async';

import 'package:agrargo/UI/pages/chat/chat_leon.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:cached_network_image/cached_network_image.dart';

/// UserPage | Quelle: https://github.com/flyerhq/flutter_firebase_chat_core/blob/main/example/lib/users.dart
class ChatUsersPage extends ConsumerStatefulWidget {
  static const routename = '/chats-uebersicht';
  static User? user = FirebaseAuth.instance.currentUser;
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
  User? user = FirebaseAuth.instance.currentUser;

  /*
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
    //final room = await FirebaseChatCore.instance.createRoom(otherUser);
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
*/

  late UserModel um;
  @override
  Future<void> getUserModel() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    UserModel userModel = UserModel.fromJson(userData);
    um = userModel;
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

  /*

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

   */

  @override
  Widget build(BuildContext context) {
    //UserModel um = getUser(user);
    /*
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


     */
    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar:
          navigationBar(index: 1, context: context, ref: ref, home: false),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Text("No Chats Available !"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    print("friendID: " + friendId);
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          final color = Color(0xFF9FB98B);
                          bool hasImage = false;
                          if (friend['profilImageURL'] != null) {
                            hasImage = true;
                          }
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CircleAvatar(
                                backgroundColor:
                                    hasImage ? Colors.transparent : color,
                                backgroundImage: hasImage
                                    ? NetworkImage(friend['profilImageURL'])
                                    : null,
                                radius: 20,
                                child: !hasImage
                                    ? Text(
                                        friend['name'].isEmpty
                                            ? ''
                                            : friend['name'][0].toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    : null,
                              ),
                              /*
                              child: CachedNetworkImage(
                                imageUrl: friend['profilImageURL'],
                                placeholder: (conteext, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                ),
                                height: 50,
                              ),

                               */
                            ),
                            title: Text(friend['name']),
                            subtitle: Container(
                              child: Text(
                                "$lastMsg",
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPageLeon(
                                          friendId: friend['userID'],
                                          friendName: friend['name'],
                                          friendImage:
                                              friend['profilImageURL'])));
                            },
                          );
                        }
                        return LinearProgressIndicator();
                      },
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFA7BB7B),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
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
