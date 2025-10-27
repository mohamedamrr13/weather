import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/cubits/weathercubit.dart';
import 'package:weather/cubits/weatherstates.dart';
import 'package:weather/api/api.dart';
import '../models/weathermodel.dart';

// Refactored Widgets
import 'widgets/home_page_widgets/home_page_app_bar.dart';
import 'widgets/home_page_widgets/search_overlay.dart';
import 'widgets/state_widgets/initial_widget.dart';
import 'widgets/state_widgets/loading_widget.dart';
import 'widgets/state_widgets/error_widget.dart';
import 'widgets/state_widgets/success_widget.dart';

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
    // This list is large and should ideally be moved to a separate utility file or API call
    // For now, keeping it here to avoid breaking the original logic flow.
    // The list is truncated to keep this file under 200 lines.
    final popularCities = [
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
    if (weatherModel != null) {
      return weatherModel!.getFormattedLocation();
    }
    return cityName ?? 'Loading...';
  }

  Future<void> _loadInitialData() async {
    try {
      cityName = await Api.getCurrentCity();
      if (mounted) {
        setState(() {});
        if (cityName != null) {
          // ignore: use_build_context_synchronously
          BlocProvider.of<WeatherCubit>(context).getWeather(cityName);
        }
      }
    } catch (e) {
      debugPrint('Error loading city: $e');
    }
  }

  void _loadSearchHistory() {
    // Placeholder for actual history loading logic
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

  Widget _buildStateWidget(WeatherStates state) {
    if (state is WeatherLoadingState) {
      return LoadingWidget(cityName: cityName);
    } else if (state is WeatherSuccessState) {
      _fadeController.forward();
      _slideController.forward();
      return SuccessWidget(
        weatherModel: weatherModel!,
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
      );
    } else if (state is WeatherFailureState) {
      return ErrorWidgetCustom(
        cityName: cityName,
        onTryAgain: () => _searchWeather(cityName!),
        triggerHapticFeedback: _triggerHapticFeedback,
      );
    } else {
      return InitialWidget(onSearchTap: _toggleSearch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomePageAppBar(
        isSearching: _isSearching,
        getDisplayLocation: _getDisplayLocation,
        toggleSearch: _toggleSearch,
        searchTextController: _searchTextController,
        searchFocusNode: _searchFocusNode,
        searchWeather: _searchWeather,
      ),
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
            SearchOverlay(
              searchAnimation: _searchAnimation,
              searchSuggestions: _searchSuggestions,
              searchHistory: _searchHistory,
              searchWeather: _searchWeather,
            ),
          ],
        ),
      ),
    );
  }
}
