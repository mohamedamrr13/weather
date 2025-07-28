import 'package:flutter/material.dart';

class WeatherModel {
  final String date;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final String weatherState;
  final String image;

  WeatherModel(
      {required this.date,
      required this.temp,
      required this.maxTemp,
      required this.minTemp,
      required this.weatherState,
      required this.image});

  factory WeatherModel.fromJson(dynamic data) {
    var jsonData = data['forecast']['forecastday'][0]['day'];
    return WeatherModel(
        date: data['location']['localtime'],
        temp: jsonData['avgtemp_c'],
        maxTemp: jsonData['maxtemp_c'],
        minTemp: jsonData['mintemp_c'],
        weatherState: jsonData['condition']['text'],
        image: jsonData['condition']['icon']);
  }
  @override
  String toString() {
    return 'date = $date temp= $temp maxtemp = $maxTemp mintemp = $minTemp state = $weatherState';
  }

  String getImage() {
    if (weatherState == 'Cloudy' ||
        weatherState == 'Partly cloudy' ||
        weatherState == 'Overcast') {
      return 'assets/images/cloudy.png';
    } else if (weatherState == 'Patchy snow possible' ||
        weatherState == 'Patchy sleet possible' ||
        weatherState == 'Patchy freezing drizzle possible') {
      return 'assets/images/snow.png';
    } else if (weatherState == 'Heavy Cloud') {
      return 'assets/images/cloudy.png';
    } else if (weatherState == 'Light Rain' ||
        weatherState == 'Heavy Rain' ||
        weatherState == 'Moderate rain' ||
        weatherState == 'Patchy rain possible') {
      return 'assets/images/rainy.png';
    } else if (weatherState == 'Thunder' || weatherState == 'Thunderstorm') {
      return 'assets/images/thunderstorm.png';
    }
    return 'assets/images/clear.png';
  }

  MaterialColor getThemeColor() {
    if (weatherState == 'Cloudy' ||
        weatherState == 'Partly cloudy' ||
        weatherState == 'Overcast' ||
        weatherState == 'Sunny') {
      return Colors.orange;
    } else if (weatherState == 'Patchy snow possible' ||
        weatherState == 'Patchy sleet possible' ||
        weatherState == 'Patchy freezing drizzle possible') {
      return Colors.teal;
    } else if (weatherState == 'Heavy Cloud') {
      return Colors.blueGrey;
    } else if (weatherState == 'Light Rain' ||
        weatherState == 'Heavy Rain' ||
        weatherState == 'Moderate rain' ||
        weatherState == 'Patchy rain possible') {
      return Colors.blue;
    } else if (weatherState == 'Thunder' || weatherState == 'Thunderstorm') {
      return Colors.grey;
    }
    return Colors.blueGrey;
  }
}
