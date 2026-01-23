
import 'package:flutter/material.dart';
import 'soil_model.dart';
import 'crop_model.dart';
import '../logic/game_engine.dart';

class GameState extends ChangeNotifier {
  Soil? _selectedSoil;
  Crop? _selectedCrop;
  int _currentDay = 0;
  double _soilMoisture = 0.5;
  double _soilNutrients = 0.5;
  double _growthProgress = 0.0;
  double _healthScore = 1.0;
  
  // New Reality Factors
  double _energy = 100.0;
  double _budget = 1000.0;
  double _soilReadiness = 0.0; // 0.0 to 1.0 (Plowing, Leveling progress)
  
  bool _isGameOver = false;
  List<String> _gameLog = [];
  final List<Map<String, dynamic>> _history = [];
  
  String _currentWeather = "Sunny";
  double _currentTemp = 25.0;

  // Getters
  Soil? get selectedSoil => _selectedSoil;
  Crop? get selectedCrop => _selectedCrop;
  int get currentDay => _currentDay;
  double get soilMoisture => _soilMoisture;
  double get soilNutrients => _soilNutrients;
  double get growthProgress => _growthProgress;
  double get healthScore => _healthScore;
  double get energy => _energy;
  double get budget => _budget;
  double get soilReadiness => _soilReadiness;
  bool get isGameOver => _isGameOver;
  List<String> get gameLog => _gameLog;
  List<Map<String, dynamic>> get history => _history;
  String get currentWeather => _currentWeather;
  double get currentTemp => _currentTemp;

  // Visual Getters for "Real World" feeling
  bool get isWilting => _soilMoisture < (_selectedCrop?.waterDemand ?? 0.5) * 0.4;
  Color get plantColor {
    if (_healthScore < 0.4) return Colors.brown[400]!;
    if (_healthScore < 0.7) return Colors.yellow[700]!;
    return Colors.green[600]!;
  }

  double get visualStage {
    if (_growthProgress < 20) return 1; // Seedling
    if (_growthProgress < 50) return 2; // Vegetative
    if (_growthProgress < 80) return 3; // Flowering
    return 4; // Mature
  }

  String get plantImagePath {
    if (visualStage == 1) return 'assets/game/seedling.png';
    if (visualStage == 2) return 'assets/game/vegetative.png';
    if (visualStage == 3) return 'assets/game/flowering.png';
    return 'assets/game/mature.png';
  }

  void startNewGame(Soil soil, Crop crop) {
    _selectedSoil = soil;
    _selectedCrop = crop;
    _currentDay = 1;
    _soilMoisture = soil.waterRetention;
    _soilNutrients = soil.nutrientRichness;
    _growthProgress = 0.0;
    _healthScore = 1.0;
    _energy = 100.0;
    _budget = 1000.0;
    _soilReadiness = 0.0;
    _isGameOver = false;
    _gameLog = ["Day 1: Started your farming journey in ${soil.name} soil."];
    _history.clear();
    _history.add({
      'day': 1,
      'growth': 0.0,
      'moisture': _soilMoisture,
      'nutrients': _soilNutrients,
      'health': _healthScore,
    });
    notifyListeners();
  }

  void nextDay() {
    if (_isGameOver || _selectedCrop == null || _selectedSoil == null) return;

    // Randomize weather
    _currentWeather = (DateTime.now().millisecond % 10 < 2) ? "Rainy" : "Sunny";
    _currentTemp = 22.0 + (DateTime.now().millisecond % 10);
    double rainfall = (_currentWeather == "Rainy") ? 5.0 : 0.0;

    final result = GameEngine.calculateDailyProgress(
      currentDay: _currentDay,
      crop: _selectedCrop!,
      soil: _selectedSoil!,
      moisture: _soilMoisture,
      nutrients: _soilNutrients,
      health: _healthScore,
      rainfall: rainfall,
      temp: _currentTemp,
    );

    _currentDay++;
    _soilMoisture = result.newMoisture;
    _soilNutrients = result.newNutrients;
    _growthProgress += result.growthIncrement;
    _healthScore = result.newHealth;

    _gameLog.insert(0, "Day $_currentDay: ${result.statusMessage} (Weather: $_currentWeather)");
    
    _history.add({
      'day': _currentDay,
      'growth': _growthProgress,
      'moisture': _soilMoisture,
      'nutrients': _soilNutrients,
      'health': _healthScore,
      'weather': _currentWeather,
    });

    // Daily energy recovery
    _energy = (_energy + 40.0).clamp(0.0, 100.0);

    if (_growthProgress >= 100.0 || _currentDay >= _selectedCrop!.totalGrowthDays * 2) {
      _isGameOver = true;
      _gameLog.insert(0, "Game Over: Harvest reached!");
    }

    notifyListeners();
  }

  void plow() {
    if (_energy >= 20) {
      _energy -= 20;
      _soilReadiness = (_soilReadiness + 0.34).clamp(0.0, 1.0);
      _gameLog.insert(0, "Day $_currentDay: You plowed the field plots.");
      notifyListeners();
    }
  }

  void levelSoil() {
    if (_energy >= 15) {
      _energy -= 15;
      _soilReadiness = (_soilReadiness + 0.2).clamp(0.0, 1.0);
      _gameLog.insert(0, "Day $_currentDay: You leveled the soil beds.");
      notifyListeners();
    }
  }

  void irrigate() {
    if (_energy >= 10) {
      _energy -= 10;
      _soilMoisture = (_soilMoisture + 0.3).clamp(0.0, 1.2);
      _gameLog.insert(0, "Day $_currentDay: You irrigated the field.");
      notifyListeners();
    }
  }

  void fertilize() {
    if (_energy >= 15) {
      _energy -= 15;
      _soilNutrients = (_soilNutrients + 0.2).clamp(0.0, 1.0);
      _gameLog.insert(0, "Day $_currentDay: You applied fertilizer.");
      notifyListeners();
    }
  }
}
