import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/api/api.dart';
import 'package:weather/cubits/weatherstates.dart';
import 'package:weather/models/weathermodel.dart';
import 'package:weather/services/weather_service.dart';

class WeatherCubit extends Cubit<WeatherStates> {
  WeatherService weatherService;
  WeatherModel? weatherModel;
  String? cityname;
  WeatherCubit(this.weatherService) : super(WeatherInitial());
  void getWeather() async {
    emit(WeatherLoadingState());
    try {
      weatherModel =
          await weatherService.getWeather(cityName: await Api.getCurrentCity());
      emit(WeatherSuccessState());
    } on Exception {
      emit(WeatherFailureState());
    }
  }
}
