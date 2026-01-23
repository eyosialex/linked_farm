
import 'soil_model.dart';

enum GrowthStage { germination, vegetative, flowering, fruiting, harvest }

class Crop {
  final String name;
  final List<SoilType> preferredSoils;
  final int totalGrowthDays;
  final double waterDemand; // Daily water requirement index
  final double nutrientDemand;
  final String description;

  const Crop({
    required this.name,
    required this.preferredSoils,
    required this.totalGrowthDays,
    required this.waterDemand,
    required this.nutrientDemand,
    required this.description,
  });

  static List<Crop> get allCrops => [
    const Crop(
      name: 'Maize',
      preferredSoils: [SoilType.loamy, SoilType.silt],
      totalGrowthDays: 10,
      waterDemand: 0.6,
      nutrientDemand: 0.7,
      description: 'A versatile crop that thrives in well-drained, fertile soil.',
    ),
    const Crop(
      name: 'Rice',
      preferredSoils: [SoilType.clay, SoilType.silt],
      totalGrowthDays: 12,
      waterDemand: 0.9,
      nutrientDemand: 0.6,
      description: 'Consumes a lot of water. Grows best in clay soils that retain moisture.',
    ),
    const Crop(
      name: 'Tomato',
      preferredSoils: [SoilType.loamy, SoilType.sandy],
      totalGrowthDays: 8,
      waterDemand: 0.5,
      nutrientDemand: 0.8,
      description: 'Needs balanced moisture and high nutrients for best yield.',
    ),
    const Crop(
      name: 'Potato',
      preferredSoils: [SoilType.sandy, SoilType.loamy],
      totalGrowthDays: 9,
      waterDemand: 0.4,
      nutrientDemand: 0.5,
      description: 'Grows well in loose, sandy soil that allows tubers to expand.',
    ),
  ];
}
