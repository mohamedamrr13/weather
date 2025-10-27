import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String? cityName;
  final VoidCallback onTryAgain;
  final VoidCallback triggerHapticFeedback;

  const ErrorWidgetCustom({
    super.key,
    this.cityName,
    required this.onTryAgain,
    required this.triggerHapticFeedback,
  });

  @override
  Widget build(BuildContext context) {
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
                triggerHapticFeedback();
                onTryAgain();
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
}
