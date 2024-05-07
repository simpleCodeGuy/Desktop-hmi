import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import '/methods/input_methods.dart';
import 'package:window_manager/window_manager.dart';
import '/data/app_data.dart';
import '/data/user_interface_data.dart';

class ElementCreateDialogNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final elementCreateDialogProvider = ChangeNotifierProvider(
  (ref) => ElementCreateDialogNotifier(),
);

class TemporaryNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}
