import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;


Future<String> loadPresets() async {
  return await rootBundle.loadString('presets.csv');
}
