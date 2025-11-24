import 'package:flutter/material.dart';

import 'core/app_colors.dart';
import 'core/app_routes.dart';
import 'core/app_text_styles.dart';
import 'screens/lectures/lectures_list_screen.dart';
import 'screens/lectures/select_faculty_screen.dart';
import 'screens/search/global_search_screen.dart';

void main() {
  runApp(const SuRateApp());
}

class SuRateApp extends StatelessWidget {
  const SuRateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuRate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        textTheme: AppTextStyles.textTheme,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.globalSearch,
      routes: {
        AppRoutes.globalSearch: (_) => const GlobalSearchScreen(),
        AppRoutes.selectFaculty: (_) => const SelectFacultyScreen(),
        AppRoutes.lecturesList: (_) => const LecturesListScreen(),
      },
    );
  }
}
