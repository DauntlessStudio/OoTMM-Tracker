import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ootmm_tracker/tracker_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, background: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String>? asset;

  @override
  void initState() {
    super.initState();
    asset = DefaultAssetBundle.of(context).loadString("tracker.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: asset, builder: (context, snapshot) {
        if (snapshot.hasData) {
          Tracker tracker = Tracker.fromJson(jsonDecode(snapshot.data!));
          return tracker.getWidget();
        } else if (snapshot.hasError) {
          return const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          return const CircularProgressIndicator();
        }
      }),
    );
  }
}