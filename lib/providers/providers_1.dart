import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import '/methods/input_methods.dart';
import 'package:window_manager/window_manager.dart';
import '/data/app_data.dart';
import '/data/user_interface_data.dart';
import 'dart:async';

class MyAppNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final myAppProvider = ChangeNotifierProvider((ref) => MyAppNotifier());

class ScreenNotifier extends ChangeNotifier {
  void rebuild() {
    print('Canvas REBUILD');
    notifyListeners();
  }
}

final screenProvider = ChangeNotifierProvider((ref) => ScreenNotifier());

class ModeSelectNotifier extends ChangeNotifier {
  int page = 1;

  void selectUserMode() {
    page = 0;
    notifyListeners();
  }

  void selectEditMode() {
    page = 1;
    notifyListeners();
  }
}

final modeSelectProvider = ChangeNotifierProvider(
  (ref) => ModeSelectNotifier(),
);

class WindowStatusNotifier extends ChangeNotifier {
  bool isWindowMaximized = false;

  void windowHasBeenMaximized() {
    print('window has been maximized');
  }

  void maximizeUnmaximize({required WindowManager windowManager}) {
    bool temporaryStatusIsWindowMaximized;
    if (isWindowMaximized) {
      windowManager.unmaximize();
      isWindowMaximized = !isWindowMaximized;
    } else {
      windowManager.maximize();
      isWindowMaximized = !isWindowMaximized;
    }
  }

  void minimize({required WindowManager windowManager}) {
    windowManager.minimize();
  }

  void close({required WindowManager windowManager}) {
    windowManager.close();
  }
}

final windowStatusProvider = ChangeNotifierProvider(
  (ref) => WindowStatusNotifier(),
);

class TopBarButtonSelectorNotifier extends ChangeNotifier {
  bool settingsSelected = false;
  bool userManualSelected = false;
  bool aboutSelected = false;
  bool screenSelected = true;
  bool programLogicSelected = false;
  bool alarmsSelected = false;
  int mainPageSelect = 3;

  void selectSettings() {
    settingsSelected = true;
    userManualSelected = false;
    aboutSelected = false;
    screenSelected = false;
    programLogicSelected = false;
    alarmsSelected = false;
    mainPageSelect = 0;
    notifyListeners();
  }

  void selectUserManual() {
    settingsSelected = false;
    userManualSelected = true;
    aboutSelected = false;
    screenSelected = false;
    programLogicSelected = false;
    alarmsSelected = false;
    mainPageSelect = 1;
    notifyListeners();
  }

  void selectAbout() {
    settingsSelected = false;
    userManualSelected = false;
    aboutSelected = true;
    screenSelected = false;
    programLogicSelected = false;
    alarmsSelected = false;
    mainPageSelect = 2;
    notifyListeners();
  }

  void selectScreen() {
    settingsSelected = false;
    userManualSelected = false;
    aboutSelected = false;
    screenSelected = true;
    programLogicSelected = false;
    alarmsSelected = false;
    mainPageSelect = 3;
    notifyListeners();
  }

  void selectProgramLogic() {
    settingsSelected = false;
    userManualSelected = false;
    aboutSelected = false;
    screenSelected = false;
    programLogicSelected = true;
    alarmsSelected = false;
    mainPageSelect = 4;
    notifyListeners();
  }

  void selectAlarms() {
    settingsSelected = false;
    userManualSelected = false;
    aboutSelected = false;
    screenSelected = false;
    programLogicSelected = false;
    alarmsSelected = true;
    mainPageSelect = 5;
    notifyListeners();
  }
}

final topBarButtonSelectorProvider = ChangeNotifierProvider(
  (ref) => TopBarButtonSelectorNotifier(),
);

class ScreenBarButtonSelectorNotifier extends ChangeNotifier {
  bool contentScreenSelected = true;
  bool undoButtonSelected = false;
  bool redoButtonSelected = false;
  bool startSimulationButtonSelected = false;
  bool stopSimulationButtonSelected = false;
  bool lineButtonSelected = false;
  bool buttonsButtonSelected = false;
  bool lampsButtonSelected = false;
  bool myTextButtonSelected = false;
  bool gaugesAndMetersButtonSelected = false;
  bool alarmIndicatorButtonSelected = false;
  bool simpleShapesButtonSelected = false;
  int screenStackSelect = 0;
  double iconPadding = 5.0;

  void selectContentScreen() {
    contentScreenSelected = true;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 0;
    notifyListeners();
  }

  void selectUndo() {
    contentScreenSelected = false;
    undoButtonSelected = true;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 0;
    notifyListeners();
  }

