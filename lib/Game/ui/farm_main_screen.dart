
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'yield_results_screen.dart';
import '../../Services/gemini_service.dart';
import 'growth_journal_screen.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF001F3F), // Deep Night/Sky Blue
                  Color(0xFF3D9970), // Lush Green
                  Color(0xFF85144b), // Soil/Sunset Hue
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildWeatherSegment(gameState),
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
                    isRainy ? Icons.cloudy_snowing : Icons.wb_sunny,
                    color: isRainy ? Colors.blueAccent : Colors.amber,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gameState.currentWeather.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        isRainy ? "STORM INCOMING" : "OPTIMAL SUNLIGHT",
                        style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.yellowAccent, size: 14),
                    const SizedBox(width: 4),
                    Text("${gameState.energy}%", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldSegment(GameState gameState) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: _buildIsometricField(gameState),
    );
  }

  Widget _buildSoilStatusSegment(BuildContext context, GameState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("SOIL MOISTURE", style: TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              Text("${(gameState.soilMoisture * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: MediaQuery.of(context).size.width * 0.8 * gameState.soilMoisture.clamp(0.0, 1.0),
                height: 14,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.blue, Colors.cyanAccent]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.cyanAccent.withOpacity(0.4), blurRadius: 10, spreadRadius: 1),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedBottomDock(BuildContext context, GameState gameState) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                      const Text("CURRENT PHASE", style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1)),
                      Text("DAY ${gameState.currentDay}", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 1)),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GrowthJournalScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                      child: const Icon(Icons.menu_book, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // AI Advisor Text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getDynamicAdvisorText(gameState),
                        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(child: _actionBtn("WATER", Icons.water_drop, Colors.blue, gameState.irrigate)),
                  const SizedBox(width: 12),
                  Expanded(child: _actionBtn("FERTIL", Icons.science, Colors.orange, gameState.fertilize)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: gameState.nextDay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: const Text("NEXT DAY", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13, letterSpacing: 1)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildRainOverlay() {
    return IgnorePointer(
      child: Stack(
        children: List.generate(50, (index) {
          final random = Random();
          return AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: random.nextDouble() * 800,
            left: random.nextDouble() * 400,
            child: Container(
              width: 1,
              height: 15,
              color: Colors.white.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }

  void _showAIAdvice(BuildContext context, GameState gameState) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
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
          backgroundColor: Colors.grey[900],
          title: const Text("Gemini AI Prediction", style: TextStyle(color: Colors.purpleAccent)),
          content: Text(advice, style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("GOT IT"))
          ],
        ),
      );
    }
  }

  void _showDailySummary(BuildContext context, GameState gameState) {
    if (gameState.history.isEmpty) return;
    final lastDay = gameState.history.last;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("DAY ${lastDay['day']} SUMMARY", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow("Growth", "${lastDay['growth'].toStringAsFixed(1)}%"),
            _summaryRow("Moisture", "${(lastDay['moisture'] * 100).toInt()}%"),
            _summaryRow("Health", "${(lastDay['health'] * 100).toInt()}%"),
            const SizedBox(height: 10),
            const Text("The plant continues its journey!", style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("GOT IT")),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildIsometricField(GameState gameState) {
    final soilColor = Color.lerp(Colors.brown[400], Colors.brown[900], gameState.soilMoisture.clamp(0.0, 1.0));

    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(0.8)
          ..rotateZ(-0.6),
        alignment: FractionalOffset.center,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: soilColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(10, 10),
                blurRadius: 20,
              ),
            ],
            border: Border.all(color: Colors.brown[800]!, width: 3),
          ),
          child: GridView.count(
            crossAxisCount: 5,
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(25, (index) {
              double growth = gameState.growthProgress / 100.0;
              
              return Center(
                child: AnimatedScale(
                  scale: 0.5 + (0.5 * growth),
                  duration: const Duration(milliseconds: 500),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Subtile Shadow for depth
                      Container(
                        width: 15,
                        height: 5,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      
                      // Realistic Plant Image
                      Transform.rotate(
                        angle: gameState.isWilting ? 0.3 : 0.0,
                        child: Image.asset(
                          gameState.plantImagePath,
                          width: 30 + (20 * growth),
                          height: 30 + (20 * growth),
                          // Apply a subtle health-based tint if needed (otherwise omit for full realism)
                          color: gameState.healthScore < 0.6 ? Colors.yellow.withOpacity(0.2) : null,
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  String _getDynamicAdvisorText(GameState gameState) {
    if (gameState.isWilting) return "The soil is bone dry! Water those plants immediately!";
    if (gameState.healthScore < 0.6) return "The leaves are looking pale. Maybe some fertilizer?";
    if (gameState.currentWeather == "Rainy") return "The rain is good for the soil. Saves us some work!";
    return "Everything looks steady. Keep an eye on the moisture ring.";
  }
}
