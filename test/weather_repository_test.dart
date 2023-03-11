// ignore_for_file: prefer_const_constructors

import 'package:mocktail/mocktail.dart';
import 'package:weather_bloc/api/weather_api/weather_api.dart' as weather_api;
import 'package:weather_bloc/api/geocoding_api/geocoding_api.dart'
    as geocoding_api;
import 'package:test/test.dart';
import 'package:weather_bloc/weather_repository/models/models.dart';
import 'package:weather_bloc/weather_repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements weather_api.OpenMeteoApiClient {}

class MockGeocodingApiClient extends Mock
    implements geocoding_api.GeocodingApiClient {}

class MockLocation extends Mock implements geocoding_api.Location {}

class MockWeather extends Mock implements weather_api.Weather {}

void main() {
  group('WeatherRepository', () {
    late weather_api.WeatherApiClient weatherApiClient;
    late geocoding_api.GeocodingApiClient geocodingApiClient;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherApiClient = MockOpenMeteoApiClient();
      geocodingApiClient = MockGeocodingApiClient();
      weatherRepository = WeatherRepository(
        weatherApiClient: weatherApiClient,
        geocodingApiClient: geocodingApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal api clients when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    group('getWeather', () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test('calls locationSearch with correct city', () async {
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(() => geocodingApiClient.locationSearch(city)).called(1);
      });

      test('throws when locationSearch fails', () async {
        final exception = Exception('oops');
        when(() => geocodingApiClient.locationSearch(any()))
            .thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('calls getWeather with correct latitude/longitude', () async {
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(
          () => weatherApiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);
      });

      test('throws when getWeather fails', () async {
        final exception = Exception('oops');
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('returns correct weather on success (clear)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(1);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.clear,
          ),
        );
      });

      test('returns correct weather on success (rainy)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(2);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.rainy,
          ),
        );
      });

      test('returns correct weather on success (cloudy)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(3);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.cloudy,
          ),
        );
      });

      test('returns correct weather on success (snowy)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(4);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.snowy,
          ),
        );
      });

      test('returns correct weather on success (unknown)', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(-1);
        when(() => geocodingApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.unknown,
          ),
        );
      });
    });
  });
}
