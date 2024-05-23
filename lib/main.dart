import 'dart:async';
import 'dart:io';

import 'package:auto_recorder/app.dart';
import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/file_dir.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/shared_preferences.dart';
import 'package:auto_recorder/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final sharedPreferences = await SharedPreferences.getInstance();
    final tempFileDir = (await getTemporaryDirectory()).path;
    final appDocumentsPath = (await getApplicationDocumentsDirectory()).path;
    final audioFileDir = '$appDocumentsPath/audios/';
    final databaseFileDir = '$appDocumentsPath/isar/';
    for (final dir in [databaseFileDir, audioFileDir]) {
      if (!Directory(dir).existsSync()) {
        Directory(dir).createSync(recursive: true);
      }
    }
    final isar = await Isar.open([RecordingSchema], directory: databaseFileDir);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          tempFileDirProvider.overrideWithValue(tempFileDir),
          audiosFileDirProvider.overrideWithValue(audioFileDir),
          databaseProvider.overrideWithValue(Database(isar)),
        ],
        child: const App(),
      ),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
