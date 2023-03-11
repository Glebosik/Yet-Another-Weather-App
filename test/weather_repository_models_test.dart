// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:test/test.dart';
import 'package:weather_bloc/weather/repository/models/models.dart';

void main() {
  group('Weather', () {
    group('fromJson', () {
      test('returns correct Weather object', () {
        expect(
          Weather.fromJson(
            <String, dynamic>{
              'temperature': 15.3,
              'weathercode': 1,
              'location': 'city'
            },
          ),
          isA<Weather>()
              .having((w) => w.temperature, 'temperature', 15.3)
              .having((w) => w.condition, 'condition', WeatherCondition.clear)
              .having((w) => w.location, 'location', 'city'),
        );
      });
    });
  });
}
