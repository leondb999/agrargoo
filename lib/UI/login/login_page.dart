import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/auth_providers.dart';
import '../pages/0_home_page.dart';

//  Instead of creating Two Screens, I have Added both Login and Signup Screen in one Screen
//  Yes , I am Lazy , But I am not going to create two screens , I am going to create one screen

//  So for to monitor we are in which State we are i.e Login or signUp , I have used enums here
//  So I have created and Enum Status which contains two things Login and SignUp

//  and I have made a Global Variable type of Status, to use in LoginPage
// It's actually not recommended to use Global Variables , but I am using it here to make it simple
//  The main motive here was to teach Firebase Authentication using Riverpod as state management

enum Status {
  login,
  signUp,
}

Status type = Status.login;

//  I have used stateful widget to use setstate functions in LoginPage
//  we could also managed the state using Riverpod but I am not using it here
//  Remember Stateful widgets are made for a reason. If it would be bad
//  flutter developer would not think of it in the first place.

class LoginPage extends StatefulWidget {
  static const routename = '/LoginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //  GlobalKey is used to validate the Form
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;
  bool _isLoading2 = false;
  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void loading2() {
    setState(() {
      _isLoading2 = !_isLoading2;
    });
  }

  void _switchType() {
    if (type == Status.signUp) {
      setState(() {
        type = Status.login;
      });
    } else {
      setState(() {
        type = Status.signUp;
      });
    }
    // print(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          final _auth = ref.watch(authenticationProvider);

          Future<void> _onPressedFunction() async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            if (type == Status.login) {
              print("****authStateChange:");
              loading();
              await _auth
                  .signInWithEmailAndPassword(
                      _email.text, _password.text, context)
                  .whenComplete(
                    () => _auth.authStateChange.listen(
                      (event) async {
                        MaterialPageRoute(builder: (context) => LoginPage());
                        if (event == null) {
                          loading();
                          return;
                        }
                      },
                    ),
                  );
            } else {
              loading();

              await _auth
                  .signUpWithEmailAndPassword(
                      _email.text, _password.text, context)
                  .whenComplete(
                    () => _auth.authStateChange.listen(
                      (event) async {
                        if (event == null) {
                          loading();
                          return;
                        }
                      },
                    ),
                  );
            }
          }

          return Form(
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

                        ///Register Container
                        if (type == Status.signUp)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(25)),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Confirm password',
                                hintStyle: TextStyle(color: Colors.black54),
                                icon: Icon(CupertinoIcons.lock_circle,
                                    color: Colors.blue.shade700, size: 24),
                                alignLabelWithHint: true,
                                border: InputBorder.none,
                                focusColor: Colors.green,
                              ),
                              validator: type == Status.signUp
                                  ? (value) {
                                      if (value != _password.text) {
                                        return 'Passwords do not match!';
                                      }
                                      return null;
                                    }
                                  : null,
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
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : MaterialButton(
                                  onPressed: _onPressedFunction,
                                  child: Text(
                                    type == Status.login ? 'Log in' : 'Sign up',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  textColor: Colors.blue.shade700,
                                  textTheme: ButtonTextTheme.primary,
                                  minWidth: 100,
                                  padding: const EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side:
                                        BorderSide(color: Colors.blue.shade700),
                                  ),
                                ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: RichText(
                            text: TextSpan(
                              text: type == Status.login
                                  ? 'Don\'t have an account? '
                                  : 'Already have an account? ',
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: type == Status.login
                                        ? 'Sign up now'
                                        : 'Log in',
                                    style:
                                        TextStyle(color: Colors.blue.shade700),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _switchType();
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
          );
        }),
      ),
    );
  }
}
