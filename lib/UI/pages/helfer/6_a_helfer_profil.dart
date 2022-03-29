import 'package:flutter/cupertino.dart';

class HelferProfil extends StatefulWidget {
  const HelferProfil({Key? key}) : super(key: key);
  static const routename = '/helferprofil';

  @override
  _HelferProfilState createState() => _HelferProfilState();
}

class _HelferProfilState extends State<HelferProfil> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Helferprofil"),
    );
  }
}
