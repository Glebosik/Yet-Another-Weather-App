import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  @JsonValue(1)
  clear,
  @JsonValue(2)
  rainy,
  @JsonValue(3)
  cloudy,
  @JsonValue(4)
  snowy,
  @JsonValue(5)
  unknown,
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  final String location;
  final double temperature;
  @JsonKey(name: 'weathercode')
  final WeatherCondition condition;

  @override
  List<Object> get props => [location, temperature, condition];
}
