//flutter packages
import 'package:flutter/gestures.dart';
// import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';
//project files
//  data
import '/data/app_data.dart';
import '../data/configuration.dart';
import '/data/logic_page_data.dart';
import '/data/modbus_data.dart';
import '/data/user_interface_data.dart';

//  methods

//  widgets
import '/widgets/editor_mode_1_screen2.dart';
import '/widgets/editor_mode_1_screen1.dart';
import '/widgets/editor_mode_2_logic_part_1.dart';
import '/widgets/editor_mode_3_alarm.dart';

//  providers
import '/providers/providers_1.dart';
//-----import end------

class EscapeIntent extends Intent {}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    buildContext = context;

    final modeSelectNotifier = ref.watch(modeSelectProvider);
    final myAppNotifier = ref.watch(myAppProvider);

    contextForWindowSizeProvider = context;

    return MaterialApp(
      title: 'HMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: SafeArea(
        child: Scaffold(
          body: Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent(),
            },
            child: Actions(
              actions: {
                EscapeIntent: CallbackAction<EscapeIntent>(
                  onInvoke: (EscapeIntent intent) {
                    ref
                        .read(callbackProvider)
                        .keyboardPressed
                        .escapePressedInApp();
                    return 0;
                  },
                ),
              },
              child: Focus(
                autofocus: true,
                child: IndexedStack(
                  index: modeSelectNotifier.page,
                  children: const [
                    UserModePage(),
                    EditModePage(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserModePage extends ConsumerWidget {
  const UserModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Text('User Mode Page'),
    );
  }
}

class EditModePage extends ConsumerWidget {
  const EditModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: appConfig.screen.content.background,
      child: const Column(
        children: [
          TopBar(),
          MainPagesStack(),
        ],
      ),
    );
  }
}

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onHover: (event) {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
      },
      child: Container(
        height: appConfig.statusBar.height + appConfig.topBar.height,
        color: appConfig.topBar.backgroundUnselected,
        child: const Column(
          children: [
            TitleBarEditMode(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TopBarLeftButtonsGroup(),
                Spacer(),
                ThreeButtons(),
                Spacer(),
                WindowControlButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopBarLeftButtonsGroup extends ConsumerWidget {
  const TopBarLeftButtonsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      children: [
        OpenFileIcon(),
        SaveFileIcon(),
        SettingsIcon(),
        UserManualIcon(),
        AboutIcon(),
      ],
    );
  }
}

class TitleBarEditMode extends ConsumerWidget {
  const TitleBarEditMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: appConfig.statusBar.height,
      child: const Row(
        children: [
          StatusBarMessage(),
          Spacer(),
          XYsnapPosition(),
        ],
      ),
    );
  }
}

class StatusBarMessage extends ConsumerWidget {
  const StatusBarMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // width: statusBoxConfigNotifier.width,
      height: appConfig.xyBox.height,
      color: appConfig.xyBox.background,
      padding: EdgeInsets.fromLTRB(
        appConfig.xyBox.leftPadding,
        appConfig.xyBox.topPadding,
        appConfig.xyBox.rightPadding,
        appConfig.xyBox.bottomPadding,
      ),
      child: const StatusMessage(),
    );
  }
}

extension OnDouble on double {
  String get uptoSingleDecimalAsString {
    return ((this * 10).toInt().toDouble() / 10).toString();
  }

  double get uptoSingleDecimal {
    return (this * 10).toInt().toDouble() / 10;
  }
}

class XYsnapPosition extends ConsumerWidget {
  const XYsnapPosition({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xySnapPositionMessageNotifier =
        ref.watch(xySnapPositionMessageProvider);
    return SizedBox(
      width: appConfig.xyBox.xyMessageWidth,
      height: appConfig.xyBox.height,
      child: Text(
        appData.snapPoints.mouseInsideScreen
            ? '${appData.snapPoints.snapPointOnScreen.x.uptoSingleDecimal}, ${appData.snapPoints.snapPointOnScreen.y.uptoSingleDecimal}'
            : '',
        textAlign: TextAlign.center,
        style: TextStyle(color: appConfig.xyBox.foreground),
      ),
    );
  }
}

class StatusMessage extends ConsumerWidget {
  const StatusMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusMessageNotifier = ref.watch(statusMessageProvider);

