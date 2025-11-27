import 'package:weather/api/api.dart';
import 'package:weather/models/weathermodel.dart';

class WeatherService {
  String apiKey = '053148ffcc4241709de01810233107';

  Future<WeatherModel?> getWeather({required String cityName}) async {
    WeatherModel model;
    String baseurl =
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName';

    Map<String, dynamic> data = await Api.get(url: baseurl);

    model = WeatherModel.fromJson(data);

    return model;
  }
}
//test :
//http://api.weatherapi.com/v1/forecast.json?key=053148ffcc4241709de01810233107&q=Al Aagami, Alexandria
