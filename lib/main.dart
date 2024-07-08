import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/pages/homepage.dart';
import 'package:weather/services/weather_service.dart';

void main() {
  runApp(BlocProvider<WeatherCubit>(
      create: (context) {
        return WeatherCubit(WeatherService());
      },
      child: const Weather()));
}

class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
            primarySwatch:
                BlocProvider.of<WeatherCubit>(context).weatherModel == null
                    ? Colors.blue
                    : BlocProvider.of<WeatherCubit>(context)
                        .weatherModel!
                        .getThemeColor()));
  }
}
