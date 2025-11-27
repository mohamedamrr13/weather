import 'package:flutter/material.dart';

class SearchManager extends ChangeNotifier {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  bool _isSearching = false;
  List<String> _searchHistory = [];
  List<String> _searchSuggestions = [];

  final List<String> _popularCities = [
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

  bool get isSearching => _isSearching;
  List<String> get searchHistory => _searchHistory;
  List<String> get searchSuggestions => _searchSuggestions;

  void initialize() {
    _loadSearchHistory();
    _setupSearchListener();
  }

  void _setupSearchListener() {
    searchTextController.addListener(() {
      final query = searchTextController.text;
      if (query.length > 2) {
        _generateSearchSuggestions(query);
      } else {
        _searchSuggestions = [];
      }
    });
  }

  void _generateSearchSuggestions(String query) {
    _searchSuggestions = _popularCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();
    notifyListeners();
  }

  void _loadSearchHistory() {
    _searchHistory = [];
    // TODO: Load from persistent storage
  }

  void saveToSearchHistory(String city) {
    _searchHistory.removeWhere(
      (item) => item.toLowerCase() == city.toLowerCase(),
    );
    _searchHistory.insert(0, city);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.take(10).toList();
    }
    notifyListeners();
    // TODO: Save to persistent storage
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void openSearch() {
    _isSearching = true;
    notifyListeners();
  }

  void closeSearch() {
    _isSearching = false;
    searchTextController.clear();
    searchFocusNode.unfocus();
    _searchSuggestions = [];
    notifyListeners();
  }

  void clearSuggestions() {
    _searchSuggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }
}
