import 'package:flutter/cupertino.dart';

class LandwirtProfil extends StatefulWidget {
  const LandwirtProfil({Key? key}) : super(key: key);
  static const routename = '/landwirtprofil';

  @override
  _LandwirtProfilState createState() => _LandwirtProfilState();
}

class _LandwirtProfilState extends State<LandwirtProfil> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Landwirt Profil"),
    );
  }
}
