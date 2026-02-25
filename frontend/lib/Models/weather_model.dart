class WeatherModel {
  final String main;
  final String description;
  final double temp;
  final int humidity;
  final int clouds;
  final double windSpeed;

  WeatherModel({
    required this.main,
    required this.description,
    required this.temp,
    required this.humidity,
    required this.clouds,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'] as List?;
    if (weather == null || weather.isEmpty) {
      throw FormatException('Missing or empty "weather" array in JSON');
    }
    final mainData = json['main'] as Map<String, dynamic>?;
    if (mainData == null) {
      throw FormatException('Missing "main" section in JSON');
    }
    final cloudsData = json['clouds'] as Map<String, dynamic>?;
    if (cloudsData == null) {
      throw FormatException('Missing "clouds" section in JSON');
    }
    final windData = json['wind'] as Map<String, dynamic>?;
    if (windData == null) {
      throw FormatException('Missing "wind" section in JSON');
    }
    return WeatherModel(
      main: weather[0]['main'] as String,
      description: weather[0]['description'] as String,
      temp: (mainData['temp'] as num).toDouble(),
      humidity: mainData['humidity'] as int,
      clouds: cloudsData['all'] as int,
      windSpeed: (windData['speed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main': main,
      'description': description,
      'temp': temp,
      'humidity': humidity,
      'clouds': clouds,
      'windSpeed': windSpeed,
    };
  }
}
