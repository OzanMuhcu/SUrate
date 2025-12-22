import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'discussions.dart';
import 'drawer.dart';
import 'course_detail_page.dart';
import 'filter_classes_page.dart';

import 'package:surate/models/course.dart';
import 'providers/data_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = "";
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleCategorySelection(String categoryCode) {
    setState(() {
      if (_selectedCategory == categoryCode) {
        _selectedCategory = null;
      } else {
        _selectedCategory = categoryCode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final allCourses = dataProvider.courses;
    final isLoading = dataProvider.isLoading;
    final errorMessage = dataProvider.errorMessage;

    final filteredCourses = allCourses.where((course) {
      final matchesSearch = course.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.code.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == null ||
          course.code.startsWith(_selectedCategory!);

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF004990),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "SuRate",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
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
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF004990)),
              ),
            ),
          ),
        ],
      ),

      drawer: CustomDrawer(
        onCategorySelected: (category) {
          _handleCategorySelection(category);
        },
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            color: const Color(0xFFF5F5F5),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search for classes...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                  },
                )
                    : null,
              ),
            ),
          ),

          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Text(
                    "Filtering by: $_selectedCategory",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004990)),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _handleCategorySelection(_selectedCategory!),
                    child: const Icon(Icons.cancel, size: 20, color: Colors.redAccent),
                  )
                ],
              ),
            ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(child: Text("Error: $errorMessage"))
                : filteredCourses.isEmpty
                ? const Center(
              child: Text(
                "No courses found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];

                return _buildClassCard(
                  context,
                  code: course.code,
                  name: course.name,
                  faculty: course.faculty,
                  rating: course.rating,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(
                          courseData: course.toMap(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF004990),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiscussionsPage()),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.message, color: Colors.white, size: 30),
                SizedBox(width: 10),
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

  Widget _buildClassCard(
      BuildContext context, {
        required String code,
        required String name,
        required String faculty,
        required double rating,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$code - $faculty",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: rating >= 4.0
                      ? Colors.green.withOpacity(0.2)
                      : (rating >= 2.5
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: rating >= 4.0
                          ? Colors.green
                          : (rating >= 2.5 ? Colors.orange : Colors.red),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}