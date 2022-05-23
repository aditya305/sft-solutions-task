import 'package:flutter/material.dart';
import 'package:stic_soft_task/presentation/home_screen/home_screen.dart';
import 'package:stic_soft_task/presentation/themes/themes.dart';
import 'package:stic_soft_task/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // List<ProductDataModel> list = await ReadJsonData();
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stic Soft Task',
      themeMode: ThemeMode.light,
      theme: Themes.lightTheme,
      color: Theme.of(context).colorScheme.primary,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
