import 'package:flutter/material.dart';
import '../../models/weathermodel.dart';
import 'detail_row.dart';

class AstronomicalInfoCard extends StatelessWidget {
  final WeatherModel weatherModel;

  const AstronomicalInfoCard({super.key, required this.weatherModel});

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
              'Astronomical Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white30, height: 20),
            DetailRow(
              label: 'Sunrise',
              value: weatherModel.sunrise,
            ),
            DetailRow(
              label: 'Sunset',
              value: weatherModel.sunset,
            ),
            DetailRow(
              label: 'Moon Phase',
              value: weatherModel.moonPhase,
            ),
            DetailRow(
              label: 'Moon Illumination',
              value: '${weatherModel.moonIllumination}%',
            ),
          ],
        ),
      ),
    );
  }
}
