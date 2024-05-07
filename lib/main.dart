//------------------------------------import start------------------------------
//flutter packages
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
//Project files
//  data
import '/data/app_data.dart';

//  methods

//  widgets
import '/widgets/editor_mode.dart';

//  providers

//---------------------------------import end-----------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    minimumSize: Size(windowSizeWidthMinimum, windowSizeHeightMinimum),
    // fullScreen: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
