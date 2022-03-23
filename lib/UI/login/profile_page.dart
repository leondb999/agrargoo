import 'package:agrargo/UI/login/login_page.dart';
import 'package:agrargo/UI/pages/1_landing_page.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:agrargo/zwischenspeicher/login_page_zw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';

///Index für Navbar
final int _selectedIndex = 1;

class ProfilePage extends StatefulWidget {
  final User? user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            ///Rivderpods Provider listents if User is Logged In or Logged Out
            final _user = ref.watch(authStateProvider);
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///Name
                      Text(
                        //'NAME: ${_currentUser.displayName}'
                        'NAME: ${_user.value!.displayName}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 16.0),

                      ///Email
                      Text(
                        'EMAIL: ${_user.value!.email}',
                        //'EMAIL: ${_currentUser.email}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 16.0),

                      ///Email verified
                      _user.value!.emailVerified
                          // _currentUser.emailVerified
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
                      SizedBox(height: 16.0),
                      _isSendingVerification
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Email Verifikation nochmals senden
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isSendingVerification = true;
                                    });
                                    await _currentUser.sendEmailVerification();
                                    setState(() {
                                      _isSendingVerification = false;
                                    });
                                  },
                                  child: Text('Verify email'),
                                ),
                                SizedBox(width: 8.0),

                                ///Nutzer aktualisieren
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () async {
                                    /*
                                    User? user = await _auth.refreshUser(
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
                      SizedBox(height: 16.0),
                      _isSigningOut
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isSigningOut = true;
                                });
                                await FirebaseAuth.instance.signOut();
                                setState(() {
                                  _isSigningOut = false;
                                });
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text('Sign out'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      ///Widget für Navigationbar
      //bottomNavigationBar: navigationBar(_selectedIndex, context, _currentUser),
    );
  }
}
