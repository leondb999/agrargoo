import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_KEY = 'b85b91c2ff683c37dcd4ac22dfbf632b';

class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

Future<String> getWeatherData() async {
  final response = await http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=$API_KEY'),
  );
  print(response.body);
  return response.body;
}

class _LandingPageState extends State<LandingPage> {
  String response = "";

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
                    "Unsere Vision",
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
                                  "3. Durchstarten lol3",
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
                Container(child: Text(response)),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: ElevatedButton(
                    child: Text("Find your Jobs!"),
                    onPressed: () async {
                      var data = await getWeatherData();
                      setState(() {
                        response = data;
                      });
                    },
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
