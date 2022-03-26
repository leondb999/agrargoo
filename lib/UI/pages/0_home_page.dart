import 'package:agrargo/UI/login/login_page.dart';
import 'package:agrargo/UI/pages/1_landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/auth_providers.dart';
import '../../widgets/layout_widgets.dart';

const int NAV_INDEX = 0;
/*
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    /// first variable is to get the data of Authenticated User    | User? user = data.currentUser;
    final data = ref.read(fireBaseAuthProvider);

    ///  Second variable to access the Logout Function
    final _auth = ref.watch(authenticationProvider);
    late User _user = data.currentUser!;
    print("email verified: ${_user.emailVerified}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text('Home Page'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data.currentUser!.displayName ?? ' No Name Yet'),
              SizedBox(height: 16.0),
              Text(data.currentUser!.email ?? 'You are logged In'),
              SizedBox(height: 16.0),
              data.currentUser!.emailVerified
                  ? Text(
                      'Email verified',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.green),
                    )
                  : Text(
                      'Email not verified',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.red),
                    ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Email Verifikation nochmals senden
                  ElevatedButton(
                    onPressed: () async {
                      await data.currentUser!.sendEmailVerification();
                    },
                    child: Text('Verify email'),
                  ),
                  SizedBox(width: 8.0),

                  ///Nutzer aktualisieren
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      await data.currentUser!.reload();
                      setState(() {});
                      /*
                                    User? user = await FireAuth.refreshUser(
                                        _currentUser);


                                    if (user != null) {
                                      setState(() {
                                        _currentUser = user;
                                      }
                                      );

                                    }
                                    */
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 48.0),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    _auth.signOut();

                    /*   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );*/
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.w600),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: navigationBar(NAV_INDEX, context, data.currentUser),
    );
  }
}
*/
