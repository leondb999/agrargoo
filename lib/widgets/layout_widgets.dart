import 'package:agrargo/UI/pages/1_landing_page.dart';
import 'package:agrargo/UI/login/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

BottomNavigationBar navigationBar(int index, BuildContext context, User user) {
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
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
      }
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
        );
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