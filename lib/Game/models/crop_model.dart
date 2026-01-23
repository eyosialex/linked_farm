import 'soil_model.dart';

enum GrowthStage { germination, vegetative, flowering, fruiting, harvest }

enum Sensitivity { low, medium, high }

class Crop {
  final String name;
  final List<SoilType> preferredSoils;
  final int totalGrowthDays;
  final double waterDemand; // Daily water requirement index
  final double nutrientDemand;
  final double minPh;
  final double maxPh;
  final double optimalTempMin;
  final double optimalTempMax;
  final Sensitivity pestSensitivity;
  final String description;

  const Crop({
    required this.name,
    required this.preferredSoils,
    required this.totalGrowthDays,
    required this.waterDemand,
    required this.nutrientDemand,
    required this.minPh,
    required this.maxPh,
    required this.optimalTempMin,
    required this.optimalTempMax,
    required this.pestSensitivity,
    required this.description,
  });

  static List<Crop> get allCrops => [
    const Crop(
      name: 'Maize',
      preferredSoils: [SoilType.loamy, SoilType.silt],
      totalGrowthDays: 120, // 4 months
      waterDemand: 0.6,
      nutrientDemand: 0.7,
      minPh: 5.8,
      maxPh: 7.0,
      optimalTempMin: 18,
      optimalTempMax: 32,
      pestSensitivity: Sensitivity.high,
      description: 'A versatile crop that thrives in well-drained, fertile soil. Sensitive to Fall Armyworm.',
    ),
    const Crop(
      name: 'Rice',
      preferredSoils: [SoilType.clay, SoilType.silt],
      totalGrowthDays: 150, // 5 months
      waterDemand: 0.9,
      nutrientDemand: 0.6,
      minPh: 5.0,
      maxPh: 6.5,
      optimalTempMin: 20,
      optimalTempMax: 35,
      pestSensitivity: Sensitivity.medium,
      description: 'Consumes a lot of water. Grows best in clay soils that retain moisture.',
    ),
    const Crop(
      name: 'Tomato',
      preferredSoils: [SoilType.loamy, SoilType.sandy],
      totalGrowthDays: 90, // 3 months
      waterDemand: 0.5,
      nutrientDemand: 0.8,
      minPh: 6.0,
      maxPh: 7.0,
      optimalTempMin: 15,
      optimalTempMax: 30,
      pestSensitivity: Sensitivity.high,
      description: 'Needs balanced moisture and high nutrients. Prone to fungal diseases.',
    ),
    const Crop(
      name: 'Potato',
      preferredSoils: [SoilType.sandy, SoilType.loamy],
      totalGrowthDays: 100, // ~3.5 months
      waterDemand: 0.4,
      nutrientDemand: 0.5,
      minPh: 4.8,
      maxPh: 6.5,
      optimalTempMin: 15,
      optimalTempMax: 25,
      pestSensitivity: Sensitivity.medium,
      description: 'Grows well in loose, sandy soil that allows tubers to expand.',
    ),
  ];
}
