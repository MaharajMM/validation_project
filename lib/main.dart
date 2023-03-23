import 'package:flutter/material.dart';
import 'package:validation_project/homescreen.dart';
import 'package:validation_project/api/testapi.dart';

import 'models/output_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validation in Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const TextField(),
              ElevatedButton(
                onPressed: () async {
                  OutputModel outputModel = await testApi(text: "Fuck you");
                  // Text(
                  //   outputModel.censored,
                  //   style: const TextStyle(color: Colors.red),
                  // );
                  if (outputModel.hasProfanity == true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Your content include some bad words. Try removing it.')));
                  }
                },
                child: const Text(
                  'check',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
