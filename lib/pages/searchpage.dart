import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/services/weather_service.dart';

import '../models/weathermodel.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? cityName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 47, 60),
        title:
            const Text('Search a City', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: TextField(
            onChanged: (data) {
              cityName = data;
            },
            onSubmitted: (data) async {
              cityName = data;
              BlocProvider.of<WeatherCubit>(context).cityname = cityName;
              BlocProvider.of<WeatherCubit>(context).getWeather(cityName!);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 16),
                label: const Text('Search'),
                hintText: 'Enter city name',
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                    onTap: () async {
                      // BlocProvider.of<WeatherCubit>(context, listen: false)
                      //     .getWeather(cityName!);

                      // BlocProvider.of<WeatherCubit>(context, listen: false)
                      //     .cityname = cityName;
                      // Navigator.pop(context);
                    },
                    child: const Icon(Icons.search))),
          ),
        ),
      ),
    );
  }
}
