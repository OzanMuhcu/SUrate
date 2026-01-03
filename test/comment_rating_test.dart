import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:surate/RatePage.dart';

void main() {
  testWidgets(
    'Project rating appears after enabling project switch and empty comments are blocked',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RateCoursePage(
            courseId: 'course-1',
            courseCode: 'CS101',
          ),
        ),
      );

      expect(find.text('How difficult was the project?'), findsNothing);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('How difficult was the project?'), findsOneWidget);

      final submitButton = find.byType(ElevatedButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Please write a comment'), findsOneWidget);
    },
  );
}
