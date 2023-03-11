# Yet Another Weather App

A weather app based on BLoC architecture with 4 layers:
- Data Layer
- Repository Layer
- Business Logic Layer
- Presentation Layer

Data Layer interacts with different APIs:
- OpenMeteo Geocoding API to get the coordinates by city name
- OpenMeteo API to get current weather in a location
- OpenWeather API another API to get current weather in a location

Repository Layer abstracts Data Layer letting us utilize different weather APIs without too much hussle.

Business Logic Layer acts like a bridge between Repository and UI also helping with state management of app.

Presentation Layers name speaks for itself.


Application should be completely covered with unit and widget tests.
