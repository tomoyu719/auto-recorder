import 'package:auto_recorder/dev/dev_screen.dart';
import 'package:auto_recorder/ui/recording/appbar.dart';
import 'package:auto_recorder/ui/recording/recording_button.dart';
import 'package:auto_recorder/ui/recording/recording_list.dart';
import 'package:flutter/material.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: RecordingButton(),
      appBar: MyAppBar(),
      body: Center(
        // child: DevScreen(),
        child: RecordingList(),
      ),
    );
  }
}
