import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';


class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var frontendState = context.watch<FrontendState>();
    var promptController = frontendState.promptController;
    var isPrompting = frontendState.isPrompting;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 480,
          child: TextField(
            controller: promptController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'eg. Why is the sky blue?',
            ),
            onSubmitted: (prompt) async {
              await frontendState.getPromptResult(prompt);
            },
            readOnly: isPrompting,
            textInputAction: TextInputAction.search,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            await frontendState.getPromptResult(promptController.text);
          },
          icon: Icon(Icons.search),
          label: Text('Prompt'),
        ),
        SizedBox(width: 10),
        Visibility(
          visible: isPrompting,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
