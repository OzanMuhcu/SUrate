import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_paddings.dart';
import '../../models/lecture.dart';

enum _SortOption { code, title, credits }

class LecturesListScreen extends StatefulWidget {
  const LecturesListScreen({super.key});

  @override
  State<LecturesListScreen> createState() => _LecturesListScreenState();
}

class _LecturesListScreenState extends State<LecturesListScreen> {
  late List<Lecture> _lectures;

  String _search = '';
  String _activeFilter = 'All';
  _SortOption _sortOption = _SortOption.code;
  bool _filterActive = false;
  bool _sortActive = false;

  @override
  void initState() {
    super.initState();
    _lectures = [
      const Lecture(
        id: '1',
        code: 'CS310',
        title: 'Database Systems',
        instructor: 'Dr. Smith',
        credits: 3,
      ),
      const Lecture(
        id: '2',
        code: 'CS201',
        title: 'Algorithms',
        instructor: 'Dr. Doe',
        credits: 3,
      ),
      const Lecture(
        id: '3',
        code: 'MATH101',
        title: 'Calculus I',
        instructor: 'Dr. Taylor',
        credits: 4,
      ),
    ];
  }

  List<Lecture> get _filteredAndSorted {
    var result = _lectures.where((lecture) {
      final matchesFilter = _activeFilter == 'All' ||
          lecture.code.toUpperCase().startsWith(_activeFilter.toUpperCase());
      final matchesSearch = _search.isEmpty ||
          lecture.title.toLowerCase().contains(_search.toLowerCase()) ||
          lecture.code.toLowerCase().contains(_search.toLowerCase()) ||
          lecture.instructor.toLowerCase().contains(_search.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    result.sort((a, b) {
      switch (_sortOption) {
        case _SortOption.code:
          return a.code.compareTo(b.code);
        case _SortOption.title:
          return a.title.compareTo(b.title);
        case _SortOption.credits:
          return a.credits.compareTo(b.credits);
      }
    });

    return result;
  }

  void _removeLecture(Lecture lecture) {
    setState(() {
      _lectures.removeWhere((l) => l.id == lecture.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facultyName = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search courses, codes, instructors',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _search = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Profile page will be implemented by another team member.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Back to faculties'),
              onTap: () {
                Navigator.of(context).pop(); // close drawer
                Navigator.of(context).maybePop();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lectures',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (facultyName != null)
                      Text(
                        facultyName,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: _filterActive ? AppColors.accent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _filterActive = !_filterActive;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Detailed filter screen belongs to another team member.',
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.sort,
                        color: _sortActive ? AppColors.accent : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _sortActive = !_sortActive;
                          switch (_sortOption) {
                            case _SortOption.code:
                              _sortOption = _SortOption.title;
                              break;
                            case _SortOption.title:
                              _sortOption = _SortOption.credits;
                              break;
                            case _SortOption.credits:
                              _sortOption = _SortOption.code;
                              break;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _activeFilter == 'All',
                  onSelected: (_) {
                    setState(() {
                      _activeFilter = 'All';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('CS'),
                  selected: _activeFilter == 'CS',
                  onSelected: (_) {
                    setState(() {
                      _activeFilter = 'CS';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('MATH'),
                  selected: _activeFilter == 'MATH',
                  onSelected: (_) {
                    setState(() {
                      _activeFilter = 'MATH';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAndSorted.length,
                itemBuilder: (context, index) {
                  final lecture = _filteredAndSorted[index];
                  return Card(
                    margin: AppPaddings.itemSpacing,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        '${lecture.code} - ${lecture.title}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${lecture.instructor} • ${lecture.credits} credits',
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Rating page will be implemented by another team member.',
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeLecture(lecture),
                      ),
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
