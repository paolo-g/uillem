import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/prompt/storage/csvpreset.dart';


class Presets extends StatefulWidget {
  const Presets({super.key});

  @override
  State<Presets> createState() => _PresetsState();
}

class _PresetsState extends State<Presets> {
  var _presets = [];

  @override
  void initState() {
    super.initState();
    loadPresets().then((presetsstring) {
      var presetsraw = presetsstring.split(RegExp(r'\r?\n'));
      var presets = [];
      for (var preset in presetsraw) {
        var exploded = preset.split(',');

        // Get rid of any blank lines
        if (exploded.length != 2) {
          continue;
        }

        var prompt = exploded[0];
        Uint8List bytesImage = const Base64Decoder().convert(exploded[1]);
        presets.add([prompt, bytesImage]);
      }
      setState(() {
        _presets = presets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var frontendState = context.watch<FrontendState>();
    var promptController = frontendState.promptController;

    return SizedBox(
      height: 200,
      width: 600,
      child: ListView(
        children: [
          for (var preset in _presets)
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Image.memory(preset[1], width: 99, height: 99),
              title: Text(preset[0]),
              onTap: () async {
                promptController.value = TextEditingValue(text: preset[0]);
                await frontendState.getPromptResult(preset[0]);
              },
            ),
        ],
      )
    );
  }
}
