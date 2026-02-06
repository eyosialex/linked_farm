import 'package:linkedfarm/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:linkedfarm/Widgets/voice_guide_button.dart';
import 'package:provider/provider.dart';
import '../../Services/locale_provider.dart';
import '../models/game_state.dart';
import 'yield_results_screen.dart';
import '../../Services/gemini_service.dart';
import 'growth_journal_screen.dart';
import 'farming_report_screen.dart';
import 'DailyTrackerScreen.dart';
import 'PlannerScreen.dart';
import 'AdvisorScreen.dart';
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
                _buildWeatherSegment(context, gameState),
                _buildRiskDashboard(context, gameState),
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

  Widget _buildWeatherSegment(BuildContext context, GameState gameState) {
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
              Semantics(
                label: "${isRainy ? AppLocalizations.of(context)!.predictedRain : AppLocalizations.of(context)!.clearSkies}, ${gameState.currentTemp.toStringAsFixed(1)} degrees Celsius",
                child: Row(
                  children: [
                    Icon(
                      isRainy ? Icons.water : Icons.wb_sunny,
                      color: isRainy ? Colors.greenAccent : Colors.orangeAccent,
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
                          isRainy ? AppLocalizations.of(context)!.predictedRain : AppLocalizations.of(context)!.clearSkies,
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Semantics(
                label: "Energy level ${(gameState.energy.toInt())} percent",
                child: Container(
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
              ),
              const SizedBox(width: 8),
              VoiceGuideButton(
                messages: [
                  AppLocalizations.of(context)!.farmMainIntro,
                  AppLocalizations.of(context)!.tapDeepAnalysis,
                  AppLocalizations.of(context)!.proceedNextDay
                ],
                isDark: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskDashboard(BuildContext context, GameState gameState) {
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
          _riskMetric(AppLocalizations.of(context)!.pest, gameState.pestRisk, Colors.redAccent),
          _riskMetric(AppLocalizations.of(context)!.fungal, gameState.diseaseRisk, Colors.orangeAccent),
          _riskMetric(AppLocalizations.of(context)!.weeds, gameState.weedPressure, Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _riskMetric(String label, double value, Color color) {
    return Semantics(
      label: "$label risk ${(value * 100).toInt()} percent",
      child: Column(
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
      ),
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
          Semantics(
            label: "${AppLocalizations.of(context)!.soilMoistureProfile}, ${(gameState.soilMoisture * 100).toInt()} percent",
            value: "${(gameState.soilMoisture * 100).toInt()}%",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: gameState.soilMoisture.clamp(0.0, 1.0),
                backgroundColor: Colors.white10,
                color: Colors.greenAccent,
                minHeight: 12,
              ),
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
                  Text(AppLocalizations.of(context)!.dayLabel(gameState.currentDay), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                  Text(AppLocalizations.of(context)!.vegetativeCycle, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
              Row(
                children: [
                  Semantics(
                    button: true,
                    label: "View Farming Report",
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FarmingReportScreen())),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Semantics(
                    button: true,
                    label: "View Seasonal Roadmap",
                    child: GestureDetector(
                      onTap: () => _showSeasonalRoadmap(context, gameState),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.map, color: Colors.greenAccent, size: 20),
                      ),
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
                color: Colors.orangeAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orangeAccent.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.orangeAccent, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getLocalizedAdvice(context, gameState),
                          style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                        ),
                        const SizedBox(height: 4),
                        Text(AppLocalizations.of(context)!.tapDeepAnalysis, style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.orangeAccent, size: 16),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // NEW: Predictive Farming Tools
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _toolButton(context, AppLocalizations.of(context)!.dailyLogBtn, Icons.camera_alt, Colors.green[700]!, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyTrackerScreen()));
              }),
              _toolButton(context, AppLocalizations.of(context)!.plannerBtn, Icons.calendar_month, Colors.orange[700]!, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PlannerScreen()));
              }),
              _toolButton(context, AppLocalizations.of(context)!.advisorBtn, Icons.psychology, Colors.amber, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvisorScreen()));
              }),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(child: _actionBtn(AppLocalizations.of(context)!.fertilizeBtn, Icons.science, Colors.orange, gameState.fertilize)),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: gameState.nextDay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(AppLocalizations.of(context)!.proceedNextDay, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
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

  Widget _toolButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedAdvice(BuildContext context, GameState gameState) {
    final l10n = AppLocalizations.of(context)!;
    final key = _getPredictiveAIAdvice(gameState);
    switch (key) {
      case "advicePest":
        return l10n.advicePest;
      case "adviceMoistureLow":
        return l10n.adviceMoistureLow;
      case "adviceRainy":
        return l10n.adviceRainy;
      case "adviceStable":
      default:
        return l10n.adviceStable;
    }
  }

  String _getPredictiveAIAdvice(GameState gameState) {
    if (gameState.pestRisk > 0.4) return "advicePest";
    if (gameState.soilMoisture < 0.4) return "adviceMoistureLow";
    if (gameState.currentWeather == "Rainy") return "adviceRainy";
    return "adviceStable";
  }

  void _showGeminiAnalysis(BuildContext context, GameState gameState) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
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
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.orangeAccent),
              const SizedBox(width: 10),
              Text(l10n.aiDeepAnalysisTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(advice, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(l10n.gotIt, style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold))
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
                  Text(AppLocalizations.of(context)!.myCustomLandPlan, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  IconButton(
                    onPressed: () => _showAddActivityDialog(context, gameState),
                    icon: const Icon(Icons.add_circle, color: Colors.greenAccent, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.plannerDetail, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 25),
              Expanded(
                child: gameState.customActivities.isEmpty 
                  ? _buildEmptyPlanner(context)
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
    final color = type == 'daily' ? Colors.greenAccent : (type == 'weekly' ? Colors.orangeAccent : Colors.orangeAccent[100]!);

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
                      child: Text(AppLocalizations.of(context)!.completed, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
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
          Text(AppLocalizations.of(context)!.dayLabel(activity['day']), style: TextStyle(color: Colors.white24, fontSize: 10)),
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
          title: Text(AppLocalizations.of(context)!.entryManualPlanTitle, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                dropdownColor: const Color(0xFF1E293B),
                value: selectedType,
                items: ['daily', 'weekly', 'monthly'].map((t) {
                  String label = t == 'daily' ? AppLocalizations.of(context)!.daily : (t == 'weekly' ? AppLocalizations.of(context)!.weekly : AppLocalizations.of(context)!.monthly);
                  return DropdownMenuItem(value: t, child: Text(label, style: const TextStyle(color: Colors.white)));
                }).toList(),
                onChanged: (val) => setModalState(() => selectedType = val!),
              ),
              TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.taskTitle, labelStyle: const TextStyle(color: Colors.white70))),
              TextField(controller: descController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.activityDetail, labelStyle: const TextStyle(color: Colors.white70))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) return;
                gameState.addCustomActivity(selectedType, titleController.text, descController.text);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.savePlan),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlanner(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 64, color: Colors.white12),
          const SizedBox(height: 15),
          Text(AppLocalizations.of(context)!.emptyPlanner, style: const TextStyle(color: Colors.white38)),
          Text(AppLocalizations.of(context)!.emptyPlannerDetail, style: const TextStyle(color: Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }
}
