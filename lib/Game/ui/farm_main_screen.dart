
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'yield_results_screen.dart';
import '../../Services/gemini_service.dart';
import 'growth_journal_screen.dart';
import 'farming_report_screen.dart';
import 'dart:math';
import 'dart:ui';

class FarmMainScreen extends StatelessWidget {
  const FarmMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    if (gameState.isGameOver) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const YieldResultsScreen()),
        );
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background - Deep Green to Soil Brown Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F172A), // Deep Slate
                  Color(0xFF334155), // Mid Slate
                  Color(0xFF1E293B), // Dark Slate
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildWeatherSegment(gameState),
                _buildRiskDashboard(gameState),
                Expanded(child: _buildFieldSegment(gameState)),
                _buildSoilStatusSegment(context, gameState),
                _buildUnifiedBottomDock(context, gameState),
              ],
            ),
          ),

          // Rain Overlay (Particles)
          if (gameState.currentWeather == "Rainy")
            _buildRainOverlay(),
        ],
      ),
    );
  }

  Widget _buildWeatherSegment(GameState gameState) {
    final isRainy = gameState.currentWeather == "Rainy";
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isRainy ? Icons.water : Icons.wb_sunny,
                    color: isRainy ? Colors.blueAccent : Colors.orangeAccent,
                    size: 32,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${gameState.currentTemp.toStringAsFixed(1)}°C",
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isRainy ? "PREDICTED: 8mm RAIN" : "CLEAR SKIES",
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.amber, size: 16),
                    const SizedBox(width: 6),
                    Text("${gameState.energy.toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskDashboard(GameState gameState) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _riskMetric("PEST", gameState.pestRisk, Colors.redAccent),
          _riskMetric("fungal", gameState.diseaseRisk, Colors.orangeAccent),
          _riskMetric("WEEDS", gameState.weedPressure, Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _riskMetric(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          ),
        ),
        const SizedBox(height: 4),
        Text("${(value * 100).toInt()}%", style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFieldSegment(GameState gameState) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: _buildIsometricField(gameState),
      ),
    );
  }

  Widget _buildSoilStatusSegment(BuildContext context, GameState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("SOIL MOISTURE PROFILE", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              Text("${(gameState.soilMoisture * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: gameState.soilMoisture.clamp(0.0, 1.0),
              backgroundColor: Colors.white10,
              color: Colors.blueAccent,
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedBottomDock(BuildContext context, GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("DAY ${gameState.currentDay}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                  const Text("VEGETATIVE CYCLE", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FarmingReportScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.star, color: Colors.amber, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showSeasonalRoadmap(context, gameState),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.map, color: Colors.blueAccent, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Improved Advisor (Clickable for Deep Analysis)
          GestureDetector(
            onTap: () => _showGeminiAnalysis(context, gameState),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPredictiveAIAdvice(gameState),
                          style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                        ),
                        const SizedBox(height: 4),
                        const Text("Tap for Deep AI Analysis", style: TextStyle(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.purpleAccent, size: 16),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 25),
          
          // Action Buttons (Removed WATER, only FERTILIZE and PROCEED remain)
          Row(
            children: [
              Expanded(child: _actionBtn("FERTILIZE", Icons.science, Colors.orange, gameState.fertilize)),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: gameState.nextDay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("PROCEED TO NEXT DAY", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color.withOpacity(0.2)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getPredictiveAIAdvice(GameState gameState) {
    if (gameState.pestRisk > 0.4) return "Pest activity is increasing due to temperature and wind conditions.";
    if (gameState.soilMoisture < 0.4) return "Moisture levels are low. Hope for rain in the forecast soon!";
    if (gameState.currentWeather == "Rainy") return "Natural rainfall is replenishing the soil moisture profile.";
    return "Ecosystem is stable. Rain-dependent growth is within parameters.";
  }

  void _showGeminiAnalysis(BuildContext context, GameState gameState) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
    );

    final advice = await GeminiService.getFarmingAdvice(
      soilType: gameState.selectedSoil?.name ?? "Unknown",
      cropName: gameState.selectedCrop?.name ?? "Unknown",
      day: gameState.currentDay,
      moisture: gameState.soilMoisture,
      nutrients: gameState.soilNutrients,
      health: gameState.healthScore,
    );

    if (context.mounted) Navigator.pop(context);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purpleAccent),
              SizedBox(width: 10),
              Text("AI DEEP ANALYSIS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(advice, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("GOT IT", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRainOverlay() {
    return IgnorePointer(
      child: Stack(
        children: List.generate(30, (index) {
          final random = Random();
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: random.nextDouble() * 800,
            left: random.nextDouble() * 400,
            child: Container(
              width: 1,
              height: 20,
              color: Colors.blueAccent.withOpacity(0.2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIsometricField(GameState gameState) {
    final soilColor = Color.lerp(const Color(0xFF451A03), const Color(0xFF1C0A00), gameState.soilMoisture.clamp(0.0, 1.0));

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(-0.5)
        ..rotateZ(0.1),
      alignment: FractionalOffset.center,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: soilColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), offset: const Offset(20, 20), blurRadius: 40),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 4,
          padding: const EdgeInsets.all(20),
          children: List.generate(16, (index) {
            double growth = gameState.growthProgress / 100.0;
            return Center(
              child: AnimatedScale(
                scale: 0.2 + (0.8 * growth),
                duration: const Duration(milliseconds: 800),
                child: Icon(
                  gameState.plantIcon,
                  size: 40,
                  color: gameState.plantColor,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showSeasonalRoadmap(BuildContext context, GameState gameState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("MY CUSTOM LAND PLAN", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  IconButton(
                    onPressed: () => _showAddActivityDialog(context, gameState),
                    icon: const Icon(Icons.add_circle, color: Colors.blueAccent, size: 28),
                  ),
                ],
              ),
              const Text("Enter and track your daily/weekly farming tasks.", style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 25),
              Expanded(
                child: gameState.customActivities.isEmpty 
                  ? _buildEmptyPlanner()
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: gameState.customActivities.length,
                      itemBuilder: (context, index) {
                        final activity = gameState.customActivities[index];
                        return _buildCustomActivityCard(context, gameState, activity, index);
                      },
                    ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomActivityCard(BuildContext context, GameState gameState, Map<String, dynamic> activity, int index) {
    final type = activity['type'] as String;
    final isDone = activity['isCompleted'] ?? false;
    final color = type == 'daily' ? Colors.greenAccent : (type == 'weekly' ? Colors.orangeAccent : Colors.purpleAccent);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? Colors.greenAccent.withOpacity(0.02) : Colors.white.withOpacity(0.04), 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: isDone ? Colors.greenAccent.withOpacity(0.3) : color.withOpacity(0.2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  if (isDone) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: const Text("COMPLETED", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isDone,
                    activeColor: Colors.greenAccent,
                    onChanged: (_) => gameState.toggleActivityCompletion(index),
                  ),
                  IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent), onPressed: () => gameState.removeCustomActivity(index)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(activity['title'], style: TextStyle(color: isDone ? Colors.white38 : Colors.white, fontWeight: FontWeight.bold, fontSize: 15, decoration: isDone ? TextDecoration.lineThrough : null)),
          const SizedBox(height: 5),
          Text(activity['description'], style: TextStyle(color: isDone ? Colors.white24 : Colors.white70, fontSize: 13)),
          const SizedBox(height: 10),
          Text("Entered on Prophetic Day ${activity['day']}", style: TextStyle(color: Colors.white24, fontSize: 10)),
        ],
      ),
    );
  }

  void _showAddActivityDialog(BuildContext context, GameState gameState) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedType = 'daily';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text("ENTRY FOR MANUAL PLAN", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                dropdownColor: const Color(0xFF1E293B),
                value: selectedType,
                items: ['daily', 'weekly', 'monthly'].map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase(), style: const TextStyle(color: Colors.white)))).toList(),
                onChanged: (val) => setModalState(() => selectedType = val!),
              ),
              TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Task Title", labelStyle: TextStyle(color: Colors.white70))),
              TextField(controller: descController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Activity Detail", labelStyle: TextStyle(color: Colors.white70))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;
                gameState.addCustomActivity(selectedType, titleController.text, descController.text);
                Navigator.pop(context);
              },
              child: const Text("SAVE PLAN"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlanner() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 64, color: Colors.white12),
          const SizedBox(height: 15),
          const Text("Your Custom Plan is Empty", style: TextStyle(color: Colors.white38)),
          const Text("Add your own daily/weekly tasks here.", style: TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }
}
