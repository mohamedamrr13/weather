import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/api/api.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/cubits/weatherstates.dart';
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
  void initState() {
    super.initState();
    getCity();
  }

  void getCity() async {
    cityName = await Api.getCurrentCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 40, 47, 60),
        body:
            BlocBuilder<WeatherCubit, WeatherStates>(builder: (context, state) {
          if (state is WeatherLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherSuccessState) {
            weatherModel = BlocProvider.of<WeatherCubit>(context).weatherModel;
            return Scaffold(
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
                    Text(cityName!,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    Text(
                      ' ${weatherModel!.date}',
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
                    'Something Went Wrong',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    'Please Try Again',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )
                ],
              ),
            );
          }
        }));
  }
}
