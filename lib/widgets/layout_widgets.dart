import 'package:agrargo/UI/login_riverpod/login_riverpod.dart';
import 'package:agrargo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

BottomNavigationBar navigationBar(int index, BuildContext context, User? user) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
    ],
    currentIndex: index,
    selectedItemColor: Colors.amber[800],
    onTap: (index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      if (index == 1) {
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginRiverpodPage()),
          );
        }
      }
    },
  );
}

AppBar appBar() {
  return AppBar(
    backgroundColor: Colors.green,
    title: Center(
      child: Text('AgrarGo'),
    ),
  );
}
