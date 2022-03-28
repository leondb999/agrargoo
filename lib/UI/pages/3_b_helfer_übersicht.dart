import 'package:flutter/cupertino.dart';

class HelferUebersichtPage extends StatefulWidget {
  const HelferUebersichtPage({Key? key}) : super(key: key);
  static const routename = '/helferuebersicht';

  @override
  _HelferUebersichtPageState createState() => _HelferUebersichtPageState();
}

class _HelferUebersichtPageState extends State<HelferUebersichtPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Helfer Übersicht"));
  }
}
