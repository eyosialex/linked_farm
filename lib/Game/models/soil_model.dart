
enum SoilType { clay, sandy, loamy, silt }

class Soil {
  final SoilType type;
  final String name;
  final double waterRetention; // 0.0 to 1.0
  final double nutrientRichness; // 0.0 to 1.0
  final double drainage; // 0.0 to 1.0
  final double phLevel; // 4.0 to 9.0
  final double organicMatter; // 0% to 10%
  final String description;

  const Soil({
    required this.type,
    required this.name,
    required this.waterRetention,
    required this.nutrientRichness,
    required this.drainage,
    required this.phLevel,
    required this.organicMatter,
    required this.description,
  });

  static List<Soil> get allSoils => [
    const Soil(
      type: SoilType.clay,
      name: 'Clay',
      waterRetention: 0.9,
      nutrientRichness: 0.8,
      drainage: 0.2,
      phLevel: 6.5,
      organicMatter: 4.5,
      description: 'Heavy soil that holds water well but has poor drainage. Rich in minerals.',
    ),
    const Soil(
      type: SoilType.sandy,
      name: 'Sandy',
      waterRetention: 0.2,
      nutrientRichness: 0.3,
      drainage: 0.9,
      phLevel: 5.8,
      organicMatter: 1.5,
      description: 'Light soil that drains quickly but struggles to hold nutrients. Needs organic matter.',
    ),
    const Soil(
      type: SoilType.loamy,
      name: 'Loamy',
      waterRetention: 0.6,
      nutrientRichness: 0.9,
      drainage: 0.6,
      phLevel: 6.8,
      organicMatter: 6.5,
      description: 'The ideal balance of sand, silt, and clay. Rich in nutrients and perfect for most crops.',
    ),
    const Soil(
      type: SoilType.silt,
      name: 'Silt',
      waterRetention: 0.7,
      nutrientRichness: 0.7,
      drainage: 0.4,
      phLevel: 6.2,
      organicMatter: 3.5,
      description: 'Fine particles that hold moisture well and are quite fertile. Prone to erosion.',
    ),
  ];
}
