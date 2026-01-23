
import '../models/crop_model.dart';
import '../models/soil_model.dart';

class CalculationResult {
  final double growthIncrement;
  final double newMoisture;
  final double newNutrients;
  final double newHealth;
  final double pestRisk;
  final double diseaseRisk;
  final double weedPressure;
  final String statusMessage;

  CalculationResult({
    required this.growthIncrement,
    required this.newMoisture,
    required this.newNutrients,
    required this.newHealth,
    required this.pestRisk,
    required this.diseaseRisk,
    required this.weedPressure,
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
    required double windSpeed,
  }) {
    // 1. Update moisture based on rainfall, evaporation, and wind (wind increases evaporation)
    double windEff = (windSpeed > 5) ? 0.05 : 0.0;
    double evaporation = (temp > 30) ? 0.25 + windEff : 0.15 + windEff;
    double updatedMoisture = (moisture + (rainfall / 12) - evaporation).clamp(0.0, 1.5);

    // 2. Risk Calculations (Advanced Rule-Based Agronomy)
    
    // Pest Risk: High heat and stagnant air (low wind) favors local pests. 
    // High wind can carry migratory pests like locusts.
    double pestRisk = 0.1;
    if (temp > 28 && windSpeed < 3) pestRisk += 0.3; // Localized breeding
    if (windSpeed > 10) pestRisk += 0.25; // Migratory pests
    if (crop.pestSensitivity == Sensitivity.high) pestRisk *= 1.4;
    pestRisk = pestRisk.clamp(0.0, 1.0);
    
    // Disease Risk: High moisture + Low wind (poor aeration) = Bacterial/Fungal growth
    double diseaseRisk = 0.05;
    if (updatedMoisture > 0.9 && windSpeed < 2) diseaseRisk += 0.4;
    if (soil.type == SoilType.clay) diseaseRisk += 0.1; // Clay holds moisture longer
    diseaseRisk = diseaseRisk.clamp(0.0, 1.0);

    // Weed Pressure: High moisture + Loamy/Silt soil + Wind (seed dispersal)
    double weedPressure = 0.05;
    if (updatedMoisture > 0.5) weedPressure += 0.2;
    if (windSpeed > 7) weedPressure += 0.15;
    if (soil.type == SoilType.loamy || soil.type == SoilType.silt) weedPressure += 0.1;
    weedPressure = weedPressure.clamp(0.0, 1.0);

    // 3. Stress & Penalty
    double stressPenalty = 0.0;
    List<String> conditions = [];

    if (soil.phLevel < crop.minPh || soil.phLevel > crop.maxPh) {
      stressPenalty += 0.08;
      conditions.add("pH Mismatch");
    }
    if (updatedMoisture < crop.waterDemand * 0.4) {
      stressPenalty += 0.15;
      conditions.add("Water Stress");
    }
    if (windSpeed > 15) {
      stressPenalty += 0.1;
      conditions.add("Wind Damage");
    }

    String message = conditions.isEmpty ? "Crop is thriving." : "Warning: ${conditions.join(', ')} detected.";

    // 4. Growth Calculation
    double baseGrowth = 100 / crop.totalGrowthDays;
    
    // Efficiency factors
    double moistureFactor = 1.0 - (updatedMoisture - crop.waterDemand).abs();
    double nutrientFactor = nutrients / crop.nutrientDemand;
    double tempFactor = (temp >= crop.optimalTempMin && temp <= crop.optimalTempMax) ? 1.0 : 0.7;
    
    double totalFactor = (moistureFactor * 0.4 + nutrientFactor * 0.4 + tempFactor * 0.2).clamp(0.1, 1.1);
    double growthIncrement = baseGrowth * totalFactor * health;

    // 5. Update Health
    double updatedHealth = (health - stressPenalty - (pestRisk * 0.05)).clamp(0.0, 1.0);

    // 6. Update Nutrients
    double updatedNutrients = (nutrients - (crop.nutrientDemand * 0.04)).clamp(0.0, 1.0);

    return CalculationResult(
      growthIncrement: growthIncrement,
      newMoisture: updatedMoisture,
      newNutrients: updatedNutrients,
      newHealth: updatedHealth,
      pestRisk: pestRisk,
      diseaseRisk: diseaseRisk,
      weedPressure: weedPressure,
      statusMessage: message,
    );
  }
  static double humidity(double temp) => 60.0 + (temp > 25 ? 10 : 0);
}
