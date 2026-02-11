import 'package:linkedfarm/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'land_selection_screen.dart';
import 'farm_main_screen.dart';

class GameDashboard extends StatelessWidget {
  const GameDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.virtualFarmSimulator),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
        ],
        
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
                l10n.welcomeVirtualFarm,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  l10n.gameIntro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                  label: Text(l10n.startNewFarm),
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
                      label: Text(l10n.continueFarming(gameState.currentDay)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.orange[700],
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
                      child: Text(l10n.resetStartNew),
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
