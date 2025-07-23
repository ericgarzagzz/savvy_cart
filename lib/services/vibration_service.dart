import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class VibrationService {
  static const VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  const VibrationService._internal();

  /// Subtle vibration for item check/uncheck actions
  /// Very light and quick for users walking around the supermarket
  Future<void> subtleCheckVibration() async {
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator != true) return;

      // Very short, subtle vibration - perfect for frequent actions
      await Vibration.vibrate(duration: 25);
    } catch (e) {
      // Fallback to lightest haptic available
      HapticFeedback.selectionClick();
    }
  }

  /// Celebration pattern: rapid taps → sustained vibration → final burst
  /// Mimics cheer and applause for major accomplishments
  Future<void> celebrationVibration() async {
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator != true) return;

      bool? hasCustomVibrationsSupport =
          await Vibration.hasCustomVibrationsSupport();

      if (hasCustomVibrationsSupport == true) {
        // Celebration pattern: rapid taps → sustained vibration → final burst
        await Vibration.vibrate(
          pattern: [
            0, // Start immediately
            50, // Quick tap 1
            30, // Short pause
            50, // Quick tap 2
            30, // Short pause
            50, // Quick tap 3
            100, // Slightly longer pause before sustained
            300, // Sustained vibration (climax)
            80, // Pause before final burst
            120, // Final burst
          ],
          intensities: [
            0, // No vibration at start
            180, // Medium intensity for taps
            0, // No vibration during pause
            180, // Medium intensity for taps
            0, // No vibration during pause
            180, // Medium intensity for taps
            0, // No vibration during pause
            255, // Strong intensity for sustained (climax)
            0, // No vibration during pause
            200, // Strong but slightly less for final burst
          ],
        );
      } else {
        // Fallback: simulate the pattern with simple vibrations
        await Vibration.vibrate(duration: 50); // Tap 1
        await Future.delayed(const Duration(milliseconds: 80));
        await Vibration.vibrate(duration: 50); // Tap 2
        await Future.delayed(const Duration(milliseconds: 80));
        await Vibration.vibrate(duration: 50); // Tap 3
        await Future.delayed(const Duration(milliseconds: 180));
        await Vibration.vibrate(duration: 300); // Sustained
        await Future.delayed(const Duration(milliseconds: 80));
        await Vibration.vibrate(duration: 120); // Final burst
      }
    } catch (e) {
      // Ultimate fallback to Flutter's haptics
      HapticFeedback.heavyImpact();
    }
  }
}
