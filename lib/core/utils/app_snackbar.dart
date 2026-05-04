import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSuccess(
    BuildContext context, 
    String message, {
    String title = 'Berhasil!',
    String? buttonLabel,
    VoidCallback? onButtonPressed,
  }) {
    _showCustomNotification(
      context,
      title: title,
      message: message,
      imagePath: 'assets/images/succes.png',
      buttonLabel: buttonLabel ?? 'Oke',
      onButtonPressed: onButtonPressed,
      isError: false,
    );
  }

  static void showError(
    BuildContext context, 
    String message, {
    String title = 'Ups, Terjadi Kesalahan',
    String? buttonLabel,
    VoidCallback? onButtonPressed,
  }) {
    _showCustomNotification(
      context,
      title: title,
      message: message,
      imagePath: 'assets/images/lostconnection.png',
      buttonLabel: buttonLabel ?? 'Tutup',
      onButtonPressed: onButtonPressed,
      isError: true,
    );
  }

  static void showInfo(
    BuildContext context, 
    String message, {
    String title = 'Informasi',
    String? buttonLabel,
    VoidCallback? onButtonPressed,
  }) {
    _showCustomNotification(
      context,
      title: title,
      message: message,
      imagePath: 'assets/images/lostconnection.png', // Fallback
      buttonLabel: buttonLabel ?? 'Mengerti',
      onButtonPressed: onButtonPressed,
      isError: false,
    );
  }

  static void _showCustomNotification(
    BuildContext context, {
    required String title,
    required String message,
    required String imagePath,
    required String buttonLabel,
    VoidCallback? onButtonPressed,
    required bool isError,
  }) {
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(left: 32, right: 32, bottom: 180),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                // Illustration
                Image.asset(
                  imagePath,
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      size: 80,
                      color: isError ? Colors.red : Colors.green,
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withValues(alpha: 0.6),
                      fontFamily: 'Inter',
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onButtonPressed != null) {
                          onButtonPressed();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isError ? Colors.red.shade400 : const Color(0xFF32C74F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      child: Text(buttonLabel),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}