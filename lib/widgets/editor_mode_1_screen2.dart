//------------------------------------import start------------------------------
//flutter packages

import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/classes/logic_part.dart';
import 'package:simple_hmi/methods/input_methods.dart';
import 'package:simple_hmi/methods/user_interface_methods.dart';

import '/main.dart';
import 'package:flutter/gestures.dart';
// import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen_canvas_methods.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:toggle_switch/toggle_switch.dart';
//project files
//  data
import '/data/app_data.dart';
import '/data/configuration.dart';
import '/data/logic_page_data.dart';
import '/data/modbus_data.dart';
import '/data/user_interface_data.dart';
import '/classes/enumerations.dart';
//  methods

//  providers
import '/providers/providers_1.dart';
//---------------------------------import end-----------------------------------

class Line extends ConsumerWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        ref.read(callbackProvider).screen.newElement.lineCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Line',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/line_3.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Rectangle extends ConsumerWidget {
  const Rectangle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        ref
            .read(callbackProvider)
            .screen
            .newElement
            .rectangleCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        //color: Colors.blue,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Rectangle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/rectangle2.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleCentrePoint extends ConsumerWidget {
  const CircleCentrePoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        // print('Circle selected');
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        ref
            .read(callbackProvider)
            .screen
            .newElement
            .circleCentrePointCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Circle: \nCentre, End Point',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                    // fontSize: 10,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/circle_centre_point_4.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePointPoint extends ConsumerWidget {
  const CirclePointPoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        ref
            .read(callbackProvider)
            .screen
            .newElement
            .circlePointPointCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Circle: \nEnd Point, End Point',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/circle_point_point.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextForMimic extends ConsumerWidget {
  const TextForMimic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        ref.read(callbackProvider).screen.newElement.textCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/text.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiTextForMimic extends ConsumerWidget {
  const MultiTextForMimic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        NewElementOnScreenCallback.multiTextCreateButtonPressed();
        // ref.read(callbackProvider).screen.newElement.textCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Multi Text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/multi_text.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextButtonIcon extends ConsumerWidget {
  const TextButtonIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        NewElementOnScreenCallback.multiTextButtonIconPressed();
        // ref.read(callbackProvider).screen.newElement.textCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Text Button',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(4.0),
                child: ImageIcon(
                  const AssetImage('assets/icons/text_button.png'),
                  color: appConfig.screen.dropDown.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleButtonIcon extends ConsumerWidget {
  const ToggleButtonIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(screenBarButtonSelectorProvider).selectContentScreen();
        NewElementOnScreenCallback.toggleButtonIconPressed();
        // ref.read(callbackProvider).screen.newElement.textCreateButtonPressed();
      },
      child: SizedBox(
        height: appConfig.screen.dropDown.height,
        width: appConfig.screen.dropDown.widthItem,
        child: Column(
          children: [
            SizedBox(
              height: appConfig.screen.dropDown.heightTextContainer,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Toggle Button',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appConfig.screen.dropDown.foreground,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: appConfig.screen.dropDown.heightIcon,
              width: appConfig.screen.dropDown.widthIcon,
              child: ImageIcon(
                const AssetImage('assets/icons/toggle_button.png'),
                color: appConfig.screen.dropDown.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Screen extends ConsumerWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenNotifier = ref.watch(screenProvider);
    buildContext = context;
    return Container(
      // width: 500,
      // color: Colors.purpleAccent.shade700,
      width: appData.gridScreen.currentScreenSize.xMaximum -
          appData.gridScreen.currentScreenSize.xMinimum, //width in LPI
      // height: 500,
      height: appData.gridScreen.currentScreenSize.yMaximum -
          appData.gridScreen.currentScreenSize.yMinimum, //height in LPI
      color: appConfig.screen.content.background,
      child: GestureDetector(
        onTap: () {
          // CLICK ON CANVAS
          ref
              .read(callbackProvider)
              .screen
              .mouseOperations
              .mouseClickedOnScreen();
        },
        onPanStart: (_) {
          // SELECT BOX DRAG START
          ref
              .read(callbackProvider)
              .screen
              .mouseOperations
              .mouseDragStartOnScreen();
        },
        onPanEnd: (_) {
          // SELECT BOX DRAG END
          ref
              .read(callbackProvider)
              .screen
              .mouseOperations
              .mouseDragStopOnScreen();
        },
        onPanUpdate: (details) {
          // SELECT BOX DRAG CONTINUE
          ref
              .read(callbackProvider)
              .screen
              .mouseOperations
              .mouseDragContinueOnScreen(PointBoolean(
                details.localPosition.dx,
                details.localPosition.dy,
              ));
        },
        child: MouseRegion(
          onHover: (event) {
            ref
                .read(callbackProvider)
                .screen
                .mouseOperations
                .mouseMovedOnScreen(
                  currentLocalMousePosition: PointBoolean(
                    event.localPosition.dx,
                    event.localPosition.dy,
                  ),
                );
          },
          onEnter: (event) {
            ref
                .read(callbackProvider)
                .screen
                .mouseOperations
                .mouseEnteredScreen();
          },
          onExit: (event) {
            ref
                .read(callbackProvider)
                .screen
                .mouseOperations
                .mouseExitedScreen();
          },
          child: ClipRect(
            child: CustomPaint(
              foregroundPainter: ScreenPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenPainter extends CustomPainter {
  ScreenPainter();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    PaintElements.paintGrid(canvas: canvas, snapPoints: appData.snapPoints);

    PaintElements.paintExistingElements(
      allElementsMap: appData.allScreenElements,
      canvas: canvas,
      moveScreen: appData.moveScreen,
      selectParameters: appData.selectParameters,
      itemsBeingMoved: appData.itemsBeingMoved,
      itemsBeingRotated: appData.itemsBeingRotated,
      itemsBeingCopied: appData.itemBeingCopied,
      appConfiguration: appConfig,
    );

    PaintElements.paintItemBeingCreated(
      itemBeingCreated: appData.itemBeingCreated,
      createParameters: appData.createParameters,
      canvas: canvas,
      moveScreen: appData.moveScreen,
    );

    PaintElements.paintItemBeingSelected(
      selectParameters: appData.selectParameters,
      canvas: canvas,
      moveScreen: appData.moveScreen,
      appConfiguration: appConfig,
      itemsBeingMoved: appData.itemsBeingMoved,
      itemsBeingRotated: appData.itemsBeingRotated,
      itemsBeingCopied: appData.itemBeingCopied,
      itemBeingEdited: appData.itemsBeingEdited,
    );

    PaintElements.paintItemBeingMoved(
      itemsBeingMoved: appData.itemsBeingMoved,
      canvas: canvas,
      moveScreen: appData.moveScreen,
    );

    PaintElements.paintItemBeingCopied(
      itemsBeingCopied: appData.itemBeingCopied,
      canvas: canvas,
      moveScreen: appData.moveScreen,
    );

    PaintElements.paintItemBeingRotated(
      itemsBeingRotated: appData.itemsBeingRotated,
      canvas: canvas,
      moveScreen: appData.moveScreen,
    );

    PaintElements.paintItemBeingEdited(
      itemBeingEdited: appData.itemsBeingEdited,
      canvas: canvas,
      moveScreen: appData.moveScreen,
    );

    PaintElements.selectRectangle(canvas: canvas);

    PaintElements.paintSnapPoint(canvas: canvas);
  }
}

class WidgetTypeBoolean extends ConsumerWidget {
  final String PROPERTY_STRING;
  final dynamic itemModified;
  // final String property;
  final DialogBoxConfiguration CONFIG;

  const WidgetTypeBoolean({
    super.key,
    required this.PROPERTY_STRING,
    required this.itemModified,
    // required this.property,
    required this.CONFIG,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetTypeBooleanNotifier = ref.read(widgetTypeBooleanProvider);
    // final config = appConfig.propertiesUpdate;
    // final elementBeingEdited = appData.itemsBeingEdited.elementBeingEdited;

    return Row(
      children: [
        SizedBox(
          width: CONFIG.textLabelWidth,
          child: Text(
            PROPERTY_STRING,
            textDirection: TextDirection.rtl,
            style: TextStyle(color: CONFIG.fontColorContent),
          ),
        ),
        SizedBox(
          width: CONFIG.textLabelWidth,
          child: Center(
            child: ToggleSwitch(
              labels: const ['False', 'True'],
              // initialLabelIndex: elementBeingEdited.val == false ? 0 : 1,
              initialLabelIndex: itemModified.property[PROPERTY_STRING]
                          [Property.value] ==
                      false
                  ? 0
                  : 1,

              inactiveBgColor: CONFIG.toggleInactiveBackground,
              inactiveFgColor: CONFIG.toggleInactiveForeground,
              activeBgColor: [
                CONFIG.toggleActiveBackground,
                CONFIG.toggleActiveBackground
              ],
              activeFgColor: CONFIG.toggleActiveForeground,
              onToggle: (index) {
                // elementBeingEdited.val = index == 1;
                Map<String, Map<Property, dynamic>> NEW_PROPERTY = {
                  PROPERTY_STRING: {
                    Property.value: index == 1,
                  }
                };
                // newPropertyEntry[Property.value] = index == 1;
                //   propertyString: {
                //     Property.propertyType: PropertyTypeOfElement.boolean,
                //     Property.value: index == 1,
                //   },
                // };
                itemModified.updateProperty(NEW_PROPERTY);

                StateCallback.rebuildCanvas();
                // print('VAL IS ${elementBeingEdited.val}');
                // CanvasMovementCallback
                //     .update_after_each_canvas_movement_click();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class WidgetTypeWidth extends ConsumerWidget {
  final String PROPERTY_STRING;
  final dynamic itemModified;
  final DialogBoxConfiguration CONFIG;

  const WidgetTypeWidth({
    super.key,
    required this.PROPERTY_STRING,
    required this.itemModified,
    required this.CONFIG,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetTypeWidthNotifier = ref.watch(widgetTypeWidthProvider);
    // final config = appConfig.propertiesUpdate;
    // final elementBeingEdited = appData.itemsBeingEdited.elementBeingEdited;
    final PROPERTY_ENTRY = itemModified.property[PROPERTY_STRING];
    return Row(
      children: [
        SizedBox(
          width: CONFIG.textLabelWidth,
          child: Text(
            PROPERTY_STRING,
            textDirection: TextDirection.rtl,
            style: TextStyle(color: CONFIG.fontColorContent),
          ),
        ),
        SizedBox(
          width: CONFIG.textLabelWidth,
          child: Row(
            children: [
              const Spacer(),
              SizedBox(
                width: CONFIG.minusButtonWidth,
                height: CONFIG.minuxButtonHeight,
                child: TextButton(
                  onPressed: () {
                    EditOperationMethods.minusPressedInWidgetTypeWidth(
                      itemModified: itemModified,
                      STEP_SIZE: 0.5,
                      PROPERTY_STRING: PROPERTY_STRING,
                      LOWER_CONSTRAINT:
                          PROPERTY_ENTRY[Property.lowerConstraint],
                      CURRENT_VALUE: PROPERTY_ENTRY[Property.value],
                    );
                    StateCallback.rebuildWidgetTypeWidth();
                    StateCallback.rebuildCanvas();
                  },
                  child: Image.asset(
                    'assets/icons/minus.png',
                    color: CONFIG.fontColorContent,
                  ),
                ),
              ),
              SizedBox(
                width: CONFIG.numberWidth,
                height: CONFIG.numberHeight,
                child: Center(
                  child: Text(
                    PROPERTY_STRING,
                    style: TextStyle(
                      color: CONFIG.fontColorContent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: CONFIG.minusButtonWidth,
                height: CONFIG.minuxButtonHeight,
                child: TextButton(
                  onPressed: () {
                    EditOperationMethods.plusPressedInWidgetTypeWidth(
                      itemModified: itemModified,
                      STEP_SIZE: 0.5,
                      PROPERTY_STRING: PROPERTY_STRING,
                      UPPER_CONSTRAINT:
                          PROPERTY_ENTRY[Property.upperConstraint],
                      CURRENT_VALUE: PROPERTY_ENTRY[Property.value],
                    );
                    StateCallback.rebuildWidgetTypeWidth();
                    StateCallback.rebuildCanvas();
                  },
                  child: Image.asset(
                    'assets/icons/plus.png',
                    color: CONFIG.fontColorContent,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class WidgetTypeColor extends ConsumerWidget {
  final String PROPERTY_STRING;
  final DialogBoxConfiguration CONFIG;
  final dynamic itemModified;

  const WidgetTypeColor({
    super.key,
    required this.PROPERTY_STRING,
    required this.CONFIG,
    required this.itemModified,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetTypeColorNotifier = ref.watch(widgetTypeColorProvider);
    // final config = appConfig.propertiesUpdate;
    // final itemBeingEdited = appData.itemsBeingEdited;
    final PROPERTY_ENTRY = itemModified.property[PROPERTY_STRING];
    print('rebuilding Widget type color');
    return Row(
      children: [
        SizedBox(
          width: CONFIG.textLabelWidth,
          child: Text(
            PROPERTY_STRING,
            textDirection: TextDirection.rtl,
            style: TextStyle(color: CONFIG.fontColorContent),
          ),
        ),
        SizedBox(
          width: CONFIG.textLabelWidth,
          child: Row(
            children: [
              const Spacer(),
              SizedBox(
                width: CONFIG.numberWidth / 4,
              ),
              Container(
                width: CONFIG.colorSquareWidth / 2,
                height: CONFIG.colorSquareWidth / 2,
                decoration: BoxDecoration(
                  color: PROPERTY_ENTRY[Property.value],
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      CONFIG.colorSquareWidth / 4,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: CONFIG.numberWidth / 4,
              ),
              SizedBox(
                width: CONFIG.minusButtonWidth,
                height: CONFIG.minuxButtonHeight,
                child: TextButton(
                  onPressed: () {
                    EditOperationMethods.colorPickerDialog(
                      itemModified: itemModified,
                      PROPERTY_STRING: PROPERTY_STRING,
                      CONFIG: CONFIG,
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    semanticLabel: 'Edit Color',
                    color: CONFIG.fontColorContent,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class TextSize extends ConsumerWidget {
  // final dynamic propertyKey;

  const TextSize({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSizeNotifier = ref.watch(textSizeProvider);
    final itemBeingCreated = appData.itemBeingCreated;
    return Row(
      children: [
        SizedBox(
          width: appConfig.propertiesUpdate.textLabelWidth,
          child: Text(
            'Increase / Decrease font size',
            textDirection: TextDirection.rtl,
            style:
                TextStyle(color: appConfig.propertiesUpdate.fontColorContent),
          ),
        ),
        SizedBox(
          width: appConfig.propertiesUpdate.textLabelWidth,
          child: Row(
            children: [
              const Spacer(),
              SizedBox(
                width: appConfig.propertiesUpdate.minusButtonWidth,
                height: appConfig.propertiesUpdate.minuxButtonHeight,
                child: TextButton(
                  onPressed: () {
                    NewElementOnScreenCallback.textSizeDecreaseButtonPressed();
                  },
                  child: Image.asset(
                    'assets/icons/minus.png',
                    color: appConfig.propertiesUpdate.fontColorContent,
                  ),
                ),
              ),
              SizedBox(
                width: appConfig.propertiesUpdate.numberWidth,
                height: appConfig.propertiesUpdate.numberHeight,
                child: Center(
                  child: Text(
                    itemBeingCreated.item.fontSize.toString(),
                    style: TextStyle(
                      color: appConfig.propertiesUpdate.fontColorContent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: appConfig.propertiesUpdate.minusButtonWidth,
                height: appConfig.propertiesUpdate.minuxButtonHeight,
                child: TextButton(
                  onPressed: () {
                    NewElementOnScreenCallback.textSizeIncreaseButtonPressed();
                  },
                  child: Image.asset(
                    'assets/icons/plus.png',
                    color: appConfig.propertiesUpdate.fontColorContent,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class MultitextWidgetDelete extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;
  final bool THIS_IS_CREATE_DIALOG;
  const MultitextWidgetDelete({
    required this.multiTextBoolean,
    required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    required this.THIS_IS_CREATE_DIALOG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: TextButton(
        onPressed: () {
          multiTextBoolean.deleteRecordEntry(KEY_OF_RECORD);
          CallbackScreenEditing.multiTextEntryAddedOrDeleted(
              THIS_IS_CREATE_DIALOG);
        },
        child: const Icon(
          Icons.delete,
        ),
      ),
    );
  }
}

class MultitextWidgetText extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;
  const MultitextWidgetText({
    required this.multiTextBoolean,
    required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController _controller = TextEditingController(
    //     text: multiTextBoolean.records[KEY_OF_RECORD]!.text);
    // _controller.addListener(() {
    //   MultiTextMethods.updateText_(
    //     multiTextItem: multiTextBoolean,
    //     NEW_TEXT: typedText,
    //     RECORD_KEY: KEY_OF_RECORD,
    //   );
    //   CallbackScreenEditing.multiTextTextFieldRebuild();
    //   StateCallback.rebuildCanvas();
    // });

    final multitextWidgetTextNotifier = ref.watch(multitextWidgetTextProvider);

    String initialValue = multiTextBoolean.records[KEY_OF_RECORD]!.text == ' '
        ? ''
        : multiTextBoolean.records[KEY_OF_RECORD]!.text;

    print('Multi text dialog: Text: record key $KEY_OF_RECORD');
    print('default text:  $initialValue');

    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Row(
        children: [
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Text(
              'Enter text when value is true',
              style: TextStyle(color: CONFIG.fontColorContent),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: CONFIG.textFieldWidth,
            child: TextFormField(
              // controller: _controller,
              initialValue: initialValue,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'RobotoMono',
                fontSize: 15,
              ),
              onChanged: (typedText) {
                // if (typedText == '') {
                //   NewElementOnScreenCallback.textUpdated(' ', isTrueText: true);
                // } else {
                //   NewElementOnScreenCallback.textUpdated(typedText,
                //       isTrueText: true);
                // }
                // _controller.value = TextEditingValue(text: typedText);

                MultiTextMethods.updateText_(
                  multiTextItem: multiTextBoolean,
                  NEW_TEXT: typedText,
                  RECORD_KEY: KEY_OF_RECORD,
                );
                CallbackScreenEditing.multiTextTextFieldRebuild();
                StateCallback.rebuildCanvas();
              },
              decoration: InputDecoration(
                hintText: 'enter text here',
                hintStyle: TextStyle(color: Colors.white54),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.white60,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.white60,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.white60,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultitextWidgetBoolean extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  const MultitextWidgetBoolean({
    required this.multiTextBoolean,
    required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multitextWidgetBooleanNotifier =
        ref.watch(multitextWidgetBooleanProvider);

    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Row(
        children: [
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Text(
              'true or false',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: CONFIG.fontColorContent),
            ),
          ),
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Center(
              child: ToggleSwitch(
                labels: const ['False', 'True'],
                // initialLabelIndex: elementBeingEdited.val == false ? 0 : 1,
                initialLabelIndex:
                    multiTextBoolean.records[KEY_OF_RECORD]!.booleanValue ==
                            false
                        ? 0
                        : 1,

                inactiveBgColor: CONFIG.toggleInactiveBackground,
                inactiveFgColor: CONFIG.toggleInactiveForeground,
                activeBgColor: [
                  CONFIG.toggleActiveBackground,
                  CONFIG.toggleActiveBackground
                ],
                activeFgColor: CONFIG.toggleActiveForeground,
                onToggle: (index) {
                  MultiTextMethods.updateBooleanValue_(
                    multiTextBoolean: multiTextBoolean,
                    BOOLEAN_VALUE: index == 1,
                    RECORD_KEY: KEY_OF_RECORD,
                  );
                  CallbackScreenEditing.multiTextBooleanRebuild();
                  StateCallback.rebuildCanvas();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultitextWidgetFontSize extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  const MultitextWidgetFontSize({
    required this.multiTextBoolean,
    required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multitextWidgetFontSizeNotifier =
        ref.watch(multitextWidgetFontSizeProvider);
    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Row(
        children: [
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Text(
              'font size',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: CONFIG.fontColorContent),
            ),
          ),
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: CONFIG.minusButtonWidth,
                  height: CONFIG.minuxButtonHeight,
                  child: TextButton(
                    onPressed: () {
                      MultiTextMethods.decrease_font_size_(
                        multiTextItem: multiTextBoolean,
                        RECORD_KEY: KEY_OF_RECORD,
                      );
                      CallbackScreenEditing.multiTextFontSizeRebuild();
                      StateCallback.rebuildCanvas();
                    },
                    child: Image.asset(
                      'assets/icons/minus.png',
                      color: CONFIG.fontColorContent,
                    ),
                  ),
                ),
                SizedBox(
                  width: CONFIG.numberWidth,
                  height: CONFIG.numberHeight,
                  child: Center(
                    child: Text(
                      multiTextBoolean.records[KEY_OF_RECORD]!.fontSize
                          .toString(),
                      style: TextStyle(
                        color: CONFIG.fontColorContent,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: CONFIG.minusButtonWidth,
                  height: CONFIG.minuxButtonHeight,
                  child: TextButton(
                    onPressed: () {
                      MultiTextMethods.increase_font_size_(
                        multiTextItem: multiTextBoolean,
                        RECORD_KEY: KEY_OF_RECORD,
                      );
                      CallbackScreenEditing.multiTextFontSizeRebuild();
                      StateCallback.rebuildCanvas();
                    },
                    child: Image.asset(
                      'assets/icons/plus.png',
                      color: CONFIG.fontColorContent,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MultitextWidgetColorBackground extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  final ColorPickerData colorPickerData;
  final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  const MultitextWidgetColorBackground({
    required this.multiTextBoolean,
    required this.colorPickerData,
    required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorPickerNotifier = ref.watch(colorPickerProvider);
    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Row(
        children: [
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Text(
              'background color',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: CONFIG.fontColorContent),
            ),
          ),
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: CONFIG.numberWidth / 4,
                ),
                Container(
                  width: CONFIG.colorSquareWidth / 2,
                  height: CONFIG.colorSquareWidth / 2,
                  decoration: BoxDecoration(
                    color: multiTextBoolean
                        .records[KEY_OF_RECORD]!.colorBackGround,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        CONFIG.colorSquareWidth / 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: CONFIG.numberWidth / 4,
                ),
                SizedBox(
                  width: CONFIG.minusButtonWidth,
                  height: CONFIG.minuxButtonHeight,
                  child: TextButton(
                    onPressed: () {
                      ColorPickerData.genericColorPickerDialog_(
                        element: multiTextBoolean,
                        ELEMENT_TYPE: ElementType.multiText,
                        PROPERTY_STRING: 'background color',
                        RECORD_KEY: KEY_OF_RECORD,
                        CONFIG: CONFIG,
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      semanticLabel: 'Edit Color',
                      color: CONFIG.fontColorContent,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MultitextWidgetColorForeground extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  final ColorPickerData colorPickerData;
  final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;

  const MultitextWidgetColorForeground({
    required this.multiTextBoolean,
    required this.colorPickerData,
    required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorPickerNotifier = ref.watch(colorPickerProvider);
    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: Row(
        children: [
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Text(
              'text color',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: CONFIG.fontColorContent),
            ),
          ),
          SizedBox(
            width: CONFIG.textLabelWidth,
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: CONFIG.numberWidth / 4,
                ),
                Container(
                  width: CONFIG.colorSquareWidth / 2,
                  height: CONFIG.colorSquareWidth / 2,
                  decoration: BoxDecoration(
                    color: multiTextBoolean
                        .records[KEY_OF_RECORD]!.colorForeGround,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        CONFIG.colorSquareWidth / 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: CONFIG.numberWidth / 4,
                ),
                SizedBox(
                  width: CONFIG.minusButtonWidth,
                  height: CONFIG.minuxButtonHeight,
                  child: TextButton(
                    onPressed: () {
                      ColorPickerData.genericColorPickerDialog_(
                        element: multiTextBoolean,
                        ELEMENT_TYPE: ElementType.multiText,
                        PROPERTY_STRING: 'text color',
                        RECORD_KEY: KEY_OF_RECORD,
                        CONFIG: CONFIG,
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      semanticLabel: 'Edit Color',
                      color: CONFIG.fontColorContent,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MultitextWidgetAdd extends ConsumerWidget {
  final MultiTextBoolean multiTextBoolean;
  // final ColorPickerData colorPickerData;
  // final int KEY_OF_RECORD;
  final bool SELECT_ALTERNATING_COLOR_ONE;
  final DialogBoxConfiguration CONFIG;
  final bool THIS_IS_CREATE_DIALOG;

  const MultitextWidgetAdd({
    required this.multiTextBoolean,
    // required this.colorPickerData,
    // required this.KEY_OF_RECORD,
    required this.SELECT_ALTERNATING_COLOR_ONE,
    required this.CONFIG,
    required this.THIS_IS_CREATE_DIALOG,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: SELECT_ALTERNATING_COLOR_ONE
          ? CONFIG.alternatingColorBackground1
          : CONFIG.alternatingColorBackground2,
      child: TextButton(
        onPressed: () {
          multiTextBoolean.addRecordEntry();
          CallbackScreenEditing.multiTextEntryAddedOrDeleted(
              THIS_IS_CREATE_DIALOG);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class MultiTextCreateDialogWidget extends ConsumerWidget {
  // final ItemBeingCreated itemBeingCreated;
  final MultiTextBoolean multiTextBoolean;
  final ColorPickerData colorPickerData;
  final DialogBoxConfiguration CONFIG;

  const MultiTextCreateDialogWidget({
    super.key,
    // required this.itemBeingCreated,
    required this.multiTextBoolean,
    required this.colorPickerData,
    required this.CONFIG,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multitextDialogWidgetNotifier =
        ref.watch(multitextDialogWidgetProvider);

    // MultiTextBoolean multiTextBoolean = itemBeingCreated.item;

    return SizedBox(
      width: CONFIG.width,
      child: ListView(
          // scrollDirection: Axis.vertical,
          children: [
            ...MultiTextMethods.widgetForEachColumn_(
              // itemBeingCreated: itemBeingCreated,
              multiTextBoolean: multiTextBoolean,
              colorPickerData: colorPickerData,
              CONFIG: CONFIG,
              THIS_IS_CREATE_DIALOG: true,
            ),
            ...[
              MultiTextMethods.updateCancelDialogForCreate_(
                DIALOG_BOX_CONFIG: CONFIG,
                // itemBeingCreated: itemBeingCreated,
                multiTextBoolean: multiTextBoolean,
              ),
            ]
          ]),
    );
  }
}

class MultiTextEditDialogWidget extends ConsumerWidget {
  // final ItemBeingCreated itemBeingCreated;
  final MultiTextBoolean modifiedElement;
  final ColorPickerData colorPickerData;
  final DialogBoxConfiguration CONFIG;
  final ItemBeingEdited itemBeingEdited;
  final MultiTextBoolean originalElement;
  final Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates;

  const MultiTextEditDialogWidget({
    super.key,
    required this.colorPickerData,
    required this.CONFIG,
    required this.itemBeingEdited,
    required this.originalElement,
    required this.modifiedElement,
    required this.kwargs_recalculate_clickable_coordinates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multitextDialogWidgetNotifier =
        ref.watch(multitextDialogWidgetProvider);

    // MultiTextBoolean multiTextBoolean = itemBeingCreated.item;
    return SizedBox(
      width: CONFIG.width,
      child: ListView(children: [
        ...MultiTextMethods.widgetForEachColumn_(
          multiTextBoolean: modifiedElement,
          colorPickerData: colorPickerData,
          CONFIG: CONFIG,
          THIS_IS_CREATE_DIALOG: false,
        ),
        ...[
          MultiTextMethods.updateCancelDialogForEdit_(
            DIALOG_BOX_CONFIG: CONFIG,
            multiTextBoolean: modifiedElement,
            itemBeingEdited: itemBeingEdited,
            originalElement: originalElement,
            RECALCULATE_CLICKABLE_COORDINATES:
                ClickableCoordinatesOperations.recalculateCoordinates,
            kwargs_recalculate_clickable_coordinates:
                kwargs_recalculate_clickable_coordinates,
          ),
        ]
      ]),
    );
  }
}
