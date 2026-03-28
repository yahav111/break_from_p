import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_system/design_system.dart';
import 'features/showcase/showcase_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const QuittrApp());
}

class QuittrApp extends StatelessWidget {
  const QuittrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QUITTR Design System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const ShowcaseScreen(),
    );
  }
}