  void selectRedo() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = true;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 0;
    notifyListeners();
  }

  void selectStartSimulation() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = true;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 0;
    notifyListeners();
  }

  void selectStopSimulation() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = true;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 0;
    notifyListeners();
  }

  void selectLine() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = true;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 1;
    notifyListeners();
  }

  void selectButtons() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = true;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 2;
    notifyListeners();
  }

  void selectLamps() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = true;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 3;
    notifyListeners();
  }

  void selectMyText() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = true;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 4;
    notifyListeners();
  }

  void selectGaugesAndMeters() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = true;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = false;
    screenStackSelect = 5;
    notifyListeners();
  }

  void selectAlarmIndicators() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected =
        true; //class ScreenTapNotfier extends ChangeNotifier {
    simpleShapesButtonSelected = false;
    screenStackSelect = 6;
    notifyListeners();
  }

  void selectSimpleShapes() {
    contentScreenSelected = false;
    undoButtonSelected = false;
    redoButtonSelected = false;
    startSimulationButtonSelected = false;
    stopSimulationButtonSelected = false;
    lineButtonSelected = false;
    buttonsButtonSelected = false;
    lampsButtonSelected = false;
    myTextButtonSelected = false;
    gaugesAndMetersButtonSelected = false;
    alarmIndicatorButtonSelected = false;
    simpleShapesButtonSelected = true;
    screenStackSelect = 7;
    notifyListeners();
  }
}

final screenBarButtonSelectorProvider = ChangeNotifierProvider(
  (ref) => ScreenBarButtonSelectorNotifier(),
);

class XYsnapPositionMessageNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final xySnapPositionMessageProvider =
    ChangeNotifierProvider((ref) => XYsnapPositionMessageNotifier());

class StatusMessageNotifier extends ChangeNotifier {
  void rebuild() {
    notifyListeners();
  }
}

final statusMessageProvider =
    ChangeNotifierProvider((ref) => StatusMessageNotifier());

final windowSizeStreamProvider = StreamProvider.autoDispose((ref) {
  return Stream.periodic(
    const Duration(milliseconds: 100),
    (_) => (
      width: MediaQuery.of(contextForWindowSizeProvider).size.width,
      height: MediaQuery.of(contextForWindowSizeProvider).size.height,
    ),
  ).takeWhile((_) => appData.closeSoftware == false);
});

// StreamController? controller = StreamController<bool>();

// StreamSubscription? streamSubscription;

// Stream<bool> ticker =
//     Stream.periodic(const Duration(milliseconds: 100), (_) => true)
//         .takeWhile(
//           (_) => appData.closeSoftware == false,
//         )
//         .asBroadcastStream();

// void startTickerLogic(Stream<bool> ticker, dynamic ref) {
//   double previousWindowWidth = 0;
//   double previousWindowHeight = 0;
//   double currentWindowWidth = 0;
//   double currentWindowHeight = 0;
//   ticker.listen((event) {
//     print('ticker element $event');
//     currentWindowWidth = MediaQuery.of(contextForWindowSizeProvider).size.width;
//     currentWindowHeight =
//         MediaQuery.of(contextForWindowSizeProvider).size.height;
//     if (currentWindowWidth != previousWindowWidth ||
//         currentWindowHeight != previousWindowHeight) {
//       var windowWidth = currentWindowWidth;
//       var windowHeight = currentWindowHeight;
//       var canvasWidth = windowWidth;
//       var canvasHeight = windowHeight -
//           appConfig.statusBar.height -
//           appConfig.topBar.height -
//           appConfig.topBarII.height;
//       ScreenSize.update(
//         appData.screenSize,
//         canvasSize: RectangularBoundary.fromXYminMaxValues(
//             xMinimum: 0,
//             yMinimum: 0,
//             xMaximum: canvasWidth,
//             yMaximum: canvasHeight),
//       );

//       previousWindowWidth = currentWindowWidth;
//       previousWindowHeight = currentWindowHeight;

//       ref.read(callbackProvider).window.screenSizeChanged(
//               currentScreenSize: RectangularBoundary.fromXYminMaxValues(
//             xMinimum: 0,
//             yMinimum: 0,
//             xMaximum: canvasWidth,
//             yMaximum: canvasHeight,
//           ));
//     }
//   });
// }

class CanvasSizeNotifier extends ChangeNotifier {
  double windowWidth = 0;
  double windowHeight = 0;
  double canvasWidth = 0;
  double canvasHeight = 0;
  dynamic ref;

  CanvasSizeNotifier({
    required this.ref,
    required this.windowWidth,
    required this.windowHeight,
  }) {
    canvasWidth = windowWidth;

    canvasHeight = windowHeight -
        appConfig.statusBar.height -
        appConfig.topBar.height -
        appConfig.topBarII.height;

    ScreenSize.update(
      appData.screenSize,
      canvasSize: RectangularBoundary.fromXYminMaxValues(
          xMinimum: 0,
          yMinimum: 0,
          xMaximum: canvasWidth,
          yMaximum: canvasHeight),
    );
  }

