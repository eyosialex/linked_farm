import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedfarm/l10n/app_localizations.dart';
import 'package:linkedfarm/l10n/app_localizations.dart';
import '../models/game_state.dart';

class FarmingReportScreen extends StatelessWidget {
  const FarmingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final completed = gameState.completedActivities;
    final total = gameState.customActivities.length;
    final completionRate = total == 0 ? 0.0 : (completed.length / total);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("SEASONAL SUCCESS REPORT", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          const SizedBox(width: 16),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildScoreCard(completionRate, completed.length, total),
            const SizedBox(height: 30),
            _buildYieldEstimate(gameState),
            const SizedBox(height: 30),
            _buildActivityLog(completed),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("BACK TO FARM", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(double rate, int completed, int total) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text("ACTIVITY COMPLETION RATE", style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: rate,
                  strokeWidth: 10,
                  backgroundColor: Colors.white10,
                  color: Colors.greenAccent,
                ),
              ),
              Text("${(rate * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Text("$completed out of $total tasks successfully managed.", style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildYieldEstimate(GameState gameState) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ESTIMATED YIELD SUCCESS", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text("${(gameState.healthScore * gameState.landSize * 5).toStringAsFixed(1)} Tons", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.trending_up, color: Colors.orange, size: 32),
        ],
      ),
    );
  }

  Widget _buildActivityLog(List<Map<String, dynamic>> completed) {
    if (completed.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("COMPLETED ACTIVITIES", style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 15),
        ...completed.take(5).map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
              const SizedBox(width: 12),
              Expanded(child: Text(a['title'], style: const TextStyle(color: Colors.white70, fontSize: 14))),
              Text("Day ${a['day']}", style: const TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
        )),
      ],
    );
  }
}
