import 'package:app_settings/app_settings.dart';
import 'package:auto_recorder/features/database.dart';
import 'package:auto_recorder/features/recording/model/recording.dart';
import 'package:auto_recorder/features/recording/sound_monitor/sound_monitor.dart';
import 'package:auto_recorder/features/recording/widget/recording_header.dart';
import 'package:auto_recorder/features/recording/widget/recording_list.dart';
import 'package:auto_recorder/features/recording/widget/recording_list_item.dart';
import 'package:auto_recorder/features/recording/widget/sound_level.dart';
import 'package:auto_recorder/features/remove_recording_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_page.g.dart';

class RecordingPage extends ConsumerStatefulWidget {
  const RecordingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RecordingPageState();
  }
}

@Riverpod(keepAlive: true)
Future<List<Recording>> fetchRecordings(FetchRecordingsRef ref) async {
  final allRecordings = await ref.watch(databaseProvider).getAll();
  return allRecordings..sort((a, b) => b.date!.compareTo(a.date!));
}

class RecordingPageState extends ConsumerState {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<Recording> _listModel;
  late final SoundMonitor soundMonitor;

  @override
  void initState() {
    soundMonitor = ref.read(
      soundMonitorProvider(
        onFinishRecording: (recording) {
          _listModel.insert(0, recording);
          ref.read(databaseProvider).add(recording);
        },
        openAppSettings: _openAppSettings,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    soundMonitor.passive();
    super.dispose();
  }

  Widget _buildRemovedItem(
    Recording item,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ProviderScope(
      overrides: [recordingListItemProvider.overrideWithValue(item)],
      child: RecordingItem(animation),
    );
  }

  void _openAppSettings() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Authorization required'),
        icon: const Icon(Icons.info),
        content: const Text('Please allow the app to use the microphone.'),
        actions: [
          TextButton(
            onPressed: () {
              AppSettings.openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Start monitoring',
        onPressed: () {
          final isActive = ref.read(isActiveProvider);
          isActive ? soundMonitor.passive() : soundMonitor.active();
        },
        child: Consumer(
          builder: (context, ref, child) => ref.watch(isActiveProvider)
              ? const Icon(Icons.stop)
              : const Icon(Icons.mic),
        ),
      ),
      appBar: RecordingHeader(
        soundMonitor,
        onTapRemove: () {
          final targetRecordings = ref.read(selectingRecordingsProvider);
          for (final recording in targetRecordings) {
            final index = _listModel.indexOf(recording);
            ref
                .read(removeRecordingServiceProvider)
                .onRemove(recording, index, isRequiredUndo: false);
            _listModel.remove(index);
          }
        },
      ),
      body: Stack(
        children: <Widget>[
          ref.watch(fetchRecordingsProvider).when(
                data: (value) {
                  _listModel = ListModel<Recording>(
                    listKey: _listKey,
                    initialItems: value,
                    removedItemBuilder: _buildRemovedItem,
                  );

                  return RecordingList(_listModel, _listKey);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
              ),
          const SoundLevelWidget(),
        ],
      ),
    );
  }
}

// ref to https://api.flutter.dev/flutter/widgets/AnimatedList-class.html
typedef RemovedItemBuilder<T> = Widget Function(
  T item,
  BuildContext context,
  Animation<double> animation,
);

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  E remove(int index, {bool isDoAnimation = true}) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) => isDoAnimation
            ? removedItemBuilder(removedItem, context, animation)
            : const SizedBox.shrink(),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
