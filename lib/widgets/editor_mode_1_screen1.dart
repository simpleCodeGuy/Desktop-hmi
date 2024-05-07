//------------------------------------import start------------------------------
//flutter packages
import 'package:simple_hmi/methods/input_methods.dart';

import '/main.dart';
import 'package:flutter/gestures.dart';
// import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
//project files
//  data
import '/data/app_data.dart';
import '../data/configuration.dart';
import '/data/logic_page_data.dart';
import '/data/modbus_data.dart';
import '/data/user_interface_data.dart';
import '/classes/enumerations.dart';
//  methods

//  widgets
import '/widgets/editor_mode_1_screen2.dart';

//  providers
import '/providers/providers_1.dart';

//------------------------------------import end--------------------------------
class ScreenContent extends ConsumerWidget {
  const ScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = FocusNode();

    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: (keyPress) {
        if (keyPress is RawKeyDownEvent) {
          if (keyPress.isShiftPressed) {
            appData.buttonConstantPress.shiftPressedScreenPointerDown_();
          }
          if (keyPress.isKeyPressed(LogicalKeyboardKey.controlLeft) ||
              keyPress.isKeyPressed(LogicalKeyboardKey.controlRight)) {
            print('control key is pressed down');
            appData.buttonConstantPress.ctrlPressedScreenPointerDown_();
          }
        } else if (keyPress is RawKeyUpEvent) {
          appData.buttonConstantPress.shiftPressedScreenPointerUp_();
          appData.buttonConstantPress.ctrlPressedScreenPointerUp_();
        }
      },
      child: Listener(
        onPointerSignal: (event) {
          FocusScope.of(context).requestFocus(focusNode);
          if (event is PointerScrollEvent) {
            //scroll down
            if (event.scrollDelta.dy > 0) {
              if (appData.buttonConstantPress.ctrlPressedScreen) {
                MoveScreen.zoomOut(appData.moveScreen);
              } else if (appData.buttonConstantPress.shiftPressedScreen) {
                MoveScreen.rightShift(appData.moveScreen);
              } else {
                MoveScreen.downShift(appData.moveScreen);
              }

              CanvasMovementCallback.update_after_each_canvas_movement_click();
            }
            //scroll up
            else {
              if (appData.buttonConstantPress.ctrlPressedScreen) {
                MoveScreen.zoomIn(appData.moveScreen);
              } else if (appData.buttonConstantPress.shiftPressedScreen) {
                MoveScreen.leftShift(appData.moveScreen);
              } else {
                MoveScreen.upShift(appData.moveScreen);
              }

              CanvasMovementCallback.update_after_each_canvas_movement_click();
            }
          }
        },
        child: Stack(
          children: [
            const Screen(),
            IndexedStack(
              index: screenBarButtonSelectorNotifier.screenStackSelect,
              children: const [
                DummyContainer(),
                LineContent(),
                ButtonsContent(),
                LampsContent(),
                MyTextContent(),
                GaugesAndMetersContent(),
                AlarmIndicatorContent(),
                SimpleShapesContent(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenPage extends ConsumerWidget {
  const ScreenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color.fromARGB(255, 6, 37, 84),
      child: const Column(
        children: [
          ScreenTopBar(),
          ScreenContent(),
        ],
      ),
    );
  }
}

// class StatusBarScreen extends ConsumerWidget {
//   const StatusBarScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final statusBarConfigNotifier = ref.watch(statusBarConfigProvider);
//     return Container(
//       height: statusBarConfigNotifier.height,
//       color: statusBarConfigNotifier.backgroundColor,
//     );
//   }
// }

class ScreenTopBar extends ConsumerWidget {
  const ScreenTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController controller = ScrollController();
    return Container(
      color: appConfig.topBarII.backgroundUnselected,
      height: appConfig.topBarII.height,
      width: double.infinity,
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final offset = event.scrollDelta.dy;
            controller.jumpTo(controller.offset + offset / 4);
          }
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            scrollbarTheme: ScrollbarThemeData(
              thumbColor:
                  MaterialStateProperty.all(appConfig.topBarII.scrollBarColor),
              crossAxisMargin: 0,
            ),
          ),
          child: Scrollbar(
            controller: controller,
            thickness: appConfig.topBarII.scrollBarThickness,
            child: ListView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: const [
                DummyWidgetForWindowSizeCompareStreamProvider(),
                MoveScreenTopLeftButton(),
                MoveScreenLeftButton(),
                MoveScreenRightButton(),
                MoveScreenUpButton(),
                MoveScreenDownButton(),
                ZoomOriginal(),
                ZoomIn(),
                ZoomOut(),
                SeparatorForTabBar(),
                StartSimulationButton(),
                StopSimulationButton(),
                // UndoButton(),
                // RedoButton(),
                SeparatorForTabBar(),
                CancelOnScreenButton(),
                CopyOnScreenButton(),
                CopyMultipleOnScreenButton(),
                MoveOnScreenButton(),
                RotateOnScreenButton(),
                PropertiesOnScreenButton(),
                DeleteOnScreenButton(),
                SeparatorForTabBar(),
                SnapOnGridButton(),
                SnapOnEndPointsButton(),
                SnapOnCentreButton(),
                SnapOnBoundaryButton(),
                SeparatorForTabBar(),
                LineButton(),
                SimpleShapesButton(),
                MyTextButton(),
                ButtonsButton(),
                GaugesAndMetersButton(),
                LampsButton(),
                AlarmIndicatorButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SeparatorForTabBar extends ConsumerWidget {
  const SeparatorForTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: appConfig.topBarII.widthIcon / 3,
      height: appConfig.topBarII.heightIcon,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Image.asset(
          'assets/icons/separator.png',
          color: appConfig.topBarII.separator,
        ),
      ),
    );
  }
}

class MoveScreenTopLeftButton extends ConsumerWidget {
  const MoveScreenTopLeftButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Move screen Top Left',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            CanvasMovementCallback.topLeft();
          },
          child: Image.asset(
            'assets/icons/arrow-top-left.png',
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class MoveScreenLeftButton extends ConsumerWidget {
  const MoveScreenLeftButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return Tooltip(
    //   message: 'Move screen Left',
    //   waitDuration: appConfig.topBarII.toolTipWaitDuration,
    //   child: Container(
    //     width: appConfig.topBarII.widthIcon,
    //     height: appConfig.topBarII.heightIcon,
    //     color: appConfig.topBarII.backgroundUnselected,
    //     child: TextButton(
    //       onPressed: () {
    //         CanvasMovementCallback.left();
    //       },
    //       child: Image.asset(
    //         'assets/icons/arrow-left.png',
    //         color: appConfig.topBarII.unselected,
    //       ),
    //     ),
    //   ),
    // );

    return Tooltip(
      message: 'Move screen Left',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.height,
        color: appConfig.topBarII.backgroundUnselected,
        child: Listener(
          onPointerDown: (details) {
            appData.buttonConstantPress.moveScreenLeftButtonPointerDown_();
            appData.buttonConstantPress
                .moveScreenLeftButtonConstantPressOperation_(
                    appData.moveScreen);
          },
          onPointerUp: (details) {
            appData.buttonConstantPress.moveScreenLeftButtonPointerUp_();
          },
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/icons/arrow-left.png',
              color: appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class MoveScreenRightButton extends ConsumerWidget {
  const MoveScreenRightButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Move screen Right',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.height,
        color: appConfig.topBarII.backgroundUnselected,
        child: Listener(
          onPointerDown: (details) {
            appData.buttonConstantPress.moveScreenRightButtonPointerDown_();
            appData.buttonConstantPress
                .moveScreenRightButtonConstantPressOperation_(
                    appData.moveScreen);
          },
          onPointerUp: (details) {
            appData.buttonConstantPress.moveScreenRightButtonPointerUp_();
          },
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/icons/arrow-right.png',
              color: appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class MoveScreenUpButton extends ConsumerWidget {
  const MoveScreenUpButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Move screen Up',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.height,
        color: appConfig.topBarII.backgroundUnselected,
        child: Listener(
          onPointerDown: (details) {
            appData.buttonConstantPress.moveScreenUpButtonPointerDown_();
            appData.buttonConstantPress
                .moveScreenUpButtonConstantPressOperation_(appData.moveScreen);
          },
          onPointerUp: (details) {
            appData.buttonConstantPress.moveScreenUpButtonPointerUp_();
          },
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/icons/arrow-up.png',
              color: appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class MoveScreenDownButton extends ConsumerWidget {
  const MoveScreenDownButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Move screen Down',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.height,
        color: appConfig.topBarII.backgroundUnselected,
        child: Listener(
          onPointerDown: (details) {
            appData.buttonConstantPress.moveScreenDownButtonPointerDown_();
            appData.buttonConstantPress
                .moveScreenDownButtonConstantPressOperation_(
                    appData.moveScreen);
          },
          onPointerUp: (details) {
            appData.buttonConstantPress.moveScreenDownButtonPointerUp_();
          },
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/icons/arrow-down.png',
              color: appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class ZoomOriginal extends ConsumerWidget {
  const ZoomOriginal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Zoom Original 100%',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            // ref.read(appCoreProvider).zoomOriginalButtonPressed();
            CanvasMovementCallback.zoomOriginal();
          },
          child: Image.asset(
            'assets/icons/zoom-original.png',
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class ZoomIn extends ConsumerWidget {
  const ZoomIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Zoom In',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.height,
        color: appConfig.topBarII.backgroundUnselected,
        child: Listener(
          onPointerDown: (details) {
            appData.buttonConstantPress.zoomInScreenButtonPointerDown_();
            appData.buttonConstantPress
                .zoomInScreenButtonConstantPressOperation_(appData.moveScreen);
          },
          onPointerUp: (details) {
            appData.buttonConstantPress.zoomInButtonPointerUp_();
          },
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/icons/zoom-in.png',
              color: appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class ZoomOut extends ConsumerWidget {
  const ZoomOut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Zoom Out',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.height,
        color: appConfig.topBarII.backgroundUnselected,
        child: Listener(
          onPointerDown: (details) {
            appData.buttonConstantPress.zoomOutScreenButtonPointerDown_();
            appData.buttonConstantPress
                .zoomOutScreenButtonConstantPressOperation_(appData.moveScreen);
          },
          onPointerUp: (details) {
            appData.buttonConstantPress.zoomOutButtonPointerUp_();
          },
          child: TextButton(
            onPressed: () {},
            child: Image.asset(
              'assets/icons/zoom-out.png',
              color: appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class UndoButton extends ConsumerWidget {
  const UndoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Undo',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        // width: topBarConfigurationNotifier.widthIconScreenTopBar,
        width: appConfig.topBarII.widthIcon,
        // height: topBarConfigurationNotifier.heightIconScreenTopBar,
        height: appConfig.topBarII.heightIcon,
        // color: appColorThemeNotifier.tabBarBackground,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .operations
                .undoButtonPressed();
          },
          child: Icon(
            Icons.undo,
            semanticLabel: 'Undo',
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class RedoButton extends ConsumerWidget {
  const RedoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Redo',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .operations
                .redoButtonPressed();
          },
          child: Icon(
            Icons.redo,
            semanticLabel: 'Redo',
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class DummyWidgetForWindowSizeCompareStreamProvider extends ConsumerWidget {
  const DummyWidgetForWindowSizeCompareStreamProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowSizeAsyncValue = ref.watch(windowSizeCompareStreamProvider);
    return windowSizeAsyncValue.when(
      error: (error, stackTrace) => const SizedBox(),
      loading: () => const SizedBox(),
      data: (value) {
        return const SizedBox();
      },
    );

    // return SizedBox();
  }
}

class StartSimulationButton extends ConsumerWidget {
  const StartSimulationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Start Simulation',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .operations
                .startSimulationButtonPressed();
          },
          child: Icon(
            Icons.play_circle,
            semanticLabel: 'Start Simulation',
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class StopSimulationButton extends ConsumerWidget {
  const StopSimulationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Stop Simulation',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .operations
                .stopSimulationButtonPressed();
          },
          child: Icon(
            Icons.stop_circle,
            semanticLabel: 'Stop Simulation',
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class CancelOnScreenButton extends ConsumerWidget {
  const CancelOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copyOnScreenButtonNotifier = ref.watch(copyOnScreenButtonProvider);

    return Tooltip(
      message: 'Cancel',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            OperationsCallback.cancelOnScreenButtonPressed();
          },
          child: ImageIcon(
            const AssetImage('assets/icons/cancel.png'),
            color: appConfig.topBarII.unselected,
          ),
        ),
      ),
    );
  }
}

class CopyOnScreenButton extends ConsumerWidget {
  const CopyOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copyOnScreenButtonNotifier = ref.watch(copyOnScreenButtonProvider);

    return Tooltip(
      message: 'Copy',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: appData.selectParameters.numberOfItemsSelected > 0
              ? () {
                  OperationsCallback.copyOnScreenButtonPressed();
                }
              : null,
          child: Icon(
            Icons.copy_rounded,
            semanticLabel: 'Copy one time',
            color: appData.selectParameters.numberOfItemsSelected > 0
                ? appConfig.topBarII.unselected
                : appConfig.topBarII.disabled,
          ),
        ),
      ),
    );
  }
}

class CopyMultipleOnScreenButton extends ConsumerWidget {
  const CopyMultipleOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copyOnScreenButtonNotifier = ref.watch(copyOnScreenButtonProvider);

    return Tooltip(
      message: 'Copy Multiple times',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: appData.selectParameters.numberOfItemsSelected > 0
              ? () {
                  OperationsCallback.copyMultipleOnScreenButtonPressed();
                }
              : null,
          child: Icon(
            Icons.copy_all_rounded,
            semanticLabel: 'Copy multiple times',
            color: appData.selectParameters.numberOfItemsSelected > 0
                ? appConfig.topBarII.unselected
                : appConfig.topBarII.disabled,
          ),
        ),
      ),
    );
  }
}

class MoveOnScreenButton extends ConsumerWidget {
  const MoveOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moveOnScreenButtonNotifier = ref.watch(moveOnScreenButtonProvider);

    return Tooltip(
      message: 'Move',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: appData.selectParameters.numberOfItemsSelected > 0
              ? () {
                  OperationsCallback.moveOnScreenButtonPressed();
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(3),
            //padding: EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/move.png'),
              color: appData.selectParameters.numberOfItemsSelected > 0
                  ? appConfig.topBarII.unselected
                  : appConfig.topBarII.disabled,
            ),
          ),
        ),
      ),
    );
  }
}

class RotateOnScreenButton extends ConsumerWidget {
  const RotateOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotateOnScreenButtonNotifier =
        ref.watch(rotateOnScreenButtonProvider);

    return Tooltip(
      message: 'Rotate',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: appData.selectParameters.numberOfItemsSelected > 0
              ? () {
                  OperationsCallback.rotateOnScreenButtonPressed();
                }
              : null,
          child: Container(
            // padding: EdgeInsets.all(0),
            // padding: EdgeInsets.all(),
            child: ImageIcon(
              const AssetImage('assets/icons/angle.png'),
              color: appData.selectParameters.numberOfItemsSelected > 0
                  ? appConfig.topBarII.unselected
                  : appConfig.topBarII.disabled,
            ),
          ),
        ),
      ),
    );
  }
}

class PropertiesOnScreenButton extends ConsumerWidget {
  const PropertiesOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesButtonNotifier = ref.watch(propertiesButtonProvider);

    return Tooltip(
      message: 'Edit properties',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: SizedBox(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        child: TextButton(
          onPressed: appData.selectParameters.numberOfItemsSelected == 1
              ? () {
                  OperationsCallback.editPropertiesButtonPressed();
                }
              : null,
          child: Icon(
            Icons.edit,
            semanticLabel: 'Edit properties of item',
            color: appData.selectParameters.numberOfItemsSelected == 1
                ? appConfig.topBarII.unselected
                : appConfig.topBarII.disabled,
          ),
        ),
      ),
    );
  }
}

class DeleteOnScreenButton extends ConsumerWidget {
  const DeleteOnScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteOnScreenButtonNotifier =
        ref.watch(deleteOnScreenButtonProvider);

    return Tooltip(
      message: 'Delete',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: SizedBox(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        child: TextButton(
          onPressed: appData.selectParameters.numberOfItemsSelected > 0
              ? () {
                  ref
                      .read(callbackProvider)
                      .screen
                      .topBar
                      .operations
                      .deleteButtonPressed();
                }
              : null,
          child: Icon(
            Icons.delete,
            semanticLabel: 'Delete selected item',
            color: appData.selectParameters.numberOfItemsSelected > 0
                ? appConfig.topBarII.unselected
                : appConfig.topBarII.disabled,
          ),
        ),
      ),
    );
  }
}

class SnapOnGridButton extends ConsumerWidget {
  const SnapOnGridButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapOnGridButtonNotifier = ref.watch(snapOnGridButtonProvider);

    return Tooltip(
      message: 'Snap on Grid',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .snap
                .snapOnGridButtonPressed();
          },
          child: SizedBox(
            //padding: EdgeInsets.all(0),
            // padding:
            // EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/snap_grid.png'),
              // color: appColorThemeNotifier.toggleButtonSelectedForegroundColor
              color: appData.snapPoints.snapSelection[SnapOn.grid] == true
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class SnapOnBoundaryButton extends ConsumerWidget {
  const SnapOnBoundaryButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapOnBoundaryButtonNotifier =
        ref.watch(snapOnBoundaryButtonProvider);

    return Tooltip(
      message: 'Snap on Boundary',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .snap
                .snapOnBoundaryButtonPressed();
          },
          child: Container(
            //padding: EdgeInsets.all(0),
            // padding:
            //     EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/snap_boundary.png'),
              color: appData.snapPoints.snapSelection[SnapOn.boundary] == true
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class SnapOnEndPointsButton extends ConsumerWidget {
  const SnapOnEndPointsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapOnEndPointsButtonNotifier =
        ref.watch(snapOnEndPointsButtonProvider);

    return Tooltip(
      message: 'Snap on End Points',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .snap
                .snapOnEndPointButtonPressed();
          },
          child: Container(
            // padding:
            //     EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/snap_end_points.png'),
              color: appData.snapPoints.snapSelection[SnapOn.endPoint] == true
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class SnapOnCentreButton extends ConsumerWidget {
  const SnapOnCentreButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapOnCentreButtonNotifier = ref.watch(snapOnCentreButtonProvider);
//    final snapSettingsNotifier = ref.watch(snapSettingsProvider);

    return Tooltip(
      message: 'Snap on Centre',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref
                .read(callbackProvider)
                .screen
                .topBar
                .snap
                .snapOnCentreButtonPressed();
          },
          child: Container(
            // padding:
            //     EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/snap_centre.png'),
              color: appData.snapPoints.snapSelection[SnapOn.centre] == true
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class LineButton extends ConsumerWidget {
  const LineButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Line',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.lineButtonSelected == true
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: ref.read(screenBarButtonSelectorProvider).selectLine,
          child: Container(
            padding: const EdgeInsets.all(2),
            child: ImageIcon(
              const AssetImage('assets/icons/line.png'),
              color: screenBarButtonSelectorNotifier.lineButtonSelected == true
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonsButton extends ConsumerWidget {
  const ButtonsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Buttons',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.buttonsButtonSelected == true
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: ref.read(screenBarButtonSelectorProvider).selectButtons,
          child: Container(
            padding:
                EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              // const AssetImage('assets/icons/button.png'),
              const AssetImage('assets/icons/toggle_button.png'),
              color:
                  screenBarButtonSelectorNotifier.buttonsButtonSelected == true
                      ? appConfig.topBarII.selected
                      : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class LampsButton extends ConsumerWidget {
  const LampsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Lamps',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.lampsButtonSelected == true
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: ref.read(screenBarButtonSelectorProvider).selectLamps,
          child: Container(
            padding:
                EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/lamp.png'),
              color: screenBarButtonSelectorNotifier.lampsButtonSelected == true
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextButton extends ConsumerWidget {
  const MyTextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Text',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.myTextButtonSelected == true
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: ref.read(screenBarButtonSelectorProvider).selectMyText,
          child: Container(
            padding:
                EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/text_mono.png'),
              color: screenBarButtonSelectorNotifier.myTextButtonSelected
                  ? appConfig.topBarII.selected
                  : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class GaugesAndMetersButton extends ConsumerWidget {
  const GaugesAndMetersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Gauges and Meters',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.gaugesAndMetersButtonSelected
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed:
              ref.read(screenBarButtonSelectorProvider).selectGaugesAndMeters,
          child: Container(
            padding:
                EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/gauge_thin.png'),
              color:
                  screenBarButtonSelectorNotifier.gaugesAndMetersButtonSelected
                      ? appConfig.topBarII.selected
                      : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class AlarmIndicatorButton extends ConsumerWidget {
  const AlarmIndicatorButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Alarm Indicators',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.alarmIndicatorButtonSelected
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed:
              ref.read(screenBarButtonSelectorProvider).selectAlarmIndicators,
          child: Container(
            padding:
                EdgeInsets.all(screenBarButtonSelectorNotifier.iconPadding),
            child: ImageIcon(
              const AssetImage('assets/icons/alarm.png'),
              color:
                  screenBarButtonSelectorNotifier.alarmIndicatorButtonSelected
                      ? appConfig.topBarII.selected
                      : appConfig.topBarII.unselected,
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleShapesButton extends ConsumerWidget {
  const SimpleShapesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenBarButtonSelectorNotifier =
        ref.watch(screenBarButtonSelectorProvider);

    return Tooltip(
      message: 'Simple Shapes',
      waitDuration: appConfig.topBarII.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBarII.widthIcon,
        height: appConfig.topBarII.heightIcon,
        color: screenBarButtonSelectorNotifier.simpleShapesButtonSelected
            ? appConfig.topBarII.backgroundSelected
            : appConfig.topBarII.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref.read(screenBarButtonSelectorProvider).selectSimpleShapes();
          },
          child: Icon(
            Icons.rectangle_outlined,
            semanticLabel: 'Rectangle', //used in accessibility mode
            color: screenBarButtonSelectorNotifier.simpleShapesButtonSelected
                ? appConfig.topBarII.selected
                : appConfig.topBarII.unselected,
          ),
        ),
        // ),
      ),
    );
  }
}

class DummyContainer extends ConsumerWidget {
  const DummyContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox(
      width: 1,
      height: 1,
    );
  }
}

class LineContent extends ConsumerWidget {
  const LineContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final screenNotifier = ref.watch(screenProvider);

    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        // height: appDimensionsNotifier.dropDownHeight,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Scrollbar(
          thickness: 1.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              Line(),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonsContent extends ConsumerWidget {
  const ButtonsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Scrollbar(
          thickness: 1.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              TextButtonIcon(),
              ToggleButtonIcon(),
            ],
          ),
        ),
      ),
    );
  }
}

class LampsContent extends ConsumerWidget {
  const LampsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Text(
          'Lamps Content',
          style: TextStyle(
            color: appConfig.screen.dropDown.foreground,
          ),
        ),
      ),
    );
  }
}

class MyTextContent extends ConsumerWidget {
  const MyTextContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Scrollbar(
          thickness: 1.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              TextForMimic(),
              MultiTextForMimic(),
            ],
          ),
        ),
      ),
    );
  }
}

class GaugesAndMetersContent extends ConsumerWidget {
  const GaugesAndMetersContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Text(
          'Gauges and Meters Content',
          style: TextStyle(
            color: appConfig.screen.dropDown.foreground,
          ),
        ),
      ),
    );
  }
}

class AlarmIndicatorContent extends ConsumerWidget {
  const AlarmIndicatorContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Text(
          'Alarm Indicator Content',
          style: TextStyle(
            color: appConfig.screen.dropDown.foreground,
          ),
        ),
      ),
    );
  }
}

class SimpleShapesContent extends ConsumerWidget {
  const SimpleShapesContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onExit: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        width: double.infinity,
        height: appConfig.screen.dropDown.height,
        color: appConfig.screen.dropDown.background,
        child: Scrollbar(
          thickness: 1.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              Rectangle(),
              CircleCentrePoint(),
              CirclePointPoint(),
              // Rhombus(),
            ],
          ),
        ),
      ),
    );
  }
}
