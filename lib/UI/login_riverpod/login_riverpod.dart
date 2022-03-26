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

enum Status {
  login,
  signUp,
}

Status type = Status.login;

class LoginRiverpodPage extends ConsumerStatefulWidget {
  static const routename = '/LoginRiverpodPage';
  LoginRiverpodPage({Key? key}) : super(key: key);

  @override
  _LoginRiverpodPageState createState() => _LoginRiverpodPageState();
}

class _LoginRiverpodPageState extends ConsumerState<LoginRiverpodPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);
        Navigator.pushReplacementNamed(context, "home");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text("Login"),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                            /*
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            */
                            print(
                                "authControllerState Sign Out: $authControllerState");

                            ///SignIn Anonymously
                            /*
                            ref
                                .read(authControllerProvider.notifier)
                                .signInAnonym();
                             */
                            ref
                                .read(authControllerProvider.notifier)
                                .signInEmail(context);
                            Navigator.pushReplacementNamed(context, "/home");

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
                                  text: type == Status.login
                                      ? 'Sign up now'
                                      : 'Log in',
                                  style: TextStyle(color: Colors.blue.shade700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      ///TODO Implement Register Page
                                    })
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
