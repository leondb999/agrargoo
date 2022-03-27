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

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // ref.refresh(authControllerProvider);
    User? authControllerState = ref.watch(authControllerProvider);
    authControllerState?.reload();
    User? authControllerStateRead = ref.read(authControllerProvider);

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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(authControllerProvider);
        },
        child: SafeArea(
          child: Row(
            children: [
              authControllerState == null
                  ? Column(
                      children: [
                        Icon(Icons.login),
                        Text("Signed Out"),
                        Text(
                          "Name ${authControllerState?.displayName}",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          "Email ${ref.read(authControllerProvider.notifier).state?.email}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Icon(Icons.login),
                        Text(
                          "Signed In:  ${ref.read(authControllerProvider.notifier).state?.uid}",
                        ),
                        Text(
                          "Name ${authControllerState.displayName}",
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          "Email: ${ref.read(authControllerProvider.notifier).state?.email}",
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          "Email: ${authControllerStateRead!.displayName}",
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
