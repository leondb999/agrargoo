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
import '../../widgets/layout_widgets.dart';
import '../../widgets/login_widgets.dart';
import '../pages/profil/helfer_profil_admin.dart';
import '../pages/profil/landwirt_profil_admin.dart';

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
  DateTimeRange? selectedDateRange;
  String profilImageURL =
      "https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none";

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
      appBar: appBar(context: context, ref: ref, home: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.only(top: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text("Registrierung",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF586015)))),
                      const Spacer(flex: 1),

                      ///Name Input Field
                      customTextFormField(
                        controller: _name,
                        textInputType: TextInputType.name,
                        hintText: 'Name',
                        icon: Icon(Icons.person,
                            color: Color(0xFFA7BB7B), size: 24),
                        validateString: 'name',
                        obscureText: false,
                        autocorrect: true,
                        enableSuggestions: true,
                      ),

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
                                "Geburtsdatum: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}")
                            : Text("Es ist noch kein Geburtsdatum ausgew??hlt"),
                        //Text(
                        //      "Birth Date: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}"),
                      ),

                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Text("W??hle ein Geburtsdatum aus"),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFA7BB7B)))),
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
                                          title: const Text('Fehlermeldung'),
                                          content: Text(
                                              "Du musst mindestens 18 Jahre alt sein, um dich zu registrieren"),
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
                            DateTime startDate = DateTime(1700);
                            DateTime endDate = DateTime(1700);
                            print("startDate: $startDate, endDate: $endDate");

                            ///SignIn Email & Password
                            ref.read(authControllerProvider.notifier).register(
                                  context,
                                  _name.text,
                                  _email.text,
                                  _password.text,
                                  _landwirt!,
                                  selectedDate,
                                  startDate,
                                  endDate,
                                  profilImageURL,
                                );

                            ///Login User in Firebase
                            ///
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
                          },
                          child: Text(
                            'Registrieren',
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
                            text: 'Du hast schon einen Account?  ',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xFF586015)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, "/login");
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
