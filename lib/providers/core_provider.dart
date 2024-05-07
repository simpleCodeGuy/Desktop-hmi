import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_hmi/methods/input_methods.dart';

// import 'package:window_manager/window_manager.dart';
// import '/data/app_data.dart';
// import '/data/user_interface_data.dart';
// import '/providers/providers_1.dart';

class CallbackNotifier extends ChangeNotifier {
  static dynamic ref;

  CallbackNotifier(refOfAppCoreProvider) {
    ref = refOfAppCoreProvider;
  }

  final screen = ScreenCallback();
  final window = WindowCallback();
  final keyboardPressed = KeyboardPressed();
}

final callbackProvider = ChangeNotifierProvider((ref) => CallbackNotifier(ref));
