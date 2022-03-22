import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently signed out!");
      } else {
        print("User is signed in!");
      }
    });
    String email = "";
    String password = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "Roboto"),
                  ),
                  Container(
                      color: Colors.black54,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'What do people call you?',
                              labelText: 'Name *',
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (String? value) {
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: 'Choos a password',
                                labelText: 'Password*'),
                          )
                        ],
                      )),
                  SignInButton(
                    Buttons.Email,
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: "$email", password: "$password");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        print("User signed out");
                      },
                      child: Text("Signout")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
