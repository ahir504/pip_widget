import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pip_widget_example/main.dart';

class NonPiPScreen extends StatelessWidget {
  const NonPiPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PiP Widget Example"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            pipWidget.launchPIPActivity(initialRouteName: "/pipScreen", arguments: [
              "Arguments from non pip widget",
              jsonEncode({
                "key": "value",
              })
            ]);
          },
          child: const Text("Launch PiP Widget"),
        ),
      ),
    );
  }
}
