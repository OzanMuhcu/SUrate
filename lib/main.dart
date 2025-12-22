import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'wrappers/auth_wrapper.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase başlatma

  runApp(
    MultiProvider(
      providers: [
        // Auth State Yönetimi (Giriş/Çıkış)
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Core App Data Yönetimi (Courses, Discussions)
        // AuthProvider'a bağımlı ise ProxyProvider kullanılabilir ama burada bağımsız.
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF004990),
        useMaterial3: true,
      ),
      // AuthWrapper ile kullanıcı durumuna göre yönlendirme
      home: const AuthWrapper(),
    );
  }
}