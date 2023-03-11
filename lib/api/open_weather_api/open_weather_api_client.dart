import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_bloc/api/weather_api/weather_api_client.dart';
import 'open_weather_api.dart';

class OpenWeatherApiClient implements WeatherApiClient {
  OpenWeatherApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _baseUrl = 'api.openweathermap.org';
  static const _apiKey = '13dc57d834e2dc8eb4377c3ef224b8d3';

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrl, 'data/2.5/weather', {
      'lat': '$latitude',
      'lon': '$longitude',
      'appid': _apiKey,
      'units': 'metric',
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('weather')) {
      throw WeatherNotFoundFailure();
    }

    var jsonForInstantiation = <String, dynamic>{};

    final weathercode = bodyJson['weather'][0]['id'] as int;
    jsonForInstantiation['weathercode'] = weathercode.toDouble();

    final temperature = bodyJson['main']['temp'] as double;
    jsonForInstantiation['temperature'] = temperature;

    return Weather.fromJson(jsonForInstantiation);
  }
}
