import 'dart:async';

import 'package:weather_bloc/api/geocoding_api/geocoding_api.dart';
import 'package:weather_bloc/api/weather_api/open_meteo_api_client.dart';
import 'package:weather_bloc/api/weather_api/weather_api_client.dart';

import 'models/models.dart';

class WeatherRepository {
  WeatherRepository(
      {WeatherApiClient? weatherApiClient,
      GeocodingApiClient? geocodingApiClient})
      : _weatherApiClient = weatherApiClient ?? OpenMeteoApiClient(),
        _geocodingApiClient = geocodingApiClient ?? GeocodingApiClient();

  final WeatherApiClient _weatherApiClient;
  final GeocodingApiClient _geocodingApiClient;

  Future<Weather> getWeather(String city) async {
    final location = await _geocodingApiClient.locationSearch(city);
    final weather = await _weatherApiClient.getWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return Weather(
      temperature: weather.temperature,
      location: location.name,
      condition: weather.weatherCode.toInt().toCondition,
    );
  }
}

extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 1:
        return WeatherCondition.clear;
      case 2:
        return WeatherCondition.rainy;
      case 3:
        return WeatherCondition.cloudy;
      case 4:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
