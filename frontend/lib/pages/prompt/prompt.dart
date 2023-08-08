import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/prompt/components/presets.dart';
import 'package:frontend/pages/prompt/components/result.dart';
import 'package:frontend/pages/prompt/components/search.dart';


class PromptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var enablePresets = FrontendState.enablePresets;
    var enablePrompt = FrontendState.enablePrompt;

    return Center(
      child: Column(
        children: [
          Visibility(
              visible: enablePresets,
              child: Presets()
          ),
          SizedBox(height: 10),
          Visibility(
              visible: enablePrompt,
              child: Search()
          ),
          SizedBox(height: 10),
          Result()
        ],
      ),
    );
  }
}
