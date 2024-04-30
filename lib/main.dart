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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.amberAccent)),
          child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          children: <Widget>[
            TrackerToggleItem("images/truth.png").getWidget(),
            TrackerStateItem(["images/bottle.png","images/bottle_blue.png","images/bottle_red.png"]).getWidget(),
            TrackerCountItem("images/triforce_piece.png", 3).getWidget(),
          ],
        ),
        )
      ),
    );
  }
}