import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/game_state.dart';

class RatingReportScreen extends StatelessWidget {
  const RatingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Navy
      appBar: AppBar(
        title: const Text("SEASONAL RATING REPORT"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          const SizedBox(width: 8),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildYieldCard(gameState),
            const SizedBox(height: 30),
            _buildMetricTile("LAND PREPARATION", gameState.landPrepScore, Icons.landscape, Colors.brown),
            _buildMetricTile("CROP SELECTION", gameState.cropSelectionScore, Icons.psychology, Colors.green),
            _buildMetricTile("INPUT MANAGEMENT", gameState.inputManagementScore, Icons.opacity, Colors.orange),
            _buildMetricTile("PLANTING PRECISION", gameState.plantingTimeScore, Icons.timer, Colors.orange),
            const SizedBox(height: 40),
            _buildAIInsight(gameState),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("CLOSE REPORT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYieldCard(GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
           const Text("FINAL ESTIMATED YIELD", style: TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 2)),
           const SizedBox(height: 10),
           Text(
             "${(gameState.healthScore * gameState.landSize * 5).toStringAsFixed(1)} Tons",
             style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 10),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: List.generate(5, (i) => Icon(
               Icons.star, 
               color: i < (gameState.healthScore * 5).toInt() ? Colors.amber : Colors.white10,
               size: 24,
             )),
           ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, double score, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: score / 5.0,
                    backgroundColor: Colors.white10,
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Text(score.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildAIInsight(GameState gameState) {
    String insight = "Your land preparation was excellent. To improve yield next season, consider optimizing your planting date to match rain patterns better.";
    if (gameState.healthScore < 0.6) insight = "Significant moisture stress was detected. The AI suggests investing in better irrigation for this crop type.";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.orangeAccent),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              insight,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
