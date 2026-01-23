import 'package:flutter/material.dart';
import 'soil_model.dart';
import 'crop_model.dart';
import '../logic/game_engine.dart';
import '../../Services/weather_service.dart';
import '../../Services/farm_persistence_service.dart';

class GameState extends ChangeNotifier {
  final FarmPersistenceService _persistence = FarmPersistenceService();
  String? _currentLandId;
  String? _currentLandName;

  String? get currentLandId => _currentLandId;
  String? get currentLandName => _currentLandName;

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
  double _landSize = 1.0; // in hectares
  DateTime? _plantingDate;

  // AI & Risk Factors
  double _pestRisk = 0.0;
  double _diseaseRisk = 0.0;
  double _weedPressure = 0.0;

  // Activity Scores (0.0 to 5.0)
  double _landPrepScore = 0.0;
  double _cropSelectionScore = 0.0;
  double _plantingTimeScore = 0.0;
  double _inputManagementScore = 0.0;
  
  bool _isGameOver = false;
  List<String> _gameLog = [];
  List<Map<String, dynamic>> _customActivities = [];
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
  double get landSize => _landSize;
  DateTime? get plantingDate => _plantingDate;
  List<Map<String, dynamic>> get customActivities => _customActivities;

  double get pestRisk => _pestRisk;
  double get diseaseRisk => _diseaseRisk;
  double get weedPressure => _weedPressure;

  double get landPrepScore => _landPrepScore;
  double get cropSelectionScore => _cropSelectionScore;
  double get plantingTimeScore => _plantingTimeScore;
  double get inputManagementScore => _inputManagementScore;

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

  IconData get plantIcon {
    if (visualStage == 1) return Icons.eco_outlined; // Seedling
    if (visualStage == 2) return Icons.eco; // Vegetative
    if (visualStage == 3) return Icons.local_florist; // Flowering
    return Icons.agriculture; // Mature
  }

  void startNewGame(String landId, String landName, Soil soil, Crop crop, double size, DateTime date) {
    _currentLandId = landId;
    _currentLandName = landName;
    _selectedSoil = soil;
    _selectedCrop = crop;
    _landSize = size;
    _plantingDate = date;
    _currentDay = 1;
    _soilMoisture = soil.waterRetention;
    _soilNutrients = soil.nutrientRichness;
    _growthProgress = 0.0;
    _healthScore = 1.0;
    _energy = 100.0;
    _budget = 1000.0;
    _soilReadiness = 1.0;
    _landPrepScore = 5.0;
    
    // Initial AI Logic for Score
    _cropSelectionScore = (crop.preferredSoils.contains(soil.type)) ? 5.0 : 3.0;
    if (soil.phLevel < crop.minPh || soil.phLevel > crop.maxPh) {
      _cropSelectionScore -= 1.5;
    }

    _isGameOver = false;
    _customActivities = [];
    _gameLog = ["Day 1: Started your farming journey on ${size} ha of ${soil.name} soil."];
    _history.clear();
    _history.add({
      'day': 1,
      'growth': 0.0,
      'moisture': _soilMoisture,
      'nutrients': _soilNutrients,
      'health': _healthScore,
    });
    notifyListeners();
    _syncToFirestore();
  }

  void nextDay() {
    if (_isGameOver || _selectedCrop == null || _selectedSoil == null) return;

    // Get Weather from Service (Using Simulation as fallback for now)
    final weatherUpdate = WeatherService.getSimulatedWeather(_currentDay);
    
    _currentWeather = weatherUpdate.condition;
    _currentTemp = weatherUpdate.temp;
    double rainfall = weatherUpdate.rainfall;
    double windSpeed = weatherUpdate.windSpeed;

    final result = GameEngine.calculateDailyProgress(
      currentDay: _currentDay,
      crop: _selectedCrop!,
      soil: _selectedSoil!,
      moisture: _soilMoisture,
      nutrients: _soilNutrients,
      health: _healthScore,
      rainfall: rainfall,
      temp: _currentTemp,
      windSpeed: windSpeed,
    );

    _currentDay++;
    _soilMoisture = result.newMoisture;
    _soilNutrients = result.newNutrients;
    _growthProgress += result.growthIncrement;
    _healthScore = result.newHealth;
    
    // Update Risks from Engine
    _pestRisk = result.pestRisk;
    _diseaseRisk = result.diseaseRisk;
    _weedPressure = result.weedPressure;

    _gameLog.insert(0, "Day $_currentDay: ${result.statusMessage} (Temp: ${_currentTemp.toStringAsFixed(1)}°C)");
    
    _history.add({
      'day': _currentDay,
      'growth': _growthProgress,
      'moisture': _soilMoisture,
      'nutrients': _soilNutrients,
      'health': _healthScore,
      'weather': _currentWeather,
      'pestRisk': _pestRisk,
      'diseaseRisk': _diseaseRisk,
    });

    // Daily energy recovery
    _energy = (_energy + 35.0).clamp(0.0, 100.0);

    if (_growthProgress >= 100.0 || _currentDay >= 5) {
      _isGameOver = true;
      _gameLog.insert(0, "Complete: Your 5-day predictive window has concluded!");
    }

    notifyListeners();
    _syncToFirestore();
  }

