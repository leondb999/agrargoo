import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.green[100],
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  height: 100,
                  child: Center(
                      child: Text(
                    "Unsere Visionn Hallo Christina",
                    style: TextStyle(fontSize: 25.0),
                  )),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Auf Job- oder Helfersuche?",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "In 3 Schritten zum Erfolg",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                  child: Text(
                                "1. Deine Wünsche",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "2. Match finden",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "3. Durchstarten",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: ElevatedButton(
                    child: Text("Find your Jobs!"),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