    return AutoSizeText(
      appData.statusBarMessage.text,
      style: TextStyle(
        color: appConfig.statusBar.foreground,
        fontSize: appConfig.statusBar.fontSize,
      ),
      overflowReplacement: Marquee(
        text: appData.statusBarMessage.text,
        style: TextStyle(
          color: appConfig.statusBar.foreground,
          fontSize: appConfig.statusBar.fontSize,
        ),
        blankSpace: 100,
      ),
    );
  }
}

class OpenFileIcon extends ConsumerWidget {
  const OpenFileIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Open existing Project',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        color: appConfig.topBar.backgroundUnselected,
        child: TextButton(
          onPressed: () {},
          child: Icon(
            Icons.file_copy_outlined,
            semanticLabel: 'Open existing Project',
            color: appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class SaveFileIcon extends ConsumerWidget {
  const SaveFileIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Save',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        color: appConfig.topBar.backgroundUnselected,
        child: TextButton(
          onPressed: () {},
          child: Icon(
            Icons.save,
            semanticLabel: 'Save',
            color: appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class SettingsIcon extends ConsumerWidget {
  const SettingsIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return Tooltip(
      message: 'Settings',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        color: topBarButtonSelectorNotifier.settingsSelected == true
            ? appConfig.topBar.backgroundSelected
            : appConfig.topBar.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref.read(topBarButtonSelectorProvider).selectSettings();
          },
          child: Icon(
            Icons.settings,
            semanticLabel: 'Settings',
            color: topBarButtonSelectorNotifier.settingsSelected == true
                ? appConfig.topBar.selected
                : appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class UserManualIcon extends ConsumerWidget {
  const UserManualIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return Tooltip(
      message: 'User Manual',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        color: topBarButtonSelectorNotifier.userManualSelected == true
            ? appConfig.topBar.backgroundSelected
            : appConfig.topBar.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref.read(topBarButtonSelectorProvider).selectUserManual();
          },
          child: Icon(
            Icons.help,
            semanticLabel: 'User Manual',
            color: topBarButtonSelectorNotifier.userManualSelected == true
                ? appConfig.topBar.selected
                : appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class AboutIcon extends ConsumerWidget {
  const AboutIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return Tooltip(
      message: 'About',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: Container(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        color: topBarButtonSelectorNotifier.aboutSelected == true
            ? appConfig.topBar.backgroundSelected
            : appConfig.topBar.backgroundUnselected,
        child: TextButton(
          onPressed: () {
            ref.read(topBarButtonSelectorProvider).selectAbout();
          },
          child: Icon(
            Icons.info,
            semanticLabel: 'About',
            color: topBarButtonSelectorNotifier.aboutSelected == true
                ? appConfig.topBar.selected
                : appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class ThreeButtons extends ConsumerWidget {
  const ThreeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      children: [
        ScreenButton(),
        ProgramLogicButton(),
        AlarmsButton(),
      ],
    );
  }
}

class ScreenButton extends ConsumerWidget {
  const ScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return SizedBox(
      width: appConfig.topBar.widthTextButton,
      height: appConfig.topBar.heightTextButton,
      child: OutlinedButton(
        onPressed: () {
          ref.read(topBarButtonSelectorProvider).selectScreen();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: topBarButtonSelectorNotifier.screenSelected
              ? appConfig.topBar.backgroundSelected
              : appConfig.topBar.backgroundUnselected,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
        child: Text(
          'Mimic',
          style: TextStyle(
            fontWeight: topBarButtonSelectorNotifier.screenSelected &&
                    appConfig.topBar.boldFont
                ? FontWeight.bold
                : FontWeight.normal,
            color: topBarButtonSelectorNotifier.screenSelected
                ? appConfig.topBar.selected
                : appConfig.topBar.unselected,
            fontSize: appConfig.topBar.fontSizeTextButton,
          ),
        ),
      ),
    );
  }
}

class ProgramLogicButton extends ConsumerWidget {
  const ProgramLogicButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return SizedBox(
      width: appConfig.topBar.widthTextButton,
      height: appConfig.topBar.heightTextButton,
      child: OutlinedButton(
        onPressed: () {
          ref.read(topBarButtonSelectorProvider).selectProgramLogic();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: topBarButtonSelectorNotifier.programLogicSelected
              ? appConfig.topBar.backgroundSelected
              : appConfig.topBar.backgroundUnselected,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
        child: Text(
          'Logic',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: topBarButtonSelectorNotifier.programLogicSelected &&
                    appConfig.topBar.boldFont
                ? FontWeight.bold
                : FontWeight.normal,
            color: topBarButtonSelectorNotifier.programLogicSelected
                ? appConfig.topBar.selected
                : appConfig.topBar.unselected,
            fontSize: appConfig.topBar.fontSizeTextButton,
          ),
        ),
      ),
    );
  }
}

class AlarmsButton extends ConsumerWidget {
  const AlarmsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return SizedBox(
      width: appConfig.topBar.widthTextButton,
      height: appConfig.topBar.heightTextButton,
      child: OutlinedButton(
        onPressed: () {
          ref.read(topBarButtonSelectorProvider).selectAlarms();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: topBarButtonSelectorNotifier.alarmsSelected
              ? appConfig.topBar.backgroundSelected
              : appConfig.topBar.backgroundUnselected,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
        child: Text(
          'Alarms',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: topBarButtonSelectorNotifier.alarmsSelected &&
                    appConfig.topBar.boldFont
                ? FontWeight.bold
                : FontWeight.normal,
            color: topBarButtonSelectorNotifier.alarmsSelected
                ? appConfig.topBar.selected
                : appConfig.topBar.unselected,
            fontSize: appConfig.topBar.fontSizeTextButton,
          ),
        ),
      ),
    );
  }
}

class WindowControlButtons extends ConsumerWidget {
  const WindowControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: appConfig.topBar.widthIcon * 5,
      alignment: Alignment.centerRight,
      child: const Row(
        children: [
          Spacer(),
          MyMinimizeButton(),
          MyMaximizeUnmaximizeButton(),
          MyCloseButton(),
        ],
      ),
    );
  }
}

class MyMinimizeButton extends ConsumerWidget {
  const MyMinimizeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Minimize',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: SizedBox(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        child: TextButton(
          onPressed: () {
            ref
                .read(windowStatusProvider)
                .minimize(windowManager: windowManager);
          },
          child: Icon(
            Icons.minimize,
            semanticLabel: 'Minimize',
            color: appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class MyMaximizeUnmaximizeButton extends ConsumerWidget {
  const MyMaximizeUnmaximizeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Maximize/Unmaximize',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: SizedBox(
        // padding: const EdgeInsets.all(10.0),
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        child: TextButton(
          onPressed: () {
            ref
                .read(windowStatusProvider)
                .maximizeUnmaximize(windowManager: windowManager);
          },
          child: Icon(
            Icons.square_outlined,
            semanticLabel: 'Maximize/Unmaximize',
            color: appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class MyCloseButton extends ConsumerWidget {
  const MyCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: 'Close this App',
      waitDuration: appConfig.topBar.toolTipWaitDuration,
      child: SizedBox(
        width: appConfig.topBar.widthIcon,
        height: appConfig.topBar.heightIcon,
        child: TextButton(
          onPressed: () {
            appData.closeSoftware = true;
            ref.read(windowStatusProvider).close(windowManager: windowManager);
          },
          child: Icon(
            Icons.close,
            semanticLabel: 'Close this App',
            color: appConfig.topBar.unselected,
          ),
        ),
      ),
    );
  }
}

class MainPagesStack extends ConsumerWidget {
  const MainPagesStack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBarButtonSelectorNotifier =
        ref.watch(topBarButtonSelectorProvider);
    return SizedBox(
      child: IndexedStack(
        index: topBarButtonSelectorNotifier.mainPageSelect,
        children: const [
          SettingsPage(),
          UserManualPage(),
          AboutPage(),
          ScreenPage(),
          LogicPage(),
          AlarmsPage(),
        ],
      ),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.blue,
      child: const Text('Settings Page'),
    );
  }
}

class UserManualPage extends ConsumerWidget {
  const UserManualPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.deepPurple,
      child: const Text('User Manual Page'),
    );
  }
}

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.amber,
      child: const Text('About Page'),
    );
  }
}
