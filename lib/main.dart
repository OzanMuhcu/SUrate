import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:surate/providers/theme_provider.dart';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'providers/auth_provider.dart';
import 'wrappers/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ThemeProvider>(
          create: (context) => ThemeProvider(),
          update: (context, auth, themeProvider) {
            themeProvider!.updateUser(auth.user);
            return themeProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SuRate',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            // Customize your light theme here
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey[400],
            primarySwatch: Colors.indigo,
            // Customize your dark theme here
          ),
          themeMode: themeProvider.themeMode,
          home: AuthWrapper(),
        );
      },
    );
  }
}
