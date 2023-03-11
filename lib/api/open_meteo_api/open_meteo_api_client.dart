import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_bloc/api/weather_api/weather_api_client.dart';
import 'open_meteo_api.dart';

class OpenMeteoApiClient implements WeatherApiClient {
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _baseUrl = 'api.open-meteo.com';

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrl, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true'
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    var jsonForInstantiation = <String, dynamic>{};

    final jsonWeatherCode = bodyJson['current_weather']['weathercode'] as int;
    late final int weatherCode;
    //https://open-meteo.com/en/docs
    switch (jsonWeatherCode) {
      case 0:
        weatherCode = 1; //Clear
        break;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        weatherCode = 2; //Rain
        break;
      case 1:
      case 2:
      case 3:
        weatherCode = 3; //Cloudy
        break;
      case 71:
      case 73:
      case 75:
        weatherCode = 4; //Snowy
        break;
      default:
        weatherCode = 5; //Unknown
    }
    jsonForInstantiation['weathercode'] = weatherCode;

    final temperature = bodyJson['current_weather']['temperature'] as double;
    jsonForInstantiation['temperature'] = temperature;

    return Weather.fromJson(jsonForInstantiation);
  }
}
