
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../../Services/gemini_service.dart';
import 'rating_report_screen.dart';
import 'package:linkedfarm/Widgets/voice_guide_button.dart';

class YieldResultsScreen extends StatefulWidget {
  const YieldResultsScreen({super.key});

  @override
  State<YieldResultsScreen> createState() => _YieldResultsScreenState();
}

class _YieldResultsScreenState extends State<YieldResultsScreen> {
  late String localAnalysis;

  @override
  void initState() {
    super.initState();
    _generateLocalAnalysis();
  }

  void _generateLocalAnalysis() {
    final gameState = Provider.of<GameState>(context, listen: false);
    final health = gameState.healthScore;
    
    String analysis = "";
    if (health > 0.8) {
      analysis = "Excellent predictive management. Soil moisture and nutrient levels were maintained at optimal thresholds despite weather volatility.";
    } else if (health > 0.5) {
      analysis = "Moderate success. Some stress factors were detected, likely due to wind conditions or moisture fluctuations. Adjust planting timing.";
    } else {
      analysis = "Sub-optimal yield profile. High risk factors (Pest/Fungal) significantly impacted development. Review soil preparation steps.";
    }
    
    localAnalysis = analysis;
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final finalYield = (gameState.healthScore * landEfficiency(gameState) * 100).toInt();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.analytics_outlined, size: 80, color: Colors.orangeAccent),
                const SizedBox(height: 20),
                const Text(
                  "PREDICTIVE ANALYSIS COMPLETE",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
                ),
                VoiceGuideButton(
                  messages: [
                    "Predictive Analysis is complete.",
                    localAnalysis
                  ],
                  isDark: true,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      const Text("ESTIMATED HARVEST YIELD", style: TextStyle(color: Colors.white60, fontSize: 13, letterSpacing: 1)),
                      const SizedBox(height: 10),
                      Text(
                        "$finalYield%",
                        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${gameState.selectedCrop?.name} | Plot: ${gameState.currentLandName ?? 'Standard'}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const Divider(color: Colors.white10, height: 40),
                      const Row(
                        children: [
                           Icon(Icons.auto_awesome, color: Colors.orangeAccent, size: 18),
                          SizedBox(width: 8),
                          Text("LOCAL AI REPORT", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        localAnalysis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.6),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("FINALIZE & RETURN TO PROFILE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double landEfficiency(GameState state) {
    return (state.landPrepScore / 5.0).clamp(0.5, 1.0);
  }
}
