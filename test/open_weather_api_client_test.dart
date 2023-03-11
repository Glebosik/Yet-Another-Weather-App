// ignore_for_file: prefer_const_constructors
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_bloc/api/weather_api/weather_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('OpenWeatherApiClient', () {
    late http.Client httpClient;
    late OpenWeatherApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = OpenWeatherApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(OpenWeatherApiClient(), isNotNull);
      });
    });

    group('getWeather', () {
      const latitude = 12.0;
      const longitude = 12.0;
      const apiKey = '13dc57d834e2dc8eb4377c3ef224b8d3';

      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.getWeather(latitude: latitude, longitude: longitude);
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https('api.openweathermap.org', 'data/2.5/weather', {
              'lat': '$latitude',
              'lon': '$longitude',
              'appid': apiKey,
              'units': 'metric',
            }),
          ),
        ).called(1);
      });

      test('throws WeatherRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
          throwsA(isA<WeatherRequestFailure>()),
        );
      });

      test('throws WeatherNotFoundFailure on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => apiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
          throwsA(isA<WeatherNotFoundFailure>()),
        );
      });

      test('returns weather on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
"coord":
{
  "lon":12,
  "lat":12
},
"weather":
[{
  "id":800,
  "main":"Clouds",
  "description":"overcast clouds",
  "icon":"04d"
}],
"base":"stations",
"main":
{
  "temp":38.24,
  "feels_like":35.03,
  "temp_min":38.24,
  "temp_max":38.24,
  "pressure":1006,
  "humidity":7,
  "sea_level":1006,
  "grnd_level":966
},
"visibility":10000,
"wind":
{
  "speed":8.88,
  "deg":61,
  "gust":8.22
},
"clouds":
{
  "all":91
},
"dt":1678461136,
"sys":
{
  "country":"NG",
  "sunrise":1678425763,
  "sunset":1678468938
},
"timezone":3600,
"id":2345521,
"name":"Damaturu",
"cod":200
}
        ''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.getWeather(
          latitude: latitude,
          longitude: longitude,
        );
        expect(
          actual,
          isA<Weather>()
              .having((w) => w.temperature, 'temperature', 38.24)
              .having((w) => w.weatherCode, 'weatherCode', 1),
        );
      });
    });
  });
}
