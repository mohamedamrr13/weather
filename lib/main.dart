import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/services/weather_service.dart';

import 'home_page.dart';

void main() {
  runApp(BlocProvider<WeatherCubit>(
      create: (context) {
        return WeatherCubit(WeatherService())..getWeather();
      },
      child: const Weather()));
}

class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
