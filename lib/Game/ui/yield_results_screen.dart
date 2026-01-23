
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../../Services/gemini_service.dart';

class YieldResultsScreen extends StatefulWidget {
  const YieldResultsScreen({super.key});

  @override
  State<YieldResultsScreen> createState() => _YieldResultsScreenState();
}

class _YieldResultsScreenState extends State<YieldResultsScreen> {
  String aiFeedback = "Loading AI analysis...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGeminiFeedback();
  }

  void _fetchGeminiFeedback() async {
    final gameState = Provider.of<GameState>(context, listen: false);
    final feedback = await GeminiService.getFarmingAdvice(
      soilType: gameState.selectedSoil?.name ?? "Unknown",
      cropName: gameState.selectedCrop?.name ?? "Unknown",
      day: gameState.currentDay,
      moisture: gameState.soilMoisture,
      nutrients: gameState.soilNutrients,
      health: gameState.healthScore,
    );

    if (mounted) {
      setState(() {
        aiFeedback = feedback;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final finalYield = (gameState.healthScore * 100).toInt();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[900]!, Colors.blue[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium, size: 100, color: Colors.amber),
              const SizedBox(height: 10),
              const Text(
                "HARVEST COMPLETE",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
              ),
              const SizedBox(height: 30),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Text("YIELD EFFICIENCY", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 10),
                        Text(
                          "$finalYield%",
                          style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                        ),
                        const Divider(color: Colors.white24, height: 40),
                        const Row(
                          children: [
                            Icon(Icons.psychology, color: Colors.purpleAccent, size: 24),
                            SizedBox(width: 10),
                            Text("GEMINI AI ANALYSIS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (isLoading)
                          const CircularProgressIndicator(color: Colors.purpleAccent)
                        else
                          Text(
                            aiFeedback,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.5, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("RETURN TO DASHBOARD", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
