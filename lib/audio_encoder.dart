import 'package:wav/raw_file.dart';
import 'package:wav/wav.dart';

class AudioEncoder {
  static final encoder = throw UnimplementedError();

  Future<void> encode(x) => throw UnimplementedError();

  void x(String filePath, String outputFilePath) async {
    // String filePath = '';
    // String outputFilePath = '';
    final wav = Wav([], 0);

    // final wav = await Wav.readFile(filePath);
    await wav.writeFile(outputFilePath);
  }
}
