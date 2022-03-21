import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

const API_KEY = 'b85b91c2ff683c37dcd4ac22dfbf632b';

Future<String> getWeatherData() async {
  final response = await http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=$API_KEY'),
  );
  print(response.body);
  return response.body;
}

Future<String> getRandevuUser() async {
  final response = await http.get(
    Uri.parse('https://api.randevu.technology/getParticipantTypes'),
    headers: {
      "x-randevu-key": "pk_sand-ee9c3b73b381401db8cfb3449c43f68",
      "email": "leondickob@gmail.com",
      "password": "Rafcamora666",
    },
  );
  print(response.body);
  return response.body;
}
