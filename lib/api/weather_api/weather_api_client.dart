import 'package:weather_bloc/api/weather_api/models/weather.dart';

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

abstract class WeatherApiClient {
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  });
}
