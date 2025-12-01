import 'package:flutter/material.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class Course {
  final String name;
  final double progress;
  final bool completed;
  final String? certificate;
  final DateTime? schedule;

  Course({
    required this.name,
    required this.progress,
    required this.completed,
    this.certificate,
    this.schedule,
  });
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  // Sample Data
  List<Course> myCourses = [
    Course(
      name: "Wheat Production",
      progress: 0.5,
      completed: false,
      schedule: DateTime(2025, 12, 1),
    ),
    Course(
      name: "Tomato Farming",
      progress: 1.0,
      completed: true,
      certificate: "assets/certificates/tomato.pdf",
    ),
    Course(
      name: "Goat Fattening",
      progress: 0.8,
      completed: false,
      schedule: DateTime(2025, 12, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Course> ongoingCourses =
        myCourses.where((c) => !c.completed).toList();
    List<Course> completedCourses =
        myCourses.where((c) => c.completed).toList();
    List<Course> upcomingCourses =
        myCourses.where((c) => c.schedule != null && !c.completed).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: const Text(
            "My Courses",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "My Profile",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  )
                ],
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: "Ongoing"),
              Tab(text: "Completed"),
              Tab(text: "Upcoming"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Ongoing Courses
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ongoingCourses.length,
              itemBuilder: (context, index) =>
                  _buildCourseCard(ongoingCourses[index]),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedCourses.length,
              itemBuilder: (context, index) =>
                  _buildCourseCard(completedCourses[index]),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: upcomingCourses.length,
              itemBuilder: (context, index) =>
                  _buildCourseCard(upcomingCourses[index]),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
  if (!course.completed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: course.progress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text("Progress: ${(course.progress * 100).toStringAsFixed(0)}%"),
                  if (course.schedule != null)
                    Text(
                      "Next schedule: ${course.schedule!.day}/${course.schedule!.month}/${course.schedule!.year}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),

            // Completed Courses    
               if (course.completed && course.certificate != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Completed",
                      style: TextStyle(color: Colors.green)),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // Handle certificate download
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
