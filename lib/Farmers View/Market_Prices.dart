
import 'package:flutter/material.dart';

class MarketPricesPage extends StatelessWidget {
  const MarketPricesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for now - could be fetched from API later
    final List<Map<String, dynamic>> prices = [
      {"commodity": "Maize", "unit": "Quintal", "min": "2800", "max": "3200", "avg": "3000", "trend": "up"},
      {"commodity": "Wheat", "unit": "Quintal", "min": "3500", "max": "4000", "avg": "3800", "trend": "up"},
      {"commodity": "Teff (White)", "unit": "Quintal", "min": "6000", "max": "6500", "avg": "6300", "trend": "stable"},
      {"commodity": "Teff (Red)", "unit": "Quintal", "min": "5000", "max": "5500", "avg": "5250", "trend": "down"},
      {"commodity": "Coffee", "unit": "kg", "min": "300", "max": "450", "avg": "380", "trend": "up"},
      {"commodity": "Onion", "unit": "kg", "min": "40", "max": "60", "avg": "50", "trend": "down"},
      {"commodity": "Tomato", "unit": "kg", "min": "25", "max": "40", "avg": "30", "trend": "stable"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Market Prices"),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Prices as of ${DateTime.now().toString().split(' ')[0]}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.purple[50]),
              columns: const [
                DataColumn(label: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Avg Price (ETB)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Trend', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: prices.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item['commodity'])),
                  DataCell(Text(item['unit'])),
                  DataCell(Text(item['avg'])),
                  DataCell(
                    Icon(
                      item['trend'] == 'up' ? Icons.arrow_upward : 
                      item['trend'] == 'down' ? Icons.arrow_downward : Icons.remove,
                      color: item['trend'] == 'up' ? Colors.green : 
                             item['trend'] == 'down' ? Colors.red : Colors.grey,
                      size: 16,
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
