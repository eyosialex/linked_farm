import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temp;
  final String condition;
  final double rainfall; // mm for the day
  final double humidity;
  final double windSpeed; // m/s

  WeatherData({
    required this.temp,
    required this.condition,
    required this.rainfall,
    required this.humidity,
    required this.windSpeed,
  });
}

class WeatherService {
  // Recommendation: Use a secure way to store keys in production.
  static const String _apiKey = "9be8807936ca562d7a9246584e8584bf"; 
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5";

  static Future<WeatherData?> fetchCurrentWeather(double lat, double lon) async {
    if (_apiKey == "9be8807936ca562d7a9246584e8584bf" && _apiKey.startsWith("YOUR")) return null;

    try {
      final response = await http.get(Uri.parse(
        "$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric"
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData(
          temp: (data['main']['temp'] as num).toDouble(),
          condition: data['weather'][0]['main'],
          rainfall: (data['rain'] != null ? (data['rain']['1h'] ?? 0.0) : 0.0).toDouble(),
          humidity: (data['main']['humidity'] as num).toDouble(),
          windSpeed: (data['wind'] != null ? (data['wind']['speed'] ?? 0.0) : 0.0).toDouble(),
        );
      }
    } catch (e) {
      print("Weather Service Error: $e");
    }
    return null;
  }

  static Future<List<WeatherData>> fetch5DayForecast(double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
        "$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric"
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];
        // Pick one weather data point per day (every 8th item as it's 3-hour intervals)
        return list.where((item) => list.indexOf(item) % 8 == 0).map((item) {
          return WeatherData(
            temp: (item['main']['temp'] as num).toDouble(),
            condition: item['weather'][0]['main'],
            rainfall: (item['rain'] != null ? (item['rain']['3h'] ?? 0.0) : 0.0).toDouble(),
            humidity: (item['main']['humidity'] as num).toDouble(),
            windSpeed: (item['wind'] != null ? (item['wind']['speed'] ?? 0.0) : 0.0).toDouble(),
          );
        }).toList();
      }
    } catch (e) {
      print("Forecast Error: $e");
    }
    return [];
  }

  // Fallback high-fidelity simulation for offline/no-key usage
  static WeatherData getSimulatedWeather(int day) {
    // Deterministic simulation based on 'day' to keep game consistent
    final isRainy = (day * 7) % 10 < 3;
    return WeatherData(
      temp: 22.0 + (day % 10),
      condition: isRainy ? "Rainy" : "Sunny",
      rainfall: isRainy ? 8.5 : 0.0,
      humidity: isRainy ? 80.0 : 45.0,
      windSpeed: isRainy ? 5.2 : 2.1,
    );
  }
}
