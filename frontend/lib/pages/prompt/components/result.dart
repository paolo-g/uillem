import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';


class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    var frontendState = context.watch<FrontendState>();
    var paragraphs = frontendState.paragraphs;

    return SizedBox(
        height: 440,
        width: 600,
        child: ListView(
          children: [
            for (var paragraph in paragraphs)
              ListTile(
                title: SelectableText(paragraph),
              ),
          ],
        )
    );
  }
}
