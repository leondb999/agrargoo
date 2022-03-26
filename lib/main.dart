import 'package:agrargo/UI/login_riverpod/register_riverpod.dart';
import 'package:agrargo/UI/login_riverpod/test_screen.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutterfire_ui/i10n.dart';

import 'UI/login_riverpod/login_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Riverpod2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/home",
      routes: {
        '/login': (context) => LoginRiverpodPage(),
        '/home': (context) => HomeScreen(),
        '/test': (context) => TestScreen(),
        '/register': (context) => RegisterRiverpodPage(),
      },
    );
  }
}

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? authControllerState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Agrar Go')),
        actions: [
          authControllerState != null

              ///Sign Out
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 5),
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    print("authControllerState Sign Out: $authControllerState");
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                  child: Text("Sign Out"),
                )

              ///Sign In
              : IconButton(
                  splashColor: Colors.green,
                  icon: Icon(
                    Icons.login,
                  ),
                  onPressed: () {
                    print("authControllerState Sign Out: $authControllerState");
                    /*
                    context
                        .read(authControllerProvider.notifier)
                        .signInAnonym();
                 */
                    authControllerState != null
                        ? Navigator.pushReplacementNamed(context, "/login")
                        : Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            authControllerState == null
                ? Column(
                    children: [
                      Icon(Icons.login),
                      Text("Signed Out"),
                      Text(
                        "Name ${ref.read(authControllerProvider.notifier).state?.displayName}",
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        "Email ${ref.read(authControllerProvider.notifier).state?.email}",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Icon(Icons.login),
                      Text(
                        "Signed In:  ${ref.read(authControllerProvider.notifier).state?.uid}",
                      ),
                      Text(
                        "Name ${ref.read(authControllerProvider.notifier).state?.displayName}",
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        "Email: ${ref.read(authControllerProvider.notifier).state?.email}",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
