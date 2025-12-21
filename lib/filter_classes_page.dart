import 'package:flutter/material.dart';

// Use the existing color definitions for consistency
const Color primaryBlue = Color(0xFF007ACC); // A standard, deep blue
const Color lightBlueAccent = Color(
  0xFFE3F2FD,
); // Very light blue for background/fill
const Color darkestBlue = Color(
  0xFF0D47A1,
); // Slightly darker blue for contrast

class InteractiveRatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final Color color;
  final Color emptyColor;
  final ValueChanged<double> onRatingChanged;

  const InteractiveRatingStars({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.maxStars = 5,
    this.size = 22.0,
    this.color = primaryBlue,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        IconData iconData;
        Color iconColor;
        double currentStarIndex = index + 1.0;

        if (currentStarIndex <= rating) {
          iconData = Icons.star;
          iconColor = color;
        } else if (currentStarIndex - rating <= 0.5 &&
            currentStarIndex > rating) {
          iconData = Icons.star_half;
          iconColor = color;
        } else {
          iconData = Icons.star_border;
          iconColor = emptyColor.withOpacity(0.5);
        }

        return GestureDetector(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                Icon(iconData, color: iconColor, size: size),

                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: size / 2,
                  child: GestureDetector(
                    onTap: () {
                      double newRating = index + 0.5;

                      if (newRating == rating) {
                        onRatingChanged(0.0);
                      } else {
                        onRatingChanged(newRating);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                ),

                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: size / 2,
                  child: GestureDetector(
                    onTap: () {
                      double newRating = index + 1.0;

                      if (newRating == rating) {
                        onRatingChanged(0.0);
                      } else {
                        onRatingChanged(newRating);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class DifficultyToggle extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyToggle({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          border: Border.all(
            color: isSelected ? primaryBlue : Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryBlue,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class FilterClassesPage extends StatefulWidget {
  const FilterClassesPage({super.key});

  @override
  State<FilterClassesPage> createState() => _FilterClassesPageState();
}

class _FilterClassesPageState extends State<FilterClassesPage> {
  String _selectedDifficulty = 'Intermediate';
  double _expectedStudyHours = 5.0;
  bool _gradedAttendance = true;
  bool _termProject = false;
  bool _homeworks = false;

  double _overallRating = 4.5;
  double _teachingMaterialRating = 3.0;

  final String _defaultSubjectLabel = 'Select Subject';
  final String _defaultTeacherLabel = 'Select Teacher';
  String _selectedSubject = 'Select Subject';
  String _selectedTeacher = 'Select Teacher';

  void _openSelectionModal({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10.0,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
              const Divider(),
              // Options List
              ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == currentValue;
                  return ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? primaryBlue : Colors.black,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: primaryBlue)
                        : null,
                    onTap: () {
                      onSelect(option);
                      Navigator.pop(context);
                    },
                  );
                },
              ),

              ListTile(
                title: const Text('Clear Selection'),
                onTap: () {
                  onSelect(
                    title.contains('Subject')
                        ? _defaultSubjectLabel
                        : _defaultTeacherLabel,
                  );
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.close),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 🔥 GÜNCELLENEN KISIM: Geri Butonu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Filter Classes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDifficulty = 'Intermediate';
                _expectedStudyHours = 5.0;
                _gradedAttendance = true;
                _termProject = false;
                _homeworks = false;
                _overallRating = 0.0;
                _teachingMaterialRating = 0.0;
                _selectedSubject = _defaultSubjectLabel;
                _selectedTeacher = _defaultTeacherLabel;
              });
            },
            child: const Text('Reset', style: TextStyle(color: primaryBlue)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 150.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: 'Key Info',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterBox(
                              label: _defaultSubjectLabel,
                              selectedValue: _selectedSubject,
                              onTap: () => _openSelectionModal(
                                title: _defaultSubjectLabel,
                                currentValue: _selectedSubject,

                                options: [
                                  'Computer Science',
                                  'Physics',
                                  'Mathematics',
                                  'Literature',
                                  'History',
                                  'Art',
                                ],
                                onSelect: (value) =>
                                    setState(() => _selectedSubject = value),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildFilterBox(
                              label: _defaultTeacherLabel,
                              selectedValue: _selectedTeacher,
                              onTap: () => _openSelectionModal(
                                title: _defaultTeacherLabel,
                                currentValue: _selectedTeacher,

                                options: [
                                  'Dr. Smith',
                                  'Prof. Jones',
                                  'Dr. Williams',
                                  'Ms. Davis',
                                  'Mr. Lee',
                                  'Prof. Chen',
                                ],
                                onSelect: (value) =>
                                    setState(() => _selectedTeacher = value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildSectionCard(
                    title: 'Ratings',
                    children: [
                      _buildRatingRow(
                        label: 'Overall Rating',
                        rating: _overallRating,
                        onRatingChanged: (newRating) {
                          setState(() {
                            _overallRating = newRating;
                          });
                        },
                      ),
                      const Divider(height: 20),
                      _buildRatingRow(
                        label: 'Teaching Material',
                        rating: _teachingMaterialRating,
                        onRatingChanged: (newRating) {
                          setState(() {
                            _teachingMaterialRating = newRating;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'How good are the official lectures, notes, and homework?',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),

                  _buildSectionCard(
                    title: 'Difficulty & Workload',
                    children: [
                      Row(
                        children: [
                          DifficultyToggle(
                            text: 'Beginner',
                            isSelected: _selectedDifficulty == 'Beginner',
                            onTap: () => setState(
                              () => _selectedDifficulty = 'Beginner',
                            ),
                          ),
                          const SizedBox(width: 8),
                          DifficultyToggle(
                            text: 'Intermediate',
                            isSelected: _selectedDifficulty == 'Intermediate',
                            onTap: () => setState(
                              () => _selectedDifficulty = 'Intermediate',
                            ),
                          ),
                          const SizedBox(width: 8),
                          DifficultyToggle(
                            text: 'Advanced',
                            isSelected: _selectedDifficulty == 'Advanced',
                            onTap: () => setState(
                              () => _selectedDifficulty = 'Advanced',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Expected Study Hours (per week)',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Row(
                        children: [
                          const Text('1'),
                          Expanded(
                            child: Slider(
                              value: _expectedStudyHours,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              activeColor: primaryBlue,
                              inactiveColor: lightBlueAccent,
                              thumbColor: primaryBlue,
                              onChanged: (double value) {
                                setState(() {
                                  _expectedStudyHours = value;
                                });
                              },
                            ),
                          ),
                          const Text('10'),
                        ],
                      ),
                    ],
                  ),

                  _buildSectionCard(
                    title: 'Class Structure',
                    children: [
                      _buildToggleRow(
                        label: 'Graded Attendance',
                        value: _gradedAttendance,
                        onChanged: (val) =>
                            setState(() => _gradedAttendance = val),
                      ),
                      const Divider(height: 1),
                      _buildToggleRow(
                        label: 'Homeworks',
                        value: _homeworks,
                        onChanged: (val) => setState(() => _homeworks = val),
                      ),
                      const Divider(height: 1),
                      _buildToggleRow(
                        label: 'Term Project',
                        value: _termProject,
                        onChanged: (val) => setState(() => _termProject = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                print(
                  'Filter Applied: Overall Rating: $_overallRating, Expected Study Hours: $_expectedStudyHours, Material Rating: $_teachingMaterialRating, Graded Attendance: $_gradedAttendance, Term Project: $_termProject, Homeworks: $_homeworks, Subject: $_selectedSubject, Teacher: $_selectedTeacher',
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Show Classes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBox({
    required String label,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isDefault = selectedValue == label;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedValue,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: isDefault ? Colors.grey : Colors.black87,
                  fontWeight: isDefault ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow({
    required String label,
    required double rating,
    required ValueChanged<double> onRatingChanged,
  }) {
    String displayValue = rating == 0
        ? ''
        : rating.toStringAsFixed(1).endsWith('.0')
        ? rating.toInt().toString()
        : rating.toStringAsFixed(1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        Row(
          children: [
            if (displayValue.isNotEmpty)
              Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            if (displayValue.isNotEmpty) const SizedBox(width: 8),

            InteractiveRatingStars(
              rating: rating,
              onRatingChanged: onRatingChanged,
              color: primaryBlue,
              emptyColor: primaryBlue,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: primaryBlue),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
