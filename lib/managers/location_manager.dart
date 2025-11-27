import 'package:flutter/material.dart';
import 'package:weather/api/api.dart';
import 'package:weather/models/weathermodel.dart';

class LocationManager {
  String? _cityName;
  String? _location;
  WeatherModel? _weatherModel;

  String? get cityName => _cityName;
  String? get location => _location;
  WeatherModel? get weatherModel => _weatherModel;

  Future<void> loadInitialCity() async {
    try {
      _cityName = await Api.getCurrentCity();
    } catch (e) {
      debugPrint('Error loading city: $e');
      _cityName = null;
    }
  }

  void updateWeatherModel(WeatherModel model) {
    _weatherModel = model;
    _location = model.getFormattedLocation();
  }

  void updateCityName(String city) {
    _cityName = city;
    _location = null;
  }

  String getDisplayLocation() {
    if (_weatherModel != null) {
      return _weatherModel!.getFormattedLocation();
    }
    return _cityName ?? 'Loading...';
  }
}
