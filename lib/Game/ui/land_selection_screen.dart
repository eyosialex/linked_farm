
import 'package:flutter/material.dart';
import 'setup_screens.dart';

class LandSelectionScreen extends StatefulWidget {
  const LandSelectionScreen({super.key});

  @override
  State<LandSelectionScreen> createState() => _LandSelectionScreenState();
}

class _LandSelectionScreenState extends State<LandSelectionScreen> {
  int? selectedPlot;

  final List<Map<String, dynamic>> plots = [
    {'id': 1, 'size': '1.2 ha', 'region': 'North Valley', 'soilHint': 'Deep Loam'},
    {'id': 2, 'size': '0.8 ha', 'region': 'River Basin', 'soilHint': 'Silt/Clay'},
    {'id': 3, 'size': '2.0 ha', 'region': 'High Plateaus', 'soilHint': 'Sandy/Rocky'},
    {'id': 4, 'size': '1.5 ha', 'region': 'East Plains', 'soilHint': 'Balanced'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Land"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background "Map" visual
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green[200]!, Colors.blue[100]!],
              ),
            ),
          ),
          
          GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: plots.length,
            itemBuilder: (context, index) {
              final plot = plots[index];
              final isSelected = selectedPlot == plot['id'];
              
              return GestureDetector(
                onTap: () => setState(() => selectedPlot = plot['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.green[700]! : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected 
                      ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, spreadRadius: 5)]
                      : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.landscape, 
                        size: 50, 
                        color: isSelected ? Colors.green[800] : Colors.grey[600]
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Plot #${plot['id']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(plot['region'], style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 5),
                      Chip(
                        label: Text(plot['size']),
                        backgroundColor: Colors.green[50],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          if (selectedPlot != null)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("CLAIM THIS LAND", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
