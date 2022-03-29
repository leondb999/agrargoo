import 'package:agrargo/UI/pages/4_a_job_angebot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/layout_widgets.dart';

class JobangebotUebersichtPage extends StatefulWidget {
  const JobangebotUebersichtPage({Key? key}) : super(key: key);

  @override
  State<JobangebotUebersichtPage> createState() =>
      _JobangebotUebersichtPageState();
  static const routename = '/jobUebersicht';
}

class _JobangebotUebersichtPageState extends State<JobangebotUebersichtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.17,
              color: Color(0xFF1f623c),
              child: Center(
                  child: Text("Aktuelle Stellenangebote",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffffff))))),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.89),
                Icon(
                  Icons.filter_alt_sharp,
                  color: Colors.black,
                  size: 30.0,
                ),
                SizedBox(width: 7),
                Icon(
                  Icons.sort,
                  color: Colors.black,
                  size: 30.0,
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.015),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return makeCard;
                    },
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text("Gemüseernte - Bauernhof Meyer",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text("9,25 €/h",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Open Sans',
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF000000))),
                                SizedBox(width: 50),
                                IconButton(
                                  icon: const Icon(Icons.arrow_right),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                jobangebot()));
                                  },
                                  color: Colors.black,
                                  iconSize: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text(
                                  "Viel zu tun im Kuhstall - Bauernhof Laier",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text("13,50 €/h",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Open Sans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000))),
                                  SizedBox(width: 50),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text("Spargelernte - Familie Leuer",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text("10,00 €/h",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Open Sans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000))),
                                  SizedBox(width: 50),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text(
                                  "Traktorfahrer*in gesucht - Bauernhof Riedel",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text("9,50 €/h",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Open Sans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000))),
                                  SizedBox(width: 50),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
              ]),
            ),
          )
        ],
      ),
    );
  }

  final makeCard = Card(
    elevation: 6.0,
    margin: new EdgeInsets.symmetric(horizontal: 70.0, vertical: 13.0),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF9FB98B)),
      child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white54))),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              )),
          title: Text(
            "Gemüseernte auf dem Bauernhof Meyer",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Icon(Icons.place, color: Colors.black12),
              SizedBox(height: 30),
              Text(" Hockenheim", style: TextStyle(color: Colors.white))
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: 30.0)),
    ),
  );
}
