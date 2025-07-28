import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/cubits/weatherstates.dart';
import 'package:weather/pages/searchpage.dart';
import '../models/weathermodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;

  String? cityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 40, 47, 60),
        appBar: AppBar(
          backgroundColor: weatherModel?.getThemeColor() ?? Colors.grey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SearchPage();
                  }));
                },
                icon: const Icon(Icons.search))
          ],
          title: const Text(
            'Weather App',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:
            BlocBuilder<WeatherCubit, WeatherStates>(builder: (context, state) {
          if (state is WeatherLoadingState) {
            return const Center(child: const CircularProgressIndicator());
          } else if (state is WeatherSuccessState) {
            weatherModel = BlocProvider.of<WeatherCubit>(context).weatherModel;
            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 40, 47, 60),
                body: Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          weatherModel!.getThemeColor(),
                          weatherModel!.getThemeColor()[300]!,
                          weatherModel!.getThemeColor()[100]!
                        ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(BlocProvider.of<WeatherCubit>(context).cityname!,
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        Text(
                          'updated at ${weatherModel!.date}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(weatherModel!.getImage()),
                            Text('${weatherModel!.temp}',
                                style: const TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold)),
                            Column(
                              children: [
                                Text('max = ${weatherModel!.maxTemp.toInt()}',
                                    style: const TextStyle(fontSize: 18)),
                                Text('min = ${weatherModel!.minTemp.toInt()}',
                                    style: const TextStyle(fontSize: 18))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(weatherModel!.weatherState,
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 190,
                        )
                      ],
                    ),
                  ),
                ));
          } else if (state is WeatherFailureState) {
            return const Scaffold(
              body: Text('There is an error'),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'There is no weather',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    'Start searching now 🔍',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )
                ],
              ),
            );
          }
        }));
  }
}
