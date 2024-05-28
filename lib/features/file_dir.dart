import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'file_dir.g.dart';

@Riverpod(keepAlive: true)
String tempFileDir(TempFileDirRef ref) {
  throw UnimplementedError(
    'tempFileDirProvider must override at main function',
  );
}

@Riverpod(keepAlive: true)
String audiosFileDir(AudiosFileDirRef ref) {
  throw UnimplementedError(
    'audiosFileDirProvider must override at main function',
  );
}
