
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/soil_model.dart';
import '../models/crop_model.dart';
import '../models/game_state.dart';
import 'farm_main_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  Soil? selectedSoil;
  Crop? selectedCrop;
  double landSize = 1.0;
  DateTime plantingDate = DateTime.now();
  int step = 1;

  @override
  Widget build(BuildContext context) {
    String title = "Setup Your Farm";
    if (step == 2) title = "Select Your Crop";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: step == 1 
            ? _buildLandDetails() 
            : _buildCropSelection(),
      ),
    );
  }

  Widget _buildLandDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("1. ENTER LAND DIMENSIONS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.square_foot, color: Colors.green),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Area (Hectares)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Slider(
                            value: landSize,
                            min: 0.5,
                            max: 10.0,
                            divisions: 19,
                            label: "${landSize.toStringAsFixed(1)} ha",
                            onChanged: (val) => setState(() => landSize = val),
                          ),
                        ],
                      ),
                    ),
                    Text("${landSize.toStringAsFixed(1)} ha", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 30),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: Colors.green),
                  title: const Text("Planned Planting Date", style: TextStyle(fontSize: 14)),
                  subtitle: Text("${plantingDate.day}/${plantingDate.month}/${plantingDate.year}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: plantingDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                      if (picked != null) setState(() => plantingDate = picked);
                    },
                    child: const Text("CHANGE"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => setState(() => step = 2),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("NEXT: SELECT CROP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilSelection() {
    final soils = Soil.allSoils;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("2. SELECT OR DETECT SOIL TYPE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: soils.length,
            itemBuilder: (context, index) {
              final soil = soils[index];
              final isSelected = selectedSoil == soil;
              return GestureDetector(
                onTap: () => setState(() => selectedSoil = soil),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: isSelected ? Colors.green : Colors.transparent, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.brown[50], shape: BoxShape.circle),
                        child: Icon(Icons.layers, color: Colors.brown[700]),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(soil.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(soil.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text("pH: ${soil.phLevel} | OM: ${soil.organicMatter}%", style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              TextButton(onPressed: () => setState(() => step = 1), child: const Text("BACK")),
              const Spacer(),
              ElevatedButton(
                onPressed: selectedSoil == null ? null : () => setState(() => step = 3),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text("NEXT"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropSelection() {
    // Use default Loamy soil - will be detected via sensors
    final defaultSoil = Soil.allSoils.firstWhere((s) => s.type == SoilType.loamy);
    if (selectedSoil == null) selectedSoil = defaultSoil;

    final compatibleCrops = Crop.allCrops.toList(); // Show all, highlight compatible

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text("2. SELECT CROP ALLOCATION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: compatibleCrops.length,
            itemBuilder: (context, index) {
              final crop = compatibleCrops[index];
              final isCompatible = crop.preferredSoils.contains(selectedSoil!.type);
              final isSelected = selectedCrop == crop;

              return GestureDetector(
                onTap: () => setState(() => selectedCrop = crop),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: isSelected ? Colors.green[700]! : Colors.transparent, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: isCompatible ? Colors.green[50] : Colors.red[50], shape: BoxShape.circle),
                        child: Icon(Icons.agriculture, color: isCompatible ? Colors.green : Colors.red),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(crop.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(width: 8),
                                if (isCompatible) const Icon(Icons.star, color: Colors.amber, size: 14),
                              ],
                            ),
                            Text(crop.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text("Demand: W:${crop.waterDemand} N:${crop.nutrientDemand} | Ph Range: ${crop.minPh}-${crop.maxPh}", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      if (isSelected) Icon(Icons.check_circle, color: Colors.green[700]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              TextButton(onPressed: () => setState(() => step = 1), child: const Text("BACK")),
              const Spacer(),
              ElevatedButton(
                onPressed: selectedCrop == null ? null : _startGame,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text("START MISSION"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startGame() {
    if (selectedSoil != null && selectedCrop != null) {
      final gameState = Provider.of<GameState>(context, listen: false);
      
      // Use the land already loaded into GameState from the Dashboard
      gameState.startNewGame(
        gameState.currentLandId ?? "temp_${DateTime.now().millisecondsSinceEpoch}", 
        gameState.currentLandName ?? "New Plot",
        selectedSoil!, 
        selectedCrop!, 
        landSize, 
        plantingDate
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FarmMainScreen()),
      );
    }
  }
}
