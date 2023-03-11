// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Weather',
      json,
      ($checkedConvert) {
        final val = Weather(
          location: $checkedConvert('location', (v) => v as String),
          temperature:
              $checkedConvert('temperature', (v) => (v as num).toDouble()),
          condition: $checkedConvert(
              'weathercode', (v) => $enumDecode(_$WeatherConditionEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'condition': 'weathercode'},
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'weathercode': _$WeatherConditionEnumMap[instance.condition]!,
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 1,
  WeatherCondition.rainy: 2,
  WeatherCondition.cloudy: 3,
  WeatherCondition.snowy: 4,
  WeatherCondition.unknown: 5,
};
