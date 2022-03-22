import 'package:agrargo/UI/landing_page.dart';
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
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
        );
      }
    },
  );
}
