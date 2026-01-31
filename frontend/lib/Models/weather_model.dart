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
    return WeatherModel(
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temp: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      clouds: json['clouds']['all'],
      windSpeed: json['wind']['speed'].toDouble(),
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
