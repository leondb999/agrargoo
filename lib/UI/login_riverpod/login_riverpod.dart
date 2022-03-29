import 'package:agrargo/UI/login_riverpod/register_riverpod.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutterfire_ui/i10n.dart';

import '../pages/3_b_helfer_übersicht.dart';
import '../pages/6_b_landwirt_profil.dart';

class LoginRiverpodPage extends ConsumerStatefulWidget {
  static const routename = '/login';
  LoginRiverpodPage({Key? key}) : super(key: key);

  @override
  _LoginRiverpodPageState createState() => _LoginRiverpodPageState();
}

class _LoginRiverpodPageState extends ConsumerState<LoginRiverpodPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();
/*
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    bool _landwirt = arguments['landwirt'];
    print("landwirt: $_landwirt");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text("Login"),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: FlutterLogo(size: 81)),
                      const Spacer(flex: 1),

                      ///Email Input Field
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          controller: _email,
                          autocorrect: true,
                          enableSuggestions: true,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            hintStyle: const TextStyle(color: Colors.black54),
                            icon: Icon(Icons.email_outlined,
                                color: Colors.blue.shade700, size: 24),
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                        ),
                      ),

                      /// Password Input Field
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),

                        ///Password
                        child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black54),
                            icon: Icon(
                              CupertinoIcons.lock_circle,
                              color: Colors.blue.shade700,
                              size: 24,
                            ),
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const Spacer()
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 32.0),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            ///Validate Login Input

                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            print(
                                "authControllerState Sign Out: $authControllerState");

                            ///SignIn Email & Password
                            ///TODO Fix Bug: After Landwirt logs in he is navigated to home Page
                            ref
                                .read(authControllerProvider.notifier)
                                .signInEmail(
                                    context, _email.text, _password.text);
                            print("_landwirt login: $_landwirt");
                            if (_landwirt == true) {
                              Navigator.pushNamed(
                                context,
                                LandwirtProfil.routename,
                              );

                              ///TODO Navigation to Helferübersichtseite
                              /*
                              Navigator.pushNamed(
                                context,
                                HelferUebersichtPage.routename,
                                arguments: {'landwirt': _landwirt},
                              );

                              */
                            }

                            ///Login User in Firebase
                          },
                          child: Text(
                            'Log in',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          textColor: Colors.blue.shade700,
                          textTheme: ButtonTextTheme.primary,
                          minWidth: 100,
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Register now',
                                style: TextStyle(color: Colors.blue.shade700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterRiverpodPage.routename,
                                      arguments: {'landwirt': _landwirt},
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
