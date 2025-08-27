
import 'package:flutter/material.dart';

import '../../view_model/homeVM.dart';

class WeatherUtils{
  static LinearGradient getBackgroundGradient(HomeVM homeVM,int selectedHourIndex) {
    final weather = homeVM.weather.value;
    final selectedHourData = getSelectedHourData(homeVM, selectedHourIndex);

    // Use selected hour data if available, otherwise use current weather
    final condition = selectedHourData?.condition?.text?.toLowerCase() ??
        weather.current?.condition?.text?.toLowerCase() ?? '';

    // Determine if it's day or night based on selected hour
    final isDay = selectedHourData?.isDay == 1 ;

    // Night time gradients
    if (!isDay) {
      if (condition.contains('rain') || condition.contains('drizzle')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1e3c72),
            Color(0xFF2a5298),
            Color(0xFF0f0f23),
          ],
        );
      } else if (condition.contains('cloud') || condition.contains('overcast')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF232526),
            Color(0xFF414345),
            Color(0xFF1a1a2e),
          ],
        );
      } else if (condition.contains('snow')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF36577C),
            Color(0xFF6B8CAE),
            Color(0xFF1e3c72),
          ],
        );
      } else {
        // Clear night
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0f0f23),
            Color(0xFF1e3c72),
            Color(0xFF2a5298),
          ],
        );
      }
    }
    // Day time gradients
    else {
      if (condition.contains('rain') || condition.contains('drizzle')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4B79A1),
            Color(0xFF283E51),
            Color(0xFF1e3c72),
          ],
        );
      } else if (condition.contains('cloud') || condition.contains('overcast')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF83a4d4),
            Color(0xFFb6fbff),
            Color(0xFF757F9A),
          ],
        );
      } else if (condition.contains('snow')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE6DEDD),
            Color(0xFF70C1B3),
            Color(0xFF36577C),
          ],
        );
      } else if (condition.contains('sunny') || condition.contains('clear')) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFDC830),
            Color(0xFFF37335),
            Color(0xFFFF8008),
          ],
        );
      } else {
        // Default day
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF74b9ff),
            Color(0xFF0984e3),
            Color(0xFF6c5ce7),
          ],
        );
      }
    }
  }
  static Color getTextColor(HomeVM homeVM, int selectedHourIndex) {
    final selectedHourData = getSelectedHourData(homeVM, selectedHourIndex);
    final condition = selectedHourData?.condition?.text?.toLowerCase() ?? '';
    final isDay = selectedHourData?.isDay == 1;

    if (!isDay || condition.contains('rain') || condition.contains('cloud')) {
      return Colors.white;
    }
    return condition.contains('sunny') || condition.contains('clear')
        ? Colors.white
        : Colors.white;
  }
  static dynamic getSelectedHourData(HomeVM homeVM, int selectedHourIndex) {
    if (homeVM.weather.value.forecast?.forecastday?.isNotEmpty == true) {
      return homeVM.weather.value.forecast!.forecastday![0].hour![selectedHourIndex];
    }
    return null;
  }
  static Color getHourItemColor(int index, String condition, int selectedIndex) {
    final isCurrentHour = selectedIndex == index;

    if (isCurrentHour) {
      if (condition.contains('rain')) return Colors.blue.withValues(alpha: .8);
      if (condition.contains('cloud')) return Colors.grey.withValues(alpha: .8);
      if (condition.contains('snow')) return Colors.lightBlue.withValues(alpha: .8);
      return Colors.orange.withValues(alpha: .8);
    }

    return Colors.white.withValues(alpha: .2);
  }
  static IconData getWeatherIcon(HomeVM homeVM, int selectedHourIndex) {
    final selectedHourData =getSelectedHourData(homeVM,selectedHourIndex);
    final condition = selectedHourData?.condition?.text?.toLowerCase() ??
        homeVM.weather.value.current?.condition?.text?.toLowerCase() ?? '';
    final isDay = selectedHourData?.isDay == 1 ;

    if (condition.contains('rain') || condition.contains('drizzle')) {
      return Icons.grain;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return Icons.cloud;
    } else if (condition.contains('snow')) {
      return Icons.ac_unit;
    } else if (condition.contains('sunny') || (condition.contains('clear') && isDay)) {
      return Icons.wb_sunny;
    } else if (condition.contains('clear') && !isDay) {
      return Icons.nights_stay;
    } else if (condition.contains('thunder')) {
      return Icons.flash_on;
    }

    return isDay ? Icons.wb_sunny : Icons.nights_stay;
  }





}