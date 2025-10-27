import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/api/api.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/cubits/weatherstates.dart';
import '../models/weathermodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  WeatherModel? weatherModel;
  String? cityName;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _searchController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _searchAnimation;

  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<String> _searchHistory = [];
  List<String> _searchSuggestions = [];
  String? location;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
    _loadSearchHistory();
    _setupSearchListener();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchController, curve: Curves.easeInOut),
    );
  }

  void _setupSearchListener() {
    _searchTextController.addListener(() {
      final query = _searchTextController.text;
      if (query.length > 2) {
        _generateSearchSuggestions(query);
      } else {
        setState(() {
          _searchSuggestions.clear();
        });
      }
    });
  }

  void _generateSearchSuggestions(String query) {
    final popularCities = [
      // Your original list
      'Alexandria',
      'New York',
      'London',
      'Tokyo',
      'Paris',
      'Sydney',
      'Berlin',
      'Dubai',
      'Singapore',
      'Mumbai',
      'Cairo',
      'Rome',
      'Madrid',
      'Barcelona',
      'Amsterdam',
      'Vienna',
      'Prague',
      'Istanbul',
      'Bangkok',
      'Seoul',
      'Melbourne',
      'Toronto',
      'Vancouver',
      'Montreal',
      'Los Angeles',
      'San Francisco',
      'Chicago',
      'Miami',
      'Las Vegas',
      'Boston',
      'Seattle',
      'Washington DC',

      // Additional popular cities
      'Doha',
      'Abu Dhabi',
      'Riyadh',
      'Jeddah',
      'Kuwait City',
      'Manila',
      'Jakarta',
      'Hanoi',
      'Taipei',
      'Beijing',
      'Shanghai',
      'Hong Kong',
      'New Delhi',
      'Bangalore',
      'Chennai',
      'Hyderabad',
      'Karachi',
      'Lahore',
      'Tehran',
      'Cape Town',
      'Johannesburg',
      'Nairobi',
      'Lagos',
      'Casablanca',
      'Addis Ababa',
      'Tunis',
      'Algiers',
      'Sao Paulo',
      'Rio de Janeiro',
      'Buenos Aires',
      'Lima',
      'Bogotá',
      'Santiago',
      'Mexico City',
      'Panama City',
      'San Juan',
      'Reykjavik',
      'Helsinki',
      'Oslo',
      'Copenhagen',
      'Stockholm',
      'Zurich',
      'Geneva',
      'Brussels',
      'Lisbon',
      'Warsaw',
      'Budapest',
      'Athens',
      'Florence',
      'Venice',
      'Valencia',
      'Porto',
      'Kiev',
      'Moscow',
      'Saint Petersburg',
      'Tbilisi',
      'Baku',
      'Yerevan',
      'Tashkent',
      'Astana',
      'Auckland',
      'Wellington',
      'Perth',
      'Brisbane',
      'Calgary',
      'Ottawa',
      'Edmonton',
      'Quebec City',
      'Philadelphia',
      'Dallas',
      'Houston',
      'Phoenix',
      'San Diego',
      'San Jose',
      'Austin',
      'Indianapolis',
      'Columbus',
      'Charlotte',
      'Detroit'
    ];

    setState(() {
      _searchSuggestions = popularCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .take(5)
          .toList();
    });
  }

  String _getDisplayLocation() {
    // If we have weather model data, use the formatted location
    if (weatherModel != null) {
      return weatherModel!.getFormattedLocation();
    }
    // Otherwise, show the current city name or loading text
    return cityName ?? 'Loading...';
  }

  Widget _buildSearchBar() {
    return Container(
      key: const ValueKey('search_bar'),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        cursorColor: Colors.grey,
        controller: _searchTextController,
        focusNode: _searchFocusNode,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 20),
            onPressed: () => _searchWeather(_searchTextController.text),
          ),
        ),
        onSubmitted: _searchWeather,
      ),
    );
  }

  Future<void> _loadInitialData() async {
    try {
      cityName = await Api.getCurrentCity();
      if (mounted) {
        setState(() {});
        if (cityName != null) {
          BlocProvider.of<WeatherCubit>(context).getWeather(cityName);
        }
      }
    } catch (e) {
      debugPrint('Error loading city: $e');
    }
  }

  void _loadSearchHistory() {
    _searchHistory = [];
  }

  void _saveToSearchHistory(String city) {
    setState(() {
      _searchHistory.removeWhere(
        (item) => item.toLowerCase() == city.toLowerCase(),
      );
      _searchHistory.insert(0, city);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.take(10).toList();
      }
    });
  }

  void _searchWeather(String city) {
    if (city.trim().isEmpty) return;

    _triggerHapticFeedback();
    _saveToSearchHistory(city);
    setState(() {
      cityName = city;
      _isSearching = false;
      // Clear the old location immediately when searching for a new city
      location = null;
    });
    _searchController.reverse();
    _searchTextController.clear();
    _searchFocusNode.unfocus();

    BlocProvider.of<WeatherCubit>(context).getWeather(city);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });

    if (_isSearching) {
      _searchController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _searchFocusNode.requestFocus();
      });
    } else {
      _searchController.reverse();
      _searchTextController.clear();
      _searchFocusNode.unfocus();
      setState(() {
        _searchSuggestions.clear();
      });
    }
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          _triggerHapticFeedback();
          if (cityName != null) {
            return BlocProvider.of<WeatherCubit>(context).getWeather(cityName);
          }
        },
        child: Stack(
          children: [
            BlocConsumer<WeatherCubit, WeatherStates>(
              listener: (context, state) {
                if (state is WeatherSuccessState) {
                  setState(() {
                    weatherModel = BlocProvider.of<WeatherCubit>(
                      context,
                    ).weatherModel;
                    location = weatherModel?.getFormattedLocation();
                  });
                }
              },
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildStateWidget(state),
                );
              },
            ),
            _buildSearchOverlay(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching ? _buildSearchBar() : _buildLocationTitle(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white.withOpacity(0.8),
          ),
          onPressed: _toggleSearch,
        ),
      ],
    );
  }

  Widget _buildLocationTitle() {
    return Row(
      key: const ValueKey('location_title'),
      children: [
        Icon(Icons.location_on, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _getDisplayLocation(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchOverlay() {
    return AnimatedBuilder(
      animation: _searchAnimation,
      builder: (context, child) {
        if (_searchAnimation.value == 0) return const SizedBox.shrink();

        return Positioned.fill(
          top: kToolbarHeight + MediaQuery.of(context).padding.top - 70,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchSuggestions.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Suggestions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ..._searchSuggestions.map(
                        (city) => _buildSearchItem(
                          city,
                          Icons.location_city,
                          () => _searchWeather(city),
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                    if (_searchHistory.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ..._searchHistory.map(
                        (city) => _buildSearchItem(
                          city,
                          Icons.history,
                          () => _searchWeather(city),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchItem(String city, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 20),
      title: Text(city, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildStateWidget(WeatherStates state) {
    if (state is WeatherLoadingState) {
      return _buildLoadingWidget();
    } else if (state is WeatherSuccessState) {
      _fadeController.forward();
      _slideController.forward();
      return _buildSuccessWidget();
    } else if (state is WeatherFailureState) {
      return _buildErrorWidget();
    } else {
      return _buildInitialWidget();
    }
  }

  Widget _buildLoadingWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD), Color(0xFF1E3A8A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Loading weather for ${cityName ?? 'your location'}...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessWidget() {
    if (weatherModel == null) return _buildErrorWidget();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: weatherModel!.getThemeColors(),
        ),
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            flexibleSpace: FlexibleSpaceBar(
              background: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
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
                    _buildWeatherDetails(),
                    const SizedBox(height: 12),
                    _buildAstronomicalInfo(),
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
            child: Lottie.asset(weatherModel!.getImage(), fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${weatherModel!.temp.toInt()}°',
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          weatherModel!.weatherState,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'H:${weatherModel!.maxTemp.toInt()}° L:${weatherModel!.minTemp.toInt()}°',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
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
            _buildDetailRow(
              'Feels Like',
              '${weatherModel!.feelsLike.toInt()}°C',
            ),
            _buildDetailRow('Humidity', '${weatherModel!.humidity}%'),
            _buildDetailRow(
              'Wind',
              '${weatherModel!.windSpeed.toInt()} km/h ${weatherModel!.windDirection}',
            ),
            _buildDetailRow('Pressure', '${weatherModel!.pressure.toInt()} mb'),
            _buildDetailRow(
              'Visibility',
              '${weatherModel!.visibility.toInt()} km',
            ),
            _buildDetailRow(
              'UV Index',
              '${weatherModel!.uvIndex.toInt()} (${weatherModel!.getUVDescription()})',
            ),
            _buildDetailRow('Cloud Cover', '${weatherModel!.cloudCover}%'),
            _buildDetailRow('Dew Point', '${weatherModel!.dewPoint.toInt()}°C'),
            _buildDetailRow(
              'Gust Speed',
              '${weatherModel!.gustSpeed.toInt()} km/h',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstronomicalInfo() {
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
            _buildDetailRow('Sunrise', weatherModel!.sunrise),
            _buildDetailRow('Sunset', weatherModel!.sunset),
            _buildDetailRow('Moon Phase', weatherModel!.moonPhase),
            _buildDetailRow(
              'Moon Illumination',
              '${weatherModel!.moonIllumination}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Text(
      'Last Updated: ${weatherModel!.getFormattedTime()}',
      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE57373), Color(0xFFD32F2F), Color(0xFFB71C1C)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 60),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection or try again later.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _triggerHapticFeedback();
                BlocProvider.of<WeatherCubit>(context).getWeather(cityName);
              },
              icon: const Icon(Icons.refresh, color: Colors.blueAccent),
              label: const Text(
                'Try Again',
                style: TextStyle(color: Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD), Color(0xFF1E3A8A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_queue,
              color: Colors.white.withOpacity(0.8),
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Weather App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Search for a city to get started or enable location services.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _toggleSearch();
              },
              icon: const Icon(Icons.search, color: Colors.blueAccent),
              label: const Text(
                'Search City',
                style: TextStyle(color: Colors.blueAccent),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
