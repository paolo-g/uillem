import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';


class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var frontendState = context.watch<FrontendState>();
    var cache = frontendState.cache;

    if (cache.isEmpty) {
      return Center(
        child: Text('No results yet.'),
      );
    }

    return ListView(
      children: [
        for (var item in cache.entries)
          ListTile(
            contentPadding: const EdgeInsets.all(5),
            title: SelectableText(item.key),
            subtitle: SelectableText(item.value.join("\n"))
          ),
      ],
    );
  }
}
