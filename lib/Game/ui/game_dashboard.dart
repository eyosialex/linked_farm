
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'land_selection_screen.dart';
import 'farm_main_screen.dart';

class GameDashboard extends StatelessWidget {
  const GameDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Farm Simulator"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, size: 100, color: Colors.green[800]),
              const SizedBox(height: 20),
              Text(
                "Welcome to Your Virtual Farm",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Learn farming by doing. Make decisions, manage resources, and see how AI predicts your harvest!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),
              if (gameState.currentDay == 0 || gameState.isGameOver)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyLandsScreen()),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start New Farm"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                  ),
                )
              else
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FarmMainScreen()),
                        );
                      },
                      icon: const Icon(Icons.play_circle_fill),
                      label: Text("Continue Farming (Day ${gameState.currentDay})"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyLandsScreen()),
                        );
                      },
                      child: const Text("Reset and Start New"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
