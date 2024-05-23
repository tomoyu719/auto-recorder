import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

final tempFileDirProvider = Provider<String>((_) => throw UnimplementedError(
    'tempFileDirProvider must override at main function',),);
final tempFilePathProvider = Provider.family<String, String>((ref, fileName) {
  final tempFileDir = ref.watch(tempFileDirProvider);
  return join(tempFileDir, fileName);
});
final audiosFileDirProvider = Provider<String>((_) => throw UnimplementedError(
    'tempFileDirProvider must override at main function',),);

final audioFilePathProvider = Provider.family<String, String>((ref, fileName) {
  final audioFileDir = ref.watch(audiosFileDirProvider);
  return join(audioFileDir, fileName);
});
