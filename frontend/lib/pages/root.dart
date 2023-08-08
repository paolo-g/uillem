import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/prompt/prompt.dart';
import 'package:frontend/pages/results/results.dart';


class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = PromptPage();
        break;
      case 1:
        page = ResultsPage();
        break;
      default:
        throw UnimplementedError('No page for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.search),
                  label: Text('Prompt'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Results'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
