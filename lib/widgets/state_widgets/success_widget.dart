import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/weathermodel.dart';

// Sub-widgets for SuccessWidget
import '../home_page_widgets/weather_details_card.dart';
import '../home_page_widgets/astronomical_info_card.dart';

class SuccessWidget extends StatelessWidget {
  final WeatherModel weatherModel;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const SuccessWidget({
    super.key,
    required this.weatherModel,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: weatherModel.getThemeColors(),
        ),
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: MediaQuery.of(context).size.height * 0.9,
            flexibleSpace: FlexibleSpaceBar(
              background: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: _buildMainWeatherContent(),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 24.0, right: 24.0, left: 24.0),
                child: Column(
                  children: [
                    WeatherDetailsCard(weatherModel: weatherModel),
                    const SizedBox(height: 12),
                    AstronomicalInfoCard(weatherModel: weatherModel),
                    const SizedBox(height: 24),
                    _buildLastUpdated(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeatherContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'weather-icon',
          child: Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Lottie.asset(weatherModel.getImage(), fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${weatherModel.temp.toInt()}°',
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          weatherModel.weatherState,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'H:${weatherModel.maxTemp.toInt()}° L:${weatherModel.minTemp.toInt()}°',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
    return Text(
      'Last Updated: ${weatherModel.getFormattedTime()}',
      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
      textAlign: TextAlign.center,
    );
  }
}
