import 'package:agrargo/UI/pages/1_landing_page.dart';
import 'package:agrargo/UI/login/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../UI/pages/4_a_job_angebot.dart';

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
    backgroundColor: Color(0xFFFFFFFFFF),
    title: Image.network(
      'https://db3pap003files.storage.live.com/y4mXOv83bMJ_mQo9mHxeWwP8CAevF_-PzOe-QcYCpxpMJXAQu3Ecqv4P1w_tsoGl692VZM1l5PQVEeqnTbVm3N_SBr59Gnkendy66sxI8pxtX0qCLXb4mUoAWxCoYSdEKT97Pv_QlgnG4xjNiIhhvyjr3dmR58HXH-k5yg10FiyGWxwgfTbZuQkEdW2Hn_Se7qN?width=500&height=108&cropmode=none',
    ),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.home),
        color: Colors.black,
        tooltip: 'Startseite',
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.message_sharp),
        color: Colors.black,
        tooltip: 'Nachrichten',
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.account_circle_outlined),
        color: Colors.black,
        tooltip: 'Profil',
        onPressed: () {},
      ),
    ],
  );
}
