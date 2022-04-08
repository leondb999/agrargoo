import 'package:agrargo/UI/login_riverpod/register.dart';
import 'package:agrargo/UI/pages/profil/6_a_helfer_profil.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/widgets/login_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/layout_widgets.dart';
import '../pages/profil/landwirt_profil.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routename = '/login';
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool? _landwirt;
  var routeData;

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
    Future.delayed(Duration(microseconds: 10), () {
      routeData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      print("routeData: $routeData");
      setState(() {
        _landwirt = routeData['landwirt'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    print("landwirt: $_landwirt");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context: context, ref: ref, home: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text("Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E6C49)))),
                      const Spacer(flex: 1),

                      ///Email Input Field
                      customTextFormField(
                        controller: _email,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email Adresse',
                        icon: Icon(Icons.email_outlined,
                            color: Color(0xFF9FB98B), size: 24),
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
                            color: Color(0xFF9FB98B), size: 24),
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
                            } else {
                              Navigator.pushNamed(
                                context,
                                HelferProfil.routename,
                              );
                            }

                            ///Login User in Firebase
                          },
                          child: Text(
                            'Log in',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          textColor: Color(0xFF2E6C49),
                          textTheme: ButtonTextTheme.primary,
                          minWidth: 100,
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Color(0xFF2E6C49)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Du hast noch keinen Account? ',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Jetzt registieren',
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFF2E6C49)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterPage.routename,
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
