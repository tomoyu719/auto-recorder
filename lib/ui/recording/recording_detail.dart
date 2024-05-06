import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingDetail extends ConsumerWidget {
  const RecordingDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Detail'),
      ),
      body: const Center(
        child: Text('Recording Detail'),
      ),
    );
  }
}
