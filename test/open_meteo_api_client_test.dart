// ignore_for_file: prefer_const_constructors
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_bloc/api/weather_api/weather_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('OpenMeteoApiClient', () {
    late http.Client httpClient;
    late OpenMeteoApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = OpenMeteoApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(OpenMeteoApiClient(), isNotNull);
      });
    });

    group('getWeather', () {
      const latitude = 41.85003;
      const longitude = -87.6500;

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
            Uri.https('api.open-meteo.com', 'v1/forecast', {
              'latitude': '$latitude',
              'longitude': '$longitude',
              'current_weather': 'true'
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
"latitude": 43,
"longitude": -87.875,
"generationtime_ms": 0.2510547637939453,
"utc_offset_seconds": 0,
"timezone": "GMT",
"timezone_abbreviation": "GMT",
"elevation": 189,
"current_weather": {
"temperature": 15.3,
"windspeed": 25.8,
"winddirection": 310,
"weathercode": 0,
"time": "2022-09-12T01:00"
}
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
              .having((w) => w.temperature, 'temperature', 15.3)
              .having((w) => w.weatherCode, 'weatherCode', 1),
        );
      });
    });
  });
}
