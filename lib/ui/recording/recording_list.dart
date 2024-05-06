import 'package:async/async.dart';
import 'package:auto_recorder/providers/remove_recording_service.dart';
import 'package:auto_recorder/providers/undo_remove_recording_service.dart';
import 'package:auto_recorder/recording.dart';
import 'package:auto_recorder/ui/recording/recording_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'recording_list.g.dart';

final playingRecordingProvider = StateProvider<Recording?>((ref) => null);

// final isPlayingProvider =
//     Provider<bool>((ref) => ref.watch(playingRecordingProvider) != null);

final isPlayingCurrentRecordingProvider =
    Provider.family<bool, Recording>((ref, recording) {
  final currentPlaying = ref.watch(playingRecordingProvider);
  return currentPlaying == recording;
});

@Riverpod(keepAlive: true)
class SelectingRecordings extends _$SelectingRecordings {
  @override
  List<Recording> build() => [];

  void unSelectAll() {
    state = [];
  }

  void select(Recording recording) {
    if (!state.contains(recording)) state = [...state, recording];
  }

  void unSelect(Recording recording) {
    if (state.contains(recording)) {
      state = state.where((r) => r != recording).toList();
    }
  }
}

class RecordingList extends ConsumerStatefulWidget {
  const RecordingList({super.key});

  @override
  RecordingListState createState() => RecordingListState();
}

class RecordingListState extends ConsumerState<RecordingList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final ListModel<Recording> _list;

  Widget _buildRemovedItem(
      Recording item, BuildContext context, Animation<double> animation) {
    throw UnimplementedError();
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    final recording = _list[index];
    return ProviderScope(
        overrides: [currentRecordingProvider.overrideWithValue(recording)],
        child: RecordingItem(animation, onDismiss: (recording) {
          _removeByDismiss(recording, index);
          showSnackBar(recording);
        }));
  }

  void _removeByDismiss(Recording target, int index) {
    _list.removeByDismiss(index);

    ref.read(removeRecordingServiceProvider).remove(target, index);
  }

  void showSnackBar(Recording recording) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Recording ${recording.id} deleted'),
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () => ref
                  .read(undoRemoveRecordingServiceProvider)
                  .undo(
                      onUndo: (int index, Recording recording) =>
                          _list.insert(index, recording)))));

  @override
  Widget build(BuildContext context) {
    return ref.watch(recordingsProvider).when(
          data: (value) {
            _list = ListModel<Recording>(
              listKey: _listKey,
              removedItemBuilder: _buildRemovedItem,
              initialItems: value,
            );

            return RefreshIndicator(
                onRefresh: () => ref.refresh(recordingsProvider.future),
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _list.length,
                  itemBuilder: _buildItem,
                ));
          },
          error: (error, _) => Text('Error: $error'),
          loading: () => const CircularProgressIndicator(),
        );
  }
}

@Riverpod(keepAlive: true)
Future<List<Recording>> recordings(RecordingsRef ref) => Future.delayed(
    const Duration(seconds: 3),
    () => List.generate(10, (index) => Recording(id: '$index')));

//  https://api.flutter.dev/flutter/widgets/AnimatedList-class.html
typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

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

  E removeWithAnimation(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  E removeByDismiss(int index) {
    final removedItem = _items.removeAt(index);
    _animatedList!.removeItem(
      index,
      (_, __) => const SizedBox.shrink(),
    );
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
