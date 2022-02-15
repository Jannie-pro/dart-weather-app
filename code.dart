import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> prompt() async {
  print("please insert the desired location: ");
  String location = stdin.readLineSync();
  var response = await fetchCityWeather(location);
  print(response);
}

Future<CityWeather> fetchCityWeather(city) async {
  final response = await http.get(Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=c8e0136a67084973a9890710223101&q=${city}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var body = jsonDecode(response.body);
    return CityWeather.fromJson(body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load location');
  }
}

class CityWeather {
  final double temp;
  final String region;
  final String country;

  const CityWeather({
    this.temp,
    this.region,
    this.country,
  });

  factory CityWeather.fromJson(Map<String, dynamic> json) {
    return CityWeather(
      temp: json['current']['temp_c'],
      region: json['location']['region'],
      country: json['location']['country'],
    );
  }

  @override
  String toString() {
    return 'Data: temperature: ${temp}, region: ${region}, country: ${country}';
  }
}

Future<void> main(List<String> args) async {
  prompt();
}
