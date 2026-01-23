
enum SoilType { clay, sandy, loamy, silt }

class Soil {
  final SoilType type;
  final String name;
  final double waterRetention; // 0.0 to 1.0
  final double nutrientRichness; // 0.0 to 1.0
  final double drainage; // 0.0 to 1.0
  final String description;

  const Soil({
    required this.type,
    required this.name,
    required this.waterRetention,
    required this.nutrientRichness,
    required this.drainage,
    required this.description,
  });

  static List<Soil> get allSoils => [
    const Soil(
      type: SoilType.clay,
      name: 'Clay',
      waterRetention: 0.9,
      nutrientRichness: 0.8,
      drainage: 0.2,
      description: 'Heavy soil that holds water well but has poor drainage.',
    ),
    const Soil(
      type: SoilType.sandy,
      name: 'Sandy',
      waterRetention: 0.2,
      nutrientRichness: 0.3,
      drainage: 0.9,
      description: 'Light soil that drains quickly but struggles to hold nutrients.',
    ),
    const Soil(
      type: SoilType.loamy,
      name: 'Loamy',
      waterRetention: 0.6,
      nutrientRichness: 0.9,
      drainage: 0.6,
      description: 'The ideal balance of sand, silt, and clay. Rich in nutrients.',
    ),
    const Soil(
      type: SoilType.silt,
      name: 'Silt',
      waterRetention: 0.7,
      nutrientRichness: 0.7,
      drainage: 0.4,
      description: 'Fine particles that hold moisture well and are quite fertile.',
    ),
  ];
}