  void updateWindowWidthHeight(
      {required double width, required double height}) {
    windowWidth = width;
    windowHeight = height;
    canvasWidth = windowWidth;
    canvasHeight = windowHeight -
        appConfig.statusBar.height -
        appConfig.topBar.height -
        appConfig.topBarII.height;
    ScreenSize.update(
      appData.screenSize,
      canvasSize: RectangularBoundary.fromXYminMaxValues(
          xMinimum: 0,
          yMinimum: 0,
          xMaximum: canvasWidth,
          yMaximum: canvasHeight),
    );
    ref.read(callbackProvider).window.screenSizeChanged(
            currentScreenSize: RectangularBoundary.fromXYminMaxValues(
          xMinimum: 0,
          yMinimum: 0,
          xMaximum: canvasWidth,
          yMaximum: canvasHeight,
        ));
  }
}

final canvasSizeProvider = ChangeNotifierProvider(
  (ref) => CanvasSizeNotifier(
      ref: ref,
      windowWidth: MediaQuery.of(contextForWindowSizeProvider).size.width,
      windowHeight: MediaQuery.of(contextForWindowSizeProvider).size.height),
);

final windowSizeCompareStreamProvider =
    StreamProvider.autoDispose((ref) async* {
  final windowSizeStreamFuture = ref.watch(windowSizeStreamProvider.future);
  final windowSizeLatest = await windowSizeStreamFuture;
  final windowWidthOld = ref.read(canvasSizeProvider).windowWidth;
  final windowHeightOld = ref.read(canvasSizeProvider).windowHeight;

  if (windowSizeLatest.width != windowWidthOld ||
      windowSizeLatest.height != windowHeightOld) {
    ref.read(canvasSizeProvider).updateWindowWidthHeight(
          width: windowSizeLatest.width,
          height: windowSizeLatest.height,
        );
    yield (width: windowSizeLatest.width, height: windowSizeLatest.height);
  }
});

class PropertiesButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final propertiesButtonProvider =
    ChangeNotifierProvider((ref) => PropertiesButtonNotifier());

class DeleteOnScreenButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final deleteOnScreenButtonProvider =
    ChangeNotifierProvider((ref) => DeleteOnScreenButtonNotifier());

class SnapOnGridButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final snapOnGridButtonProvider =
    ChangeNotifierProvider((ref) => SnapOnGridButtonNotifier());

class SnapOnBoundaryButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final snapOnBoundaryButtonProvider =
    ChangeNotifierProvider((ref) => SnapOnBoundaryButtonNotifier());

class SnapOnEndPointsButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final snapOnEndPointsButtonProvider =
    ChangeNotifierProvider((ref) => SnapOnEndPointsButtonNotifier());

class SnapOnCentreButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final snapOnCentreButtonProvider =
    ChangeNotifierProvider((ref) => SnapOnCentreButtonNotifier());

class MoveOnScreenButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final moveOnScreenButtonProvider =
    ChangeNotifierProvider((ref) => MoveOnScreenButtonNotifier());

class CopyOnScreenButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final copyOnScreenButtonProvider =
    ChangeNotifierProvider((ref) => CopyOnScreenButtonNotifier());

class RotateOnScreenButtonNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final rotateOnScreenButtonProvider =
    ChangeNotifierProvider((ref) => RotateOnScreenButtonNotifier());

class WidgetTypeBooleanNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final widgetTypeBooleanProvider =
    ChangeNotifierProvider((ref) => WidgetTypeBooleanNotifier());

class WidgetTypeWidthNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final widgetTypeWidthProvider =
    ChangeNotifierProvider((ref) => WidgetTypeWidthNotifier());

class WidgetTypeColorNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final widgetTypeColorProvider =
    ChangeNotifierProvider((ref) => WidgetTypeColorNotifier());

class TextSizeNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final textSizeProvider = ChangeNotifierProvider((ref) => TextSizeNotifier());

class MultitextWidgetBooleanNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final multitextWidgetBooleanProvider = ChangeNotifierProvider(
  (ref) => MultitextWidgetBooleanNotifier(),
);

class MultitextWidgetTextNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final multitextWidgetTextProvider = ChangeNotifierProvider(
  (ref) => MultitextWidgetTextNotifier(),
);

class MultitextWidgetFontSizeNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final multitextWidgetFontSizeProvider = ChangeNotifierProvider(
  (ref) => MultitextWidgetFontSizeNotifier(),
);

class MultitextWidgetColorBackgroundNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final multitextWidgetColorBackgroundProvider = ChangeNotifierProvider(
  (ref) => MultitextWidgetColorBackgroundNotifier(),
);

class MultitextWidgetColorForegroundNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final multitextWidgetColorForegroundProvider = ChangeNotifierProvider(
  (ref) => MultitextWidgetColorForegroundNotifier(),
);

class MultitextDialogWidgetNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final multitextDialogWidgetProvider = ChangeNotifierProvider(
  (ref) => MultitextDialogWidgetNotifier(),
);

class ColorPickerNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

final colorPickerProvider = ChangeNotifierProvider(
  (ref) => ColorPickerNotifier(),
);

class RecordMultiTextNotifier extends ChangeNotifier {
  void rebuild() => notifyListeners();
}

/// {
///   dataType:
///     {
///       intgerKey : provider
///     }
/// }
Map<dynamic, dynamic> providerForScreenDialog = {};
