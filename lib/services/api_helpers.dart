import 'package:http/http.dart' as http;

const API_KEY = 'b85b91c2ff683c37dcd4ac22dfbf632b';

class ApiHelpers {
  getWeatherData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid={API key}'),
    );
    print(response);
  }
}
