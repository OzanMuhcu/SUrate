import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'discussions.dart';
import 'drawer.dart';
import 'course_detail_page.dart';

import 'filter_classes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _allCourses = [
    // CS Dersleri
    {
      "code": "CS 201",
      "name": "Introduction to Computing",
      "faculty": "CS",
      "rating": 4.5,
    },
    {
      "code": "CS 204",
      "name": "Advanced Programming",
      "faculty": "CS",
      "rating": 4.2,
    },
    {
      "code": "CS 300",
      "name": "Data Structures",
      "faculty": "CS",
      "rating": 3.9,
    },
    // EE Dersleri
    {
      "code": "EE 201",
      "name": "Analog Electronics",
      "faculty": "EE",
      "rating": 3.8,
    },
    {
      "code": "EE 202",
      "name": "Digital Circuits",
      "faculty": "EE",
      "rating": 4.1,
    },
    {
      "code": "EE 306",
      "name": "Signals and Systems",
      "faculty": "EE",
      "rating": 2.5,
    },
  ];

  String _selectedFilter = "All";

  List<Map<String, dynamic>> get _filteredCourses {
    if (_selectedFilter == "All") {
      return _allCourses;
    } else {
      return _allCourses
          .where((course) => course['faculty'] == _selectedFilter)
          .toList();
    }
  }

  void _updateFilter(String category) {
    setState(() {
      _selectedFilter = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004990),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "SuRate",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
            fontFamily: "Roboto",
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF004990), size: 30),
              ),
            ),
          ),
        ],
      ),

      drawer: CustomDrawer(onCategorySelected: _updateFilter),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SearchBar(
              hintText: "Search for a course",
              leading: const Icon(Icons.search),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF004990)),
                  tooltip: "Advanced Filter",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FilterClassesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedFilter == "All"
                      ? "All Courses"
                      : "$_selectedFilter Courses",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004990),
                  ),
                ),

                if (_selectedFilter != "All")
                  TextButton(
                    onPressed: () => _updateFilter("All"),
                    child: const Text("Clear Filter"),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: _filteredCourses.isEmpty
                ? const Center(
                    child: Text("No courses found in this category."),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseDetailPage(courseData: course),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFE3F2FD),
                              child: Text(
                                course['faculty'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004990),
                                ),
                              ),
                            ),
                            title: Text(
                              course['code'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(course['name']),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    course['rating'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // --- ALT MENÜ (Discussion) ---
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF004990),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiscussionsPage()),
            );
          },
          child: Container(
            height: 60,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.message, color: Colors.white, size: 40),
                SizedBox(width: 15),
                Text(
                  "Discussion",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
