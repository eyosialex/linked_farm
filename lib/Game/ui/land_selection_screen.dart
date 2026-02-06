import 'package:linkedfarm/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/farm_persistence_service.dart';
import '../models/game_state.dart';
import 'setup_screens.dart';
import 'farm_main_screen.dart';

import 'package:linkedfarm/Widgets/voice_guide_button.dart';

class MyLandsScreen extends StatelessWidget {
  const MyLandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final persistence = FarmPersistenceService();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(l10n.myLandsProfile, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          VoiceGuideButton(
            messages: [
              l10n.myLandsProfile,
              l10n.startAddingPlot
            ],
            isDark: true,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<UserLand>>(
        stream: persistence.streamUserLands(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final lands = snapshot.data ?? [];

          if (lands.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: lands.length,
            itemBuilder: (context, index) {
              final land = lands[index];
              return _buildLandCard(context, land);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLandDialog(context),
        label: Text(l10n.registerNewLand, style: const TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_location_alt),
        backgroundColor: Colors.green[800],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.landscape_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(l10n.noLandsRegistered, style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(l10n.startAddingPlot, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLandCard(BuildContext context, UserLand land) {
    final isRunning = land.activeCrop != null && land.currentDay < 5 && land.growthProgress < 100;

    return GestureDetector(
      onTap: () async {
        final gameState = Provider.of<GameState>(context, listen: false);
        await gameState.loadFromLand(land);
        
        if (land.activeCrop == null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SetupScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FarmMainScreen()));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, spreadRadius: 2)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(15)),
              child: Icon(Icons.location_on, color: Colors.green[800], size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(land.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("${land.size} ${AppLocalizations.of(context)!.hectares} | ${land.soilType}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 10),
                  if (isRunning)
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.green[700], size: 14),
                        const SizedBox(width: 5),
                        Text("${land.activeCrop} - ${AppLocalizations.of(context)!.dayLabel(land.currentDay)}", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    )
                  else
                    Text(land.activeCrop == null ? AppLocalizations.of(context)!.readyPlanting : AppLocalizations.of(context)!.cycleCompleted, 
                      style: TextStyle(color: land.activeCrop == null ? Colors.orange : Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showAddLandDialog(BuildContext context) {
    final nameController = TextEditingController();
    final sizeController = TextEditingController();
    String selectedSoil = "Loamy";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final l10n = AppLocalizations.of(context)!;
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.registerNewLand, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: nameController, decoration: InputDecoration(labelText: l10n.landNameHint)),
                const SizedBox(height: 15),
                TextField(controller: sizeController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.sizeHectares)),
                const SizedBox(height: 20),
                Text(l10n.soilType, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedSoil,
                  items: ["Loamy", "Silt", "Clay", "Sandy"].map((s) {
                    String label = s == "Loamy" ? l10n.loamy : (s == "Silt" ? l10n.silt : (s == "Clay" ? l10n.clay : l10n.sandy));
                    return DropdownMenuItem(value: s, child: Text(label));
                  }).toList(),
                  onChanged: (val) => setModalState(() => selectedSoil = val!),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || sizeController.text.isEmpty) return;
                    
                    final newLand = UserLand(
                      id: "", // Auto-generated by Firestore
                      name: nameController.text,
                      size: double.tryParse(sizeController.text) ?? 1.0,
                      soilType: selectedSoil,
                      updatedAt: DateTime.now(),
                    );

                    await FarmPersistenceService().saveLand(newLand);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(l10n.saveLand, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
