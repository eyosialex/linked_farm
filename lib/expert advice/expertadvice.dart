
import 'package:echat/expert%20advice/homepage/cropadvice.dart';
import 'package:echat/expert%20advice/screens/course.dart';
import 'package:echat/expert%20advice/screens/mycourse/mycourse.dart';
import 'package:echat/expert%20advice/screens/personaladvisore.dart';
import 'package:flutter/material.dart';
class LivestockAdvice extends StatelessWidget {
  const LivestockAdvice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Livestock Advice")),
      body: const Center(child: Text("Livestock Advice Page")),
    );
  }
}

class PestControl extends StatelessWidget {
  const PestControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pest Control")),
      body: const Center(child: Text("Pest Control Page")),
    );
  }
}

class Fertilizer extends StatelessWidget {
  const Fertilizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fertilizer")),
      body: const Center(child: Text("Fertilizer Page")),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home Page"));
  }
}

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Planner Page"));
  }
}

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("AI Chat Page"));
  }
}

class ExpertAdvice extends StatefulWidget {
  const ExpertAdvice({super.key});

  @override
  State<ExpertAdvice> createState() => _ExpertAdviceState();
}

class _ExpertAdviceState extends State<ExpertAdvice> {
  int currentIndex = 2; // default to Home

  // Bottom nav pages
  final List<Widget> bottomPages = [
    const AiChatPage(),
    const PlannerPage(),
    ExpertServicesPage(),
    const AdvisorListPage(), // Make sure this class exists and is imported
    const CoursePages() // Use CoursePages (with 's') to match your class name
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: bottomPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Planner"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Adviser"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Courses"),
        ],
      ),
    );
  }
}

// ------------------- Expert Services Page -------------------
class ExpertServicesPage extends StatelessWidget {
  ExpertServicesPage({super.key});

  final List<Map<String, dynamic>> _adviceServices = const [
    {
      "type": "Crop Advice",
      "icon": Icons.agriculture,
      "page": CropAdvice(),
    },
    {
      "type": "Livestock Advice",
      "icon": Icons.pets,
      "page": LivestockAdvice(),
    },
    {
      "type": "course",
      "icon": Icons.bug_report,
      "page": CoursePages(),
    },
    {
      "type": "Fertilizer",
      "icon": Icons.eco,
      "page": Fertilizer(),
    },
  ];

  final List<String> _faqList = const [
    "Maize leaves turning yellow",
    "Best fertilizer for wheat",
    "Cattle vaccination schedule",
    "Tomato pest control tips",
  ];

  void _navigateToService(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showFaqDialog(BuildContext context, String question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          "This is a detailed answer for: '$question'.\n\nConsult agricultural experts for personalized guidance.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Consult Expert"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expert Advice"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Expert Services",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: _adviceServices.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final service = _adviceServices[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () => _navigateToService(context, service["page"]),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[50]!, Colors.green[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(service["icon"], size: 36, color: Colors.green[700]),
                            const SizedBox(height: 8),
                            Text(service["type"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[800])),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text("Frequently Asked Questions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemCount: _faqList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green[50],
                        ),
                        child: Icon(Icons.help_outline, size: 20, color: Colors.green[700]),
                      ),
                      title: Text(_faqList[index],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green[700]),
                      onTap: () => _showFaqDialog(context, _faqList[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}