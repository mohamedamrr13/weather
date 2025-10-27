import 'package:flutter/material.dart';
import '../../models/weathermodel.dart';
import 'detail_row.dart';

class WeatherDetailsCard extends StatelessWidget {
  final WeatherModel weatherModel;

  const WeatherDetailsCard({super.key, required this.weatherModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white30, height: 20),
            DetailRow(
              label: 'Feels Like',
              value: '${weatherModel.feelsLike.toInt()}°C',
            ),
            DetailRow(
              label: 'Humidity',
              value: '${weatherModel.humidity}%',
            ),
            DetailRow(
              label: 'Wind',
              value:
                  '${weatherModel.windSpeed.toInt()} km/h ${weatherModel.windDirection}',
            ),
            DetailRow(
              label: 'Pressure',
              value: '${weatherModel.pressure.toInt()} mb',
            ),
            DetailRow(
              label: 'Visibility',
              value: '${weatherModel.visibility.toInt()} km',
            ),
            DetailRow(
              label: 'UV Index',
              value: weatherModel.uvIndex.toString(),
            ),
            DetailRow(
              label: 'Cloud Cover',
              value: '${weatherModel.cloudCover}%',
            ),
          ],
        ),
      ),
    );
  }
}
