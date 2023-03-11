import 'package:test/test.dart';
import 'package:weather_bloc/api/weather_api/weather_api.dart';

void main() {
  group('Weather', () {
    group('fromJson', () {
      test('returns correct Weather object', () {
        expect(
          Weather.fromJson(
            <String, dynamic>{'temperature': 15.3, 'weathercode': 63},
          ),
          isA<Weather>()
              .having((w) => w.temperature, 'temperature', 15.3)
              .having((w) => w.weatherCode, 'weatherCode', 63),
        );
      });
    });
  });
}
