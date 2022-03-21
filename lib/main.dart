import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'UI/landing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrargo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(title: 'Agrargo'),
    );
  }
}
