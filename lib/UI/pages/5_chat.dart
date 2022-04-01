import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../repositories/firebase_storage_repository.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);
  static const routename = '/chat';

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF9FB98B), //change your color here
            ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.09,
            backgroundColor: Colors.white,
            title: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset('Images/logo_small.png')),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home_sharp),
                iconSize: MediaQuery.of(context).size.height * 0.05,
                color: Color(0xFF9FB98B),
                tooltip: 'Home',
                padding: new EdgeInsets.only(right: 20.0),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.message_sharp),
                iconSize: MediaQuery.of(context).size.height * 0.05,
                color: Color(0xFF9FB98B),
                tooltip: 'Chat',
                padding: new EdgeInsets.only(right: 20.0),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.account_circle_sharp),
                iconSize: MediaQuery.of(context).size.height * 0.05,
                color: Color(0xFF9FB98B),
                tooltip: 'Profil',
                padding: new EdgeInsets.only(right: 20.0),
                onPressed: () {},
              ),
            ]),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.14,
              color: Color(0xFF1f623c),
              child: Center(
                  child: Text("Chat",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffffff))))),
          Container(
              margin: EdgeInsets.only(top: 300.0),
              child: Center(
                  child: Text("Chat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E6C49))))),
        ])));
  }
}
