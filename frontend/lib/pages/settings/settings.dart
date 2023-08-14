import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var frontendState = context.watch<FrontendState>();
    var batchSizeController = frontendState.batchSizeController;
    var contextSizeController = frontendState.contextSizeController;

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        SizedBox(height: 10),
        SizedBox(
          child: TextField(
            controller: batchSizeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Batch Size',
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          child: TextField(
            controller: contextSizeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Context Size',
            ),
          ),
        ),
      ],
    );
  }
}
