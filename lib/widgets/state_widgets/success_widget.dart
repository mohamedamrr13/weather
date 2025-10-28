import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/weathermodel.dart';
// Sub-widgets for SuccessWidget
import '../home_page_widgets/weather_details_card.dart';
import '../home_page_widgets/astronomical_info_card.dart';

class SuccessWidget extends StatefulWidget {
  final WeatherModel weatherModel;
  final Animation<Offset> slideAnimation;
  final Function(bool)? onScrollChanged;

  const SuccessWidget({
    super.key,
    required this.weatherModel,
    required this.slideAnimation,
    this.onScrollChanged,
  });

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  late ScrollController _scrollController;
  double _scrollOpacity = 1.0;
  bool _isAutoScrolling = false;
  double _lastScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final halfwayPoint = maxScrollExtent / 2;

    // Notify parent about scroll state (hide AppBar when scrolled)
    if (widget.onScrollChanged != null) {
      widget.onScrollChanged!(scrollOffset > 10);
    }

    // Calculate opacity - fade out starting from halfway point
    setState(() {
      if (scrollOffset < halfwayPoint) {
        // Before halfway: keep full opacity
        _scrollOpacity = 1.0;
      } else {
        // After halfway: fade from 1.0 to 0.0
        final fadeProgress = (scrollOffset - halfwayPoint) / halfwayPoint;
        _scrollOpacity = (1.0 - fadeProgress).clamp(0.0, 1.0);
      }
    });

    // Detect user scroll and trigger auto-scroll
    if (!_isAutoScrolling &&
        scrollOffset > 0 &&
        scrollOffset < maxScrollExtent) {
      // User has started scrolling down
      if (scrollOffset > _lastScrollPosition) {
        _triggerAutoScroll();
      }
    }

    _lastScrollPosition = scrollOffset;
  }

  void _triggerAutoScroll() async {
    if (_isAutoScrolling) return;

    _isAutoScrolling = true;

    // Get the target scroll position (end of the expanded header)
    final targetPosition = _scrollController.position.maxScrollExtent;

    // Animate to the target position
    await _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    _isAutoScrolling = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.weatherModel.getThemeColors(),
        ),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: MediaQuery.of(context).size.height * .9,
            flexibleSpace: FlexibleSpaceBar(
              background: SlideTransition(
                position: widget.slideAnimation,
                child: Opacity(
                  opacity: _scrollOpacity,
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
                    WeatherDetailsCard(weatherModel: widget.weatherModel),
                    const SizedBox(height: 12),
                    AstronomicalInfoCard(weatherModel: widget.weatherModel),
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
            child: Lottie.asset(widget.weatherModel.getImage(),
                fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${widget.weatherModel.temp.toInt()}°',
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.weatherModel.weatherState,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'H:${widget.weatherModel.maxTemp.toInt()}° L:${widget.weatherModel.minTemp.toInt()}°',
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
      'Last Updated: ${widget.weatherModel.getFormattedTime()}',
      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
      textAlign: TextAlign.center,
    );
  }
}
