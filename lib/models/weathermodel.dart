import 'package:flutter/material.dart';

class WeatherModel {
  final String date;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final String weatherState;
  final String image;

  // Current weather details
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final double pressure;
  final double visibility;
  final double uvIndex;
  final int cloudCover;
  final double dewPoint;
  final double gustSpeed;

  // Location info
  final String cityName;
  final String region;
  final String country;

  // Astronomical data
  final String sunrise;
  final String sunset;
  final String moonPhase;
  final int moonIllumination;

  WeatherModel({
    required this.date,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherState,
    required this.image,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.cloudCover,
    required this.dewPoint,
    required this.gustSpeed,
    required this.cityName,
    required this.region,
    required this.country,
    required this.sunrise,
    required this.sunset,
    required this.moonPhase,
    required this.moonIllumination,
  });

  factory WeatherModel.fromJson(dynamic data) {
    var currentData = data['current'];
    var forecastData = data['forecast']['forecastday'][0]['day'];
    var locationData = data['location'];
    var astroData = data['forecast']['forecastday'][0]['astro'];

    return WeatherModel(
      date: locationData['localtime'],
      temp: currentData['temp_c'].toDouble(),
      maxTemp: forecastData['maxtemp_c'].toDouble(),
      minTemp: forecastData['mintemp_c'].toDouble(),
      weatherState: currentData['condition']['text'],
      image: currentData['condition']['icon'],
      feelsLike: currentData['feelslike_c'].toDouble(),
      humidity: currentData['humidity'],
      windSpeed: currentData['wind_kph'].toDouble(),
      windDirection: currentData['wind_dir'],
      pressure: currentData['pressure_mb'].toDouble(),
      visibility: currentData['vis_km'].toDouble(),
      uvIndex: currentData['uv'].toDouble(),
      cloudCover: currentData['cloud'],
      dewPoint: currentData['dewpoint_c'].toDouble(),
      gustSpeed: currentData['gust_kph'].toDouble(),
      cityName: locationData['name'],
      region: locationData['region'],
      country: locationData['country'],
      sunrise: astroData['sunrise'],
      sunset: astroData['sunset'],
      moonPhase: astroData['moon_phase'],
      moonIllumination: astroData['moon_illumination'],
    );
  }

  @override
  String toString() {
    return 'WeatherModel(city: $cityName, temp: $temp°C, condition: $weatherState, humidity: $humidity%, wind: ${windSpeed}km/h)';
  }

  String getImage() {
    String condition = weatherState.toLowerCase();

    if (condition.contains('sunny') || condition.contains('clear')) {
      return 'assets/images/clear.json';
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return 'assets/images/cloudy.json';
    } else if (condition.contains('rain') ||
        condition.contains('drizzle') ||
        condition.contains('shower')) {
      return 'assets/images/rainy.json';
    } else if (condition.contains('snow') ||
        condition.contains('sleet') ||
        condition.contains('blizzard')) {
      return 'assets/images/snow.json';
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return 'assets/images/thunderstorm.json';
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return 'assets/images/cloudy.json';
    }

    return 'assets/images/clear.json';
  }

  List<Color> getThemeColors() {
    String condition = weatherState.toLowerCase();
    int hour = DateTime.parse(date.replaceAll(' ', 'T')).hour;
    bool isNight = hour < 6 || hour > 18;

    if (condition.contains('sunny') || condition.contains('clear')) {
      if (isNight) {
        return [
          const Color(0xFF1A237E), // Deep Indigo
          const Color(0xFF3F51B5), // Indigo
          const Color(0xFF5C6BC0), // Light Indigo
        ];
      } else {
        return [
          const Color(0xFF42A5F5), // Blue
          const Color(0xFF64B5F6), // Light Blue

          const Color(0xFF87CEEB), // Sky Blue
        ];
      }
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return [
        const Color(0xFF78909C), // Blue Grey
        const Color(0xFF90A4AE), // Light Blue Grey
        const Color(0xFFB0BEC5), // Even Lighter Blue Grey
      ];
    } else if (condition.contains('rain') ||
        condition.contains('drizzle') ||
        condition.contains('shower')) {
      return [
        const Color(0xFF455A64), // Blue Grey Dark
        const Color(0xFF607D8B), // Blue Grey
        const Color(0xFF78909C), // Blue Grey Light
      ];
    } else if (condition.contains('snow') ||
        condition.contains('sleet') ||
        condition.contains('blizzard')) {
      return [
        const Color(0xFF80DEEA), // Cyan
        const Color(0xFFB2EBF2), // Cyan Light

        const Color(0xFFE0F2F7), // Light Cyan
      ];
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return [
        const Color(0xFF212121), // Grey 900
        const Color(0xFF424242), // Grey 800
        const Color(0xFF616161), // Grey 700
      ];
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return [
        const Color.fromARGB(255, 83, 83, 83), // Grey 400
        const Color.fromARGB(255, 154, 154, 154), // Grey 300
        const Color.fromARGB(255, 181, 180, 180), // Grey 100
      ];
    }

    // Default gradient
    return [
      const Color(0xFF87CEEB),
      const Color(0xFF64B5F6),
      const Color(0xFF42A5F5),
    ];
  }

  String getWindDescription() {
    if (windSpeed < 5) return 'Calm';
    if (windSpeed < 15) return 'Light breeze';
    if (windSpeed < 30) return 'Moderate breeze';
    if (windSpeed < 50) return 'Strong breeze';
    return 'Very strong';
  }

  String getVisibilityDescription() {
    if (visibility >= 10) return 'Excellent';
    if (visibility >= 5) return 'Good';
    if (visibility >= 2) return 'Moderate';
    return 'Poor';
  }

  String getUVDescription() {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  String getHumidityDescription() {
    if (humidity < 30) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 80) return 'Humid';
    return 'Very Humid';
  }

  Color getUVColor() {
    if (uvIndex <= 2) return Colors.green;
    if (uvIndex <= 5) return Colors.yellow[700]!;
    if (uvIndex <= 7) return Colors.orange;
    if (uvIndex <= 10) return Colors.red;
    return Colors.purple;
  }

  String getFormattedLocation() {
    if (region.isNotEmpty && region != cityName) {
      return '$cityName, $region';
    }
    return '$cityName, $country';
  }

  String getFormattedTime() {
    try {
      DateTime dateTime = DateTime.parse(date.replaceAll(' ', 'T'));
      int hour = dateTime.hour;
      int minute = dateTime.minute;
      String ampm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm';
    } catch (e) {
      return date;
    }
  }
}
