import 'package:create_file_tool/page/config_page/config_page.dart';
import 'package:create_file_tool/page/create_page/create_page.dart';
import 'package:create_file_tool/page/home_page/home_page.dart';
import 'package:create_file_tool/utils/key_screen.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: _appBarTheme()),
      home: const HomePage(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      routes: {
        HOME_PAGE: (context) => const HomePage(),
        CONFIG_PAGE: (context) => const ConfigPage(),
        CREATE_FILE_PAGE: (context) => const CreateFilePage()
      },
    );
  }

  AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }
}
