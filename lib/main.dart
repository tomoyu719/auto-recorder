import 'dart:io';

import 'package:auto_recorder/app.dart';
import 'package:auto_recorder/providers/file_dir.dart';
import 'package:auto_recorder/providers/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final appDocumentsPath = (await getApplicationDocumentsDirectory()).path;
  final audioFileDir = '$appDocumentsPath/audios';

  if (!Directory(audioFileDir).existsSync()) {
    Directory(audioFileDir).createSync(recursive: true);
  }

  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    fileDirProvider.overrideWithValue(audioFileDir),
  ], child: const App()));
}
