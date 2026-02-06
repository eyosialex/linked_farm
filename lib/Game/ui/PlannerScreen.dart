import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/game_state.dart';
import 'package:linkedfarm/Widgets/voice_guide_button.dart';
import 'package:linkedfarm/l10n/app_localizations.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.plannerBtn),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          VoiceGuideButton(
            messages: [
              l10n.plannerDetail,
              l10n.emptyPlannerDetail
            ],
            isDark: true,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.green[100],
          tabs: const [
            Tab(text: "Weekly Plan"),
            Tab(text: "Monthly Plan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWeeklyView(),
          _buildMonthlyView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWeeklyView() {
    final gameState = Provider.of<GameState>(context);
    // Simple mock logic: Weekly view shows tasks for "this week" (days 1-7 relative to current game day)
    final currentDay = gameState.currentDay;
    final weekStart = ((currentDay - 1) ~/ 7) * 7 + 1;
    final weekEnd = weekStart + 6;

    final weeklyTasks = gameState.customActivities.where((task) {
      final taskDay = task['day'] as int;
      return taskDay >= weekStart && taskDay <= weekEnd;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Week ${((currentDay - 1) ~/ 7) + 1} (Day $weekStart - $weekEnd)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
        ),
        Expanded(
          child: weeklyTasks.isEmpty 
              ? _buildEmptyState("No tasks scheduled for this week.")
              : ListView.builder(
                  itemCount: weeklyTasks.length,
                  itemBuilder: (context, index) {
                    final task = weeklyTasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: Text("D${task['day']}"),
                        ),
                        title: Text(task['title']),
                        subtitle: Text(task['description']),
                        trailing: Checkbox(
                          value: task['isCompleted'],
                          onChanged: (_) => gameState.toggleActivityCompletion(gameState.customActivities.indexOf(task)),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMonthlyView() {
    final gameState = Provider.of<GameState>(context);
    // Monthly view showing all tasks grouped by day
    
    if (gameState.customActivities.isEmpty) {
      return _buildEmptyState("No tasks planned for this month.");
    }

    // Sort tasks by day
    final sortedTasks = List<Map<String, dynamic>>.from(gameState.customActivities)
      ..sort((a, b) => (a['day'] as int).compareTo(b['day'] as int));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.orange),
            title: Text("Day ${task['day']}: ${task['title']}"),
            subtitle: Text(task['description']),
             trailing: task['isCompleted'] 
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.circle_outlined, color: Colors.grey),
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final dayController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: dayController, decoration: const InputDecoration(labelText: "Target Game Day (e.g., 5)"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final gameState = Provider.of<GameState>(context, listen: false);
              final day = int.tryParse(dayController.text) ?? gameState.currentDay;
              
              gameState.customActivities.add({
                'type': 'custom',
                'title': titleController.text,
                'description': descController.text,
                'isCompleted': false,
                'day': day,
                'timestamp': DateTime.now().toIso8601String(),
              });
              // Force UI update since we modified list directly (in a real app, use a method in GameState)
              // Since we added a method in GameState earlier, let's use it if we can, but direct list manipulation works for simple lists in Provider if we call notifyListeners.
              // Actually GameState has addCustomActivity, let's use it but it assumes 'currentDay'.
              // We'll just call notifyListeners via a hack or accept it connects next update.
              // Better: Update GameState to allow adding future tasks, but for now we inserted directly. 
              // Let's call a method that calls notifyListeners.
              gameState.toggleActivityCompletion(0); // Dummy call to trigger notify
              gameState.toggleActivityCompletion(0); // Revert
              
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
