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

    final jsonWeatherCode = bodyJson['weather'][0]['id'] as int;
    late final int weatherCode;
    //https://www.weatherbit.io/api/codes
    switch (jsonWeatherCode) {
      case 800:
        weatherCode = 1; //Clear
        break;
      case 500:
      case 501:
      case 502:
      case 511:
      case 520:
      case 521:
      case 522:
        weatherCode = 2; //Rain
        break;
      case 801:
      case 802:
      case 803:
      case 804:
        weatherCode = 3; //Cloudy
        break;
      case 600:
      case 601:
      case 602:
      case 610:
      case 611:
      case 612:
      case 621:
      case 622:
      case 623:
        weatherCode = 4; //Snowy
        break;
      default:
        weatherCode = 5; //Unknown
    }
    jsonForInstantiation['weathercode'] = weatherCode;

    final temperature = bodyJson['main']['temp'] as double;
    jsonForInstantiation['temperature'] = temperature;

    return Weather.fromJson(jsonForInstantiation);
  }
}
