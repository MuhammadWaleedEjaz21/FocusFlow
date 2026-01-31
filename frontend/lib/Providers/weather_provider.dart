import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/Services/weather_services.dart';

final fetchWeatherServiceProvider = Provider.autoDispose<WeatherServices>((
  ref,
) {
  return WeatherServices();
});

final weatherDataProvider = FutureProvider.autoDispose((ref) async {
  final weatherService = ref.watch(fetchWeatherServiceProvider);
  return await weatherService.fetchWeatherData();
});

final weatherSuggestionProvider = Provider.autoDispose<String>((ref) {
  final weatherAsyncValue = ref.watch(weatherDataProvider);

  return weatherAsyncValue.when(
    data: (weather) {
      final weatherService = ref.watch(fetchWeatherServiceProvider);
      return weatherService.getWeatherSuggestion(weather);
    },
    loading: () => 'Loading weather suggestion...',
    error: (err, stack) => 'Error loading weather suggestion',
  );
});
