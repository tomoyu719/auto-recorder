import 'package:permission_handler/permission_handler.dart';

Future<bool> handlePermission(onConfirmPermission) async {
  final status = await Permission.microphone.status;
  if (status.isPermanentlyDenied) {
    onConfirmPermission();
    return false;
  } else {
    await Permission.microphone.request();
  }
  return status.isGranted;
}
