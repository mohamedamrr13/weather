import 'package:flutter/material.dart';
import 'package:weather/cubits/weatherstates.dart';
import 'package:weather/models/weathermodel.dart';
import 'package:weather/widgets/state_widgets/initial_widget.dart';
import 'package:weather/widgets/state_widgets/loading_widget.dart';
import 'package:weather/widgets/state_widgets/error_widget.dart';
import 'package:weather/widgets/state_widgets/success_widget.dart';

class StateWidgetBuilder extends StatelessWidget {
  final WeatherStates state;
  final String? cityName;
  final WeatherModel? weatherModel;
  final Animation<Offset> slideAnimation;
  final VoidCallback onSearchTap;
  final VoidCallback onTryAgain;
  final VoidCallback triggerHapticFeedback;
  final Function(bool)? onScrollChanged;

  const StateWidgetBuilder({
    super.key,
    required this.state,
    required this.cityName,
    required this.weatherModel,
    required this.slideAnimation,
    required this.onSearchTap,
    required this.onTryAgain,
    required this.triggerHapticFeedback,
    this.onScrollChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (state is WeatherLoadingState) {
      return LoadingWidget(cityName: cityName);
    } else if (state is WeatherSuccessState) {
      return SuccessWidget(
        weatherModel: weatherModel!,
        slideAnimation: slideAnimation,
        onScrollChanged: onScrollChanged,
      );
    } else if (state is WeatherFailureState) {
      return ErrorWidgetCustom(
        cityName: cityName,
        onTryAgain: onTryAgain,
        triggerHapticFeedback: triggerHapticFeedback,
      );
    } else {
      return InitialWidget(onSearchTap: onSearchTap);
    }
  }
}
