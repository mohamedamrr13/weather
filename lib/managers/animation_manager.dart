import 'package:flutter/material.dart';

class AnimationManager {
  late AnimationController fadeController;
  late AnimationController slideController;
  late AnimationController searchController;
  late AnimationController appBarController;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> searchAnimation;
  late Animation<Offset> appBarSlideAnimation;

  void initialize(TickerProvider vsync) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    appBarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
      value: 1.0, // Start visible
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeInOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
    );

    searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: searchController, curve: Curves.easeInOut),
    );

    appBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: appBarController, curve: Curves.easeInOut),
    );
  }

  void playFadeIn() {
    fadeController.forward();
  }

  void playSlideIn() {
    slideController.forward();
  }

  void showSearch() {
    searchController.forward();
  }

  void hideSearch() {
    searchController.reverse();
  }

  void showAppBar() {
    appBarController.forward();
  }

  void hideAppBar() {
    appBarController.reverse();
  }

  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    searchController.dispose();
    appBarController.dispose();
  }
}
