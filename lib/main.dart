import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

ThemeData darkTheme = ThemeData(colorSchemeSeed: Color(0xFF891C19), brightness: Brightness.dark);

ThemeData lightTheme = ThemeData(
  colorSchemeSeed: const Color.fromARGB(255, 148, 180, 206),
  brightness: Brightness.light,
);

void main() {
  runApp(CustomTheme(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      initialData: lightTheme,
      stream: CustomTheme.of(context)!.streamController.stream,
      builder:
          (context, snapshot) => GetMaterialApp(
            title: "Application",
            initialRoute: AppPages.INITIAL,
            // theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF891C19))),
            theme: snapshot.data,
            getPages: AppPages.routes,
          ),
    );
  }
}

class CustomTheme extends InheritedWidget {
  CustomTheme({super.key, required this.child}) : super(child: child);

  final Widget child;
  final StreamController<ThemeData> streamController = StreamController();

  static CustomTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomTheme>();
  }

  @override
  bool updateShouldNotify(CustomTheme oldWidget) {
    return oldWidget != this;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomTheme customTheme = CustomTheme.of(context)!;
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Theme Demo')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                customTheme.streamController.add(darkTheme);
              },
              child: const Text('DARK'),
            ),
            ElevatedButton(
              onPressed: () {
                customTheme.streamController.add(lightTheme);
              },
              child: const Text('LIGHT'),
            ),
          ],
        ),
      ),
    );
  }
}
