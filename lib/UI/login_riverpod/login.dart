import 'package:agrargo/UI/login_riverpod/register.dart';
import 'package:agrargo/UI/pages/chat/users_page_leon.dart';
import 'package:agrargo/UI/pages/profil/helfer_profil_admin.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/widgets/login_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/layout_widgets.dart';
import '../pages/angebot/4_a_job_angebot_landwirt.dart';
import '../pages/profil/landwirt_profil_admin.dart';

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
  var jobanzeige_ID = "";
  var auftraggeberID;
  var chat_navigation = false;
  var profil_navigation = false;
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

        ///BottomNavigationBar Case 1: user klicks auf Chat field
        if (routeData['chat_navigation'] != null) {
          chat_navigation = routeData['chat_navigation'];
        }

        ///BottomNavigationBar Case 2: user klicks auf Profil field
        if (routeData['profil_navigation'] != null) {
          profil_navigation = routeData['profil_navigation'];
        }
        if (routeData['jobanzeige_ID'] != null) {
          jobanzeige_ID = routeData['jobanzeige_ID'];
          auftraggeberID = routeData['auftraggeberID'];
        }
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
                                  color: Color(0xFF586015)))),
                      const Spacer(flex: 1),

                      ///Email Input Field
                      customTextFormField(
                        controller: _email,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email Adresse',
                        icon: Icon(Icons.email_outlined,
                            color: Color(0xFFA7BB7B), size: 24),
                        validateString: 'email',
                        obscureText: false,
                        autocorrect: true,
                        enableSuggestions: true,
                      ),

                      ///Password Input Field
                      customTextFormField(
                        controller: _password,
                        hintText: 'Passwort',
                        icon: Icon(CupertinoIcons.lock_circle,
                            color: Color(0xFFA7BB7B), size: 24),
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
                            ///Validate Login Input

                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            print(
                                "authControllerState Sign Out: $authControllerState");

                            ///SignIn Email & Password123123
                            ///TODO Fix Bug: After Landwirt logs in he is navigated to home Page
                            bool login = false;
                            try {
                              login = await ref
                                  .read(authControllerProvider.notifier)
                                  .signInEmail(
                                      context, _email.text, _password.text);
                            } catch (e) {
                              print("Error loggin In: $e");
                            }

                            print("_landwirt login: $_landwirt");

                            if (login == true) {
                              if (_landwirt == true) {
                                Navigator.pushNamed(
                                  context,
                                  LandwirtProfil.routename,
                                );
                              }
                              print(
                                  "Navigation: profil_navigation: $profil_navigation");

                              /// Helfer Navigation (case 1: Chat)
                              if (chat_navigation == true) {
                                print(
                                    "Navigation: chat_navigation: $chat_navigation");
                                Navigator.pushNamed(
                                    context, ChatUsersPage.routename);
                              }

                              /// Helfer Navigation, wenn User vorher auf den Bewerbenbutten gedrückt hat
                              if (jobanzeige_ID.isNotEmpty) {
                                print(
                                    "Navigation: jobanzeige_ID: $jobanzeige_ID");
                                Navigator.pushNamed(
                                  context,
                                  Jobangebot.routename,
                                  arguments: {
                                    'jobanzeige_ID': jobanzeige_ID,
                                    'auftraggeberID': auftraggeberID,
                                  },
                                );
                              }

                              ///User (Helfer) drückt auf Profil Button
                              if (profil_navigation == true) {
                                print(
                                    "Navigation: profil_navigation: $profil_navigation");
                                Navigator.pushNamed(
                                  context,
                                  HelferProfil.routename,
                                );
                              }
                            }

                            ///Login User in Firebase
                          },
                          child: Text(
                            'Log in',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          textColor: Color(0xFF586015),
                          textTheme: ButtonTextTheme.primary,
                          minWidth: 100,
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Color(0xFF586015)),
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
                                    fontSize: 15, color: Color(0xFF586015)),
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
