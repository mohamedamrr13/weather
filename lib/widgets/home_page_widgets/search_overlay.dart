import 'package:flutter/material.dart';

class SearchOverlay extends StatelessWidget {
  final Animation<double> searchAnimation;
  final List<String> searchSuggestions;
  final List<String> searchHistory;
  final void Function(String) searchWeather;

  const SearchOverlay({
    super.key,
    required this.searchAnimation,
    required this.searchSuggestions,
    required this.searchHistory,
    required this.searchWeather,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: searchAnimation,
      builder: (context, child) {
        if (searchAnimation.value == 0) return const SizedBox.shrink();

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
                    if (searchSuggestions.isNotEmpty) ...[
                      _buildHeader('Suggestions'),
                      ...searchSuggestions.map(
                        (city) => _buildSearchItem(
                          city,
                          Icons.location_city,
                          () => searchWeather(city),
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                    if (searchHistory.isNotEmpty) ...[
                      _buildHeader('Recent Searches'),
                      ...searchHistory.map(
                        (city) => _buildSearchItem(
                          city,
                          Icons.history,
                          () => searchWeather(city),
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

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
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
}