  void plow() {
    if (_energy >= 10) {
      _energy -= 10;
      _soilReadiness = (_soilReadiness + 0.5).clamp(0.0, 1.0);
      _landPrepScore = (_soilReadiness * 5.0).clamp(0.0, 5.0);
      _gameLog.insert(0, "Day $_currentDay: You plowed the field plots.");
      notifyListeners();
      _syncToFirestore();
    }
  }

  void levelSoil() {
    if (_energy >= 10) {
      _energy -= 10;
      _soilReadiness = (_soilReadiness + 0.5).clamp(0.0, 1.0);
      _landPrepScore = (_soilReadiness * 5.0).clamp(0.0, 5.0);
      _gameLog.insert(0, "Day $_currentDay: You leveled the soil beds.");
      notifyListeners();
      _syncToFirestore();
    }
  }

  void irrigate() {
    // Manual irrigation is disabled in Rain-Only Farming mode. 
    // Data is pulled automatically from the Weather API precipitation field.
    _gameLog.insert(0, "Note: This is a rain-only farm. Manual watering is disabled.");
    notifyListeners();
  }

  void fertilize() {
    if (_energy >= 15) {
      _energy -= 15;
      _soilNutrients = (_soilNutrients + 0.2).clamp(0.0, 1.0);
      _inputManagementScore = (_inputManagementScore + 0.5).clamp(0.0, 5.0);
      _gameLog.insert(0, "Day $_currentDay: You applied organic fertilizer.");
      notifyListeners();
      _syncToFirestore();
    }
  }

  Future<void> loadFromLand(UserLand land) async {
    _currentLandId = land.id;
    _currentLandName = land.name;
    _landSize = land.size;
    
    _selectedSoil = Soil.allSoils.firstWhere((s) => s.name == land.soilType, orElse: () => Soil.allSoils.first);
    if (land.activeCrop != null) {
      _selectedCrop = Crop.allCrops.firstWhere((c) => c.name == land.activeCrop, orElse: () => Crop.allCrops.first);
    }
    
    _currentDay = land.currentDay;
    _growthProgress = land.growthProgress;
    _soilMoisture = land.moisture;
    _soilNutrients = land.nutrients;
    _healthScore = land.health;
    
    _isGameOver = (_currentDay >= 5 || _growthProgress >= 100.0);
    _customActivities = List<Map<String, dynamic>>.from(land.customActivities);
    _gameLog = ["Plot resumed: ${land.name}"];
    notifyListeners();
  }

  Future<void> _syncToFirestore() async {
    if (_currentLandId == null) return;
    
    final land = UserLand(
      id: _currentLandId!,
      name: _currentLandName ?? "My Plot",
      size: _landSize,
      soilType: _selectedSoil?.name ?? "Loamy",
      activeCrop: _selectedCrop?.name,
      currentDay: _currentDay,
      growthProgress: _growthProgress,
      moisture: _soilMoisture,
      nutrients: _soilNutrients,
      health: _healthScore,
      customActivities: _customActivities,
      updatedAt: DateTime.now(),
    );
    
    await _persistence.saveLand(land);
  }

  void addCustomActivity(String type, String title, String description) {
    _customActivities.add({
      'type': type, // 'daily', 'weekly', 'monthly'
      'title': title,
      'description': description,
      'isCompleted': false,
      'day': _currentDay,
      'timestamp': DateTime.now().toIso8601String(),
    });
    notifyListeners();
    _syncToFirestore();
  }

  void removeCustomActivity(int index) {
    if (index >= 0 && index < _customActivities.length) {
      _customActivities.removeAt(index);
      notifyListeners();
      _syncToFirestore();
    }
  }

  void toggleActivityCompletion(int index) {
    if (index >= 0 && index < _customActivities.length) {
      _customActivities[index]['isCompleted'] = !(_customActivities[index]['isCompleted'] ?? false);
      notifyListeners();
      _syncToFirestore();
    }
  }

  List<Map<String, dynamic>> get completedActivities => _customActivities.where((a) => a['isCompleted'] == true).toList();
}
