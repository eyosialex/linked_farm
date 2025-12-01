import 'package:echat/expert%20advice/screens/mycourse/mycourse.dart';
import 'package:flutter/material.dart';

class CoursePages extends StatefulWidget {
  const CoursePages({super.key});

  @override
  State<CoursePages> createState() => _CoursePagesState();
}

class _CoursePagesState extends State<CoursePages> {
  List<String> detaillistmain = [
    "Wheat production",
    "Teff production",
    "Maize (corn) farming",
    "Barley farming",
    "Onion farming",
    "Tomato farming",
    "Potato farming",
    "Irrigation & water management",
    "Soil fertility & fertilizer use",
    "Pest & disease management",
    "Organic farming",
    "Climate-smart agriculture",
  ];

  List<String> freecourse = [
    "How to prepare land",
    "How to plant seeds correctly",
    "How to use compost",
    "Basic irrigation",
    "Pest control basics",
    "Simple home gardening",
    "Small poultry (backyard chickens)",
    "Grain storage methods",
    "How to use farm tools",
  ];

  List<String> wintercourse = [
    "Mushroom production",
    "Goat fattening",
    "Sheep fattening",
    "Chicken farming",
    "Bee farming",
    "Fish farming",
    "Hydroponic leafy vegetables",
    "Soap making",
    "Handcrafts",
    "Injera baking business",
    "Small shop management",
  ];
  String selectedCategory = "Primary Courses";

  void _navigateToMyCourses() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => MyCoursesPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Farmer Courses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          // FIXED: Correct padding syntax
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _navigateToMyCourses,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blueAccent,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.greenAccent,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Learn & Grow",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Enhance your farming skills with expert courses",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search courses...",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- CATEGORY CHIPS ----------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20),
                children: [
                  _categoryChip("Primary Courses"),
                  const SizedBox(width: 12),
                  _categoryChip("Free Courses"),
                  const SizedBox(width: 12),
                  _categoryChip("Winter Jobs"),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_getCurrentList().length} Courses Available",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: _buildCourseList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    List<String> dataList = _getCurrentList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              dataList[index],
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
            subtitle: Text(
              "Beginner • 4 weeks",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: IconButton(
              onPressed: (){}, 
              icon: const Icon(Icons.arrow_forward_ios)
            ),
          ),
        );
      },
    );
  }

  Widget _categoryChip(String label) {
    bool isSelected = selectedCategory == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? null : Border.all(color: Colors.grey[200]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  List<String> _getCurrentList() {
    switch (selectedCategory) {
      case "Primary Courses":
        return detaillistmain;
      case "Free Courses":
        return freecourse;
      case "Winter Jobs":
        return wintercourse;
      default:
        return detaillistmain;
    }
  }
}