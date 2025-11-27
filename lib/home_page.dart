import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/cubits/weatherstates.dart';
import 'package:weather/managers/animation_manager.dart';
import 'package:weather/managers/search_manager.dart';
import 'package:weather/managers/location_manager.dart';
import 'widgets/home_page_widgets/home_page_app_bar.dart';
import 'widgets/home_page_widgets/search_overlay.dart';
import 'widgets/state_widget_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Managers
  late final AnimationManager _animationManager;
  late final SearchManager _searchManager;
  late final LocationManager _locationManager;

  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _initializeManagers();
    _loadInitialData();
  }

  void _initializeManagers() {
    _animationManager = AnimationManager();
    _animationManager.initialize(this);

    _searchManager = SearchManager();
    _searchManager.initialize();

    _locationManager = LocationManager();
  }

  Future<void> _loadInitialData() async {
    await _locationManager.loadInitialCity();
    if (mounted) {
      setState(() {});
      if (_locationManager.cityName != null) {
        // ignore: use_build_context_synchronously
        BlocProvider.of<WeatherCubit>(context)
            .getWeather(_locationManager.cityName);
      }
    }
  }

  void _searchWeather(String city) {
    if (city.trim().isEmpty) return;

    _triggerHapticFeedback();
    _searchManager.saveToSearchHistory(city);
    _locationManager.updateCityName(city);
    _searchManager.closeSearch();
    _animationManager.hideSearch();

    setState(() {});

    BlocProvider.of<WeatherCubit>(context).getWeather(city);
  }

  void _toggleSearch() {
    _searchManager.toggleSearch();

    if (_searchManager.isSearching) {
      _animationManager.showSearch();
      Future.delayed(const Duration(milliseconds: 200), () {
        _searchManager.searchFocusNode.requestFocus();
      });
    } else {
      _animationManager.hideSearch();
      _searchManager.closeSearch();
    }

    setState(() {});
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  void _onScrollChanged(bool isScrolled) {
    if (isScrolled && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
      _animationManager.hideAppBar();
    } else if (!isScrolled && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
      _animationManager.showAppBar();
    }
  }

  @override
  void dispose() {
    _animationManager.dispose();
    _searchManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SlideTransition(
          position: _animationManager.appBarSlideAnimation,
          child: HomePageAppBar(
            isSearching: _searchManager.isSearching,
            getDisplayLocation: _locationManager.getDisplayLocation,
            toggleSearch: _toggleSearch,
            searchTextController: _searchManager.searchTextController,
            searchFocusNode: _searchManager.searchFocusNode,
            searchWeather: _searchWeather,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          _triggerHapticFeedback();
          if (_locationManager.cityName != null) {
            return BlocProvider.of<WeatherCubit>(context)
                .getWeather(_locationManager.cityName);
          }
        },
        child: Stack(
          children: [
            BlocConsumer<WeatherCubit, WeatherStates>(
              listener: (context, state) {
                if (state is WeatherSuccessState) {
                  final weatherModel =
                      BlocProvider.of<WeatherCubit>(context).weatherModel;
                  if (weatherModel != null) {
                    _locationManager.updateWeatherModel(weatherModel);
                  }
                  _animationManager.playFadeIn();
                  _animationManager.playSlideIn();
                  setState(() {});
                }
              },
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: StateWidgetBuilder(
                    key: ValueKey(state.runtimeType),
                    state: state,
                    cityName: _locationManager.cityName,
                    weatherModel: _locationManager.weatherModel,
                    slideAnimation: _animationManager.slideAnimation,
                    onSearchTap: _toggleSearch,
                    onTryAgain: () =>
                        _searchWeather(_locationManager.cityName!),
                    triggerHapticFeedback: _triggerHapticFeedback,
                    onScrollChanged: _onScrollChanged,
                  ),
                );
              },
            ),
            SearchOverlay(
              searchAnimation: _animationManager.searchAnimation,
              searchSuggestions: _searchManager.searchSuggestions,
              searchHistory: _searchManager.searchHistory,
              searchWeather: _searchWeather,
            ),
          ],
        ),
      ),
    );
  }
}
