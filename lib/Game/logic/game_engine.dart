
import '../models/crop_model.dart';
import '../models/soil_model.dart';

class CalculationResult {
  final double growthIncrement;
  final double newMoisture;
  final double newNutrients;
  final double newHealth;
  final String statusMessage;

  CalculationResult({
    required this.growthIncrement,
    required this.newMoisture,
    required this.newNutrients,
    required this.newHealth,
    required this.statusMessage,
  });
}

class GameEngine {
  static CalculationResult calculateDailyProgress({
    required int currentDay,
    required Crop crop,
    required Soil soil,
    required double moisture,
    required double nutrients,
    required double health,
    required double rainfall,
    required double temp,
  }) {
    // 1. Update moisture based on rainfall and evaporation
    double evaporation = (temp > 30) ? 0.2 : 0.1;
    double updatedMoisture = (moisture + (rainfall / 10) - evaporation).clamp(0.0, 1.5);

    // 2. Check for Stress (Too dry or too wet)
    double stressPenalty = 0.0;
    String message = "The crop is growing.";

    if (updatedMoisture < crop.waterDemand * 0.5) {
      stressPenalty = 0.1;
      message = "Crop is wilting due to lack of water!";
    } else if (updatedMoisture > 1.1) {
      stressPenalty = 0.05;
      message = "Soil is waterlogged! Risk of root rot.";
    }

    if (nutrients < crop.nutrientDemand * 0.5) {
      stressPenalty += 0.05;
      message = "Crop looks yellow; needs more nutrients.";
    }

    // 3. Growth Calculation
    // Base growth = 100 / totalDays
    double baseGrowth = 100 / crop.totalGrowthDays;
    
    // Efficiency factors
    double moistureFactor = 1.0 - (updatedMoisture - crop.waterDemand).abs();
    double nutrientFactor = nutrients / crop.nutrientDemand;
    
    double totalFactor = (moistureFactor * 0.5 + nutrientFactor * 0.5).clamp(0.2, 1.2);
    double growthIncrement = baseGrowth * totalFactor * health;

    // 4. Update Health
    double updatedHealth = (health - stressPenalty).clamp(0.0, 1.0);

    // 5. Update Nutrients (Crop consumes nutrients)
    double updatedNutrients = (nutrients - (crop.nutrientDemand * 0.05)).clamp(0.0, 1.0);

    return CalculationResult(
      growthIncrement: growthIncrement,
      newMoisture: updatedMoisture,
      newNutrients: updatedNutrients,
      newHealth: updatedHealth,
      statusMessage: message,
    );
  }

  static double predictFinalYield(double currentHealth, double growthProgress, int daysRemaining) {
    // Simple prediction logic
    return currentHealth * 100; // Returns percentage of max potential
  }
}
