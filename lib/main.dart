import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/providers/preferences_provider.dart';
import 'package:easy_get/providers/tab_selected_provider.dart';
import 'package:easy_get/theme/app_theme.dart';
import 'package:easy_get/widgets/pages/download_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Se crea UNA sola vez, antes de runApp, para poder llamar a init()
  // sobre la misma instancia que después se registra en el árbol.
  final downloadProvider = DownloadProvider();
  downloadProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabSelectedProvider()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        ChangeNotifierProvider.value(value: downloadProvider),
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = Provider.of<PreferencesProvider>(
      context,
    ).themeMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Get',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 200),
      themeAnimationCurve: Curves.easeInOut,
      home: const DownloadPage(),
    );
  }
}
