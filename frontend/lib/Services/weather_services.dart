import 'dart:convert';

import 'package:frontend/Models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  final apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=Multan&appid=6f0c89185479ac776c0fed55945d4b21&units=metric';

  Future<WeatherModel> fetchWeatherData() async {
    try {
      final url = Uri.parse(apiUrl);
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load weather data: HTTP ${response.statusCode}',
        );
      }
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return WeatherModel.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  String getWeatherSuggestion(WeatherModel weather) {
    final mainLower = weather.main.toLowerCase();

    if (mainLower.contains('rain')) {
      return "It's raining 🌧️, take an umbrella!";
    } else if (mainLower.contains('snow')) {
      return "Snowy ❄️, wear warm clothes!";
    } else if (weather.temp > 30) {
      return "Too hot ☀️, stay hydrated and use shade!";
    } else if (weather.temp < 15) {
      return "Cold ❄️, wear warm clothes!";
    } else if (mainLower.contains('haze') || mainLower.contains('fog')) {
      return "Hazy 🌫️, drive carefully!";
    } else if (mainLower.contains('cloud')) {
      return "Cloudy ☁️, a light jacket might help!";
    } else {
      return "Weather is normal 🙂, enjoy your day!";
    }
  }
}
