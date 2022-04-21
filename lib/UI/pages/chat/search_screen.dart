import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import 'chat_leon.dart';

class SearchScreen extends StatefulWidget {
  //UserModel user;
  SearchScreen();

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  List<Map> nutzer = [];
  bool isLoading = false;

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
            .showSnackBar(SnackBar(content: Text("No User Found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['id'] != user.id) {
          searchResult.add(user.data());
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 10), () async {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        if (value.docs.length < 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No User Found")));
          value.docs.forEach((user) {
            if (user.data()['id'] != user.id) {
              nutzer.add(user.data());
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFA7BB7B), //change your color here
        ),
        backgroundColor: Colors.white,
        toolbarHeight: MediaQuery.of(context).size.height * 0.09,
        title: Text(
          "Neuer Chat",
          style: TextStyle(
            color: Color(0xFFA7BB7B),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: "Gib einen Nutzernamen ein...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    onSearch();
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          if (searchResult.length > 0)
            Expanded(
                child: ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final color = Color(0xFF9FB98B);
                      bool hasImage = false;
                      if (searchResult[index]['profilImageURL'] != null) {
                        hasImage = true;
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              hasImage ? Colors.transparent : color,
                          backgroundImage: hasImage
                              ? NetworkImage(
                                  searchResult[index]['profilImageURL'])
                              : null,
                          radius: 20,
                          child: !hasImage
                              ? Text(
                                  searchResult[index]['name'].isEmpty
                                      ? ''
                                      : searchResult[index]['name'][0]
                                          .toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        title: Text(searchResult[index]['name']),
                        subtitle: Text(searchResult[index]['email']),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                searchController.text = "";
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPageLeon(
                                          friendId: searchResult[index]
                                              ['userID'],
                                          friendName: searchResult[index]
                                              ['name'],
                                          friendImage: searchResult[index]
                                              ['profilImageURL'])));
                            },
                            icon: Icon(Icons.message)),
                      );
                    }))
          else if (isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
