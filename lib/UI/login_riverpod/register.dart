import 'package:agrargo/UI/login_riverpod/test_screen.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:age_calculator/age_calculator.dart';
import '../../main.dart';
import '../../widgets/login_widgets.dart';
import '../pages/profil/landwirt_profil.dart';

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
  bool? _landwirt;
  var routeData;
  DateTime selectedDate = DateTime(1800);
  DateDuration ageYears = DateDuration();
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime(2025),
      initialDate: DateTime(2010),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        ageYears = AgeCalculator.age(selected);
        selectedDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    print("landwirt: $_landwirt");
    print("selected Date: $selectedDate");
    print("ageYears: $ageYears");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
              "Register als ${_landwirt! ? 'Landwirt' : 'Helfer'} : $_landwirt"),
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

                      ///Birth Date Container
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: selectedDate != DateTime(1800)
                            ? Text(
                                "Birth Date: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}")
                            : Text("No Birth Date selected Yet"),
                        //Text(
                        //      "Birth Date: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}"),
                      ),
                      ageYears.years != 0
                          ? Text("You Are ${ageYears.years} old")
                          : Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text("Choose Birth Date")),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              ///File Picker https://camposha.info/flutter/flutter-filepicker/#gsc.tab=0

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
                            if (ageYears.years < 18) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                          title: const Text('Error Occured'),
                                          content: Text(
                                              "You have to be 18 to register"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text("OK"))
                                          ]));
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
                                  _landwirt!,
                                  selectedDate,
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
