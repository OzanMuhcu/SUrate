import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CustomDrawer({super.key, required this.onCategorySelected});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? _selectedFaculty;

  final Map<String, List<String>> _facultyData = {
    "Faculty of Engineering and\nNatural Sciences": [
      "CS - Computer Science",
      "EE - Electrical Engineering",
      "ME - Mechatronics",
      "BIO - Bioengineering",
      "IE - Industrial Engineering",
      "MAT - Mathematics",
    ],
    "Faculty of Arts and\nSocial Sciences": [
      "PSY - Psychology",
      "ECON - Economics",
      "VA - Visual Arts",
      "SPS - Social & Pol. Sciences",
      "IR - International Relations",
    ],
    "Sabancı Business School": [
      "MGMT - Management",
      "FIN - Finance",
      "MKT - Marketing",
      "BAN - Business Analytics",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            color: const Color(0xFF004990),
            child: Column(
              children: const [
                Icon(Icons.school, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text(
                  "Course Selection",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _selectedFaculty == null
                ? _buildFacultyList()
                : _buildCourseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Select Faculty",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004990),
          ),
        ),
        const SizedBox(height: 30),
        ..._facultyData.keys.map((facultyName) {
          return _buildMenuButton(
            text: facultyName,
            onPressed: () {
              setState(() {
                _selectedFaculty = facultyName;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCourseList() {
    final courses = _facultyData[_selectedFaculty] ?? [];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Colors.grey[100],
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF004990)),
                onPressed: () {
                  setState(() {
                    _selectedFaculty = null;
                  });
                },
              ),
              Expanded(
                child: Text(
                  "Back to Faculties",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            _selectedFaculty!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004990),
            ),
          ),
        ),
        const Divider(thickness: 1, height: 30),

        Expanded(
          child: ListView.builder(
            itemCount: courses.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return _buildMenuButton(
                text: courses[index],
                isSmall: true,
                onPressed: () {
                  String fullText = courses[index];
                  String code = fullText.split(" - ")[0];

                  widget.onCategorySelected(code);

                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onPressed,
    bool isSmall = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity,
        height: isSmall ? 50 : 70,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF004990),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmall ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
