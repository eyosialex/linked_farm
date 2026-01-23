
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/soil_model.dart';
import '../models/crop_model.dart';
import '../models/game_state.dart';
import 'preparation_minigame.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  Soil? selectedSoil;
  Crop? selectedCrop;
  int step = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(step == 1 ? "Choose Your Soil" : "Select Your Crop")),
      body: step == 1 ? _buildSoilSelection() : _buildCropSelection(),
    );
  }

  Widget _buildSoilSelection() {
    final soils = Soil.allSoils;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: soils.length,
      itemBuilder: (context, index) {
        final soil = soils[index];
        return Card(
          elevation: selectedSoil == soil ? 8 : 2,
          color: selectedSoil == soil ? Colors.green[50] : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selectedSoil == soil ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            title: Text(soil.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(soil.description),
            trailing: selectedSoil == soil ? const Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: () {
              setState(() {
                selectedSoil = soil;
                step = 2;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildCropSelection() {
    if (selectedSoil == null) return const Center(child: Text("Please select soil first"));

    final compatibleCrops = Crop.allCrops.where((c) => c.preferredSoils.contains(selectedSoil!.type)).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Based on your ${selectedSoil!.name} soil, these crops are recommended:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: compatibleCrops.length,
            itemBuilder: (context, index) {
              final crop = compatibleCrops[index];
              return Card(
                elevation: selectedCrop == crop ? 8 : 2,
                color: selectedCrop == crop ? Colors.blue[50] : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selectedCrop == crop ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  title: Text(crop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${crop.description}\nTakes ~${crop.totalGrowthDays} days to harvest."),
                  isThreeLine: true,
                  onTap: () {
                    setState(() {
                      selectedCrop = crop;
                    });
                    _startGame();
                  },
                ),
              );
            },
          ),
        ),
        TextButton(
          onPressed: () => setState(() => step = 1),
          child: const Text("Go Back to Soil Selection"),
        ),
      ],
    );
  }

  void _startGame() {
    if (selectedSoil != null && selectedCrop != null) {
      Provider.of<GameState>(context, listen: false).startNewGame(selectedSoil!, selectedCrop!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PreparationScreen()),
      );
    }
  }
}
