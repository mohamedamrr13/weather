import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final String Function() getDisplayLocation;
  final VoidCallback toggleSearch;
  final TextEditingController searchTextController;
  final FocusNode searchFocusNode;
  final void Function(String) searchWeather;

  const HomePageAppBar({
    super.key,
    required this.isSearching,
    required this.getDisplayLocation,
    required this.toggleSearch,
    required this.searchTextController,
    required this.searchFocusNode,
    required this.searchWeather,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSearching
            ? _buildSearchBar(context)
            : Column(
                children: [
                  _buildLocationTitle(context),
                ],
              ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: Colors.white.withOpacity(0.8),
          ),
          onPressed: toggleSearch,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      key: const ValueKey('search_bar'),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        cursorColor: Colors.grey,
        controller: searchTextController,
        focusNode: searchFocusNode,
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
            onPressed: () => searchWeather(searchTextController.text),
          ),
        ),
        onSubmitted: searchWeather,
      ),
    );
  }

  Widget _buildLocationTitle(BuildContext context) {
    return Row(
      key: const ValueKey('location_title'),
      children: [
        Icon(Icons.location_on_outlined,
            color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            getDisplayLocation(),
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
