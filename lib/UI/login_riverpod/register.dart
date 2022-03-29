import 'package:agrargo/UI/login_riverpod/test_screen.dart';
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

import '../../main.dart';
import '../../widgets/login_widgets.dart';
import '../pages/landwirt/6_b_landwirt_profil.dart';

///https://www.geeksforgeeks.org/flutter-arguments-in-named-routes/
///TODO Vorname & Nachname

class RegisterPage extends ConsumerStatefulWidget {
  static const routename = '/register';

  RegisterPage();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

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
          child: Text(
              "Register als ${_landwirt ? 'Landwirt' : 'Helfer'} : $_landwirt"),
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

                      ///Name Input Field
                      customTextFormField(
                        controller: _name,
                        textInputType: TextInputType.name,
                        hintText: 'Name',
                        icon: Icon(Icons.person,
                            color: Colors.blue.shade700, size: 24),
                        validateString: 'name',
                        obscureText: false,
                        autocorrect: true,
                        enableSuggestions: true,
                      ),

                      ///Email Input Field
                      customTextFormField(
                        controller: _email,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email address',
                        icon: Icon(Icons.email_outlined,
                            color: Colors.blue.shade700, size: 24),
                        validateString: 'email',
                        obscureText: false,
                        autocorrect: true,
                        enableSuggestions: true,
                      ),

                      ///Password Input Field
                      customTextFormField(
                        controller: _password,
                        hintText: 'Password',
                        icon: Icon(CupertinoIcons.lock_circle,
                            color: Colors.blue.shade700, size: 24),
                        validateString: 'password',
                        obscureText: true,
                        autocorrect: true,
                        enableSuggestions: true,
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
                          onPressed: () async {
                            ///Validate Input Field Data

                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            print(
                                "authControllerState Sign Out: $authControllerState");

                            ///SignIn Email & Password
                            ref.read(authControllerProvider.notifier).register(
                                  context,
                                  _name.text,
                                  _email.text,
                                  _password.text,
                                  _landwirt,
                                );

                            ///Login User in Firebase
                          },
                          child: Text(
                            'Register',
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
                            text: 'You already have an account?  ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(color: Colors.blue.shade700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, "/login");
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

String? validateEmail(String value) {}
