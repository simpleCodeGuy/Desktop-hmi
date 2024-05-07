import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/classes/input_elements.dart';
import 'package:simple_hmi/data/dialog_box_classes.dart';

import '/data/user_interface_data.dart';
import '/classes/logic_part.dart';
import '/data/configuration.dart';
import 'package:logging/logging.dart';
import '/classes/class_extensions.dart';
import '/classes/enumerations.dart';
import '/classes/logic_blocks.dart';
import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

final log = Logger('default print');

double gapBetweenBoundaryPointsDuringSnapping = 20;
double snapPrecision = 10;
BuildContext buildContext = buildContext;

const double windowSizeHeightMinimum = 2.62 * 160;
const double windowSizeWidthMinimum = 5.83 * 160;

var appData = AppData();
var appConfig = AppConfiguration();

class AppData {
  double previousWindowWidth = windowSizeWidthMinimum;
  double previousWindowHeight = windowSizeHeightMinimum;
  Timer? windowSizeCheckTimer;
  bool closeSoftware = false;

  Map<dynamic, dynamic> allScreenElements = {
    ElementType.lineBoolean: {},
    ElementType.rectangleBoolean: {},
    ElementType.circleBoolean: {},
    ElementType.circleBooleanPointPoint: {},
    ElementType.text: {},
    ElementType.multiText: {},
    ElementType.multiTextButton: {},
  };
  var gridScreen = GridScreen();
  var clickableCoordinates = ClickableCoordinates();
  var propertiesSettings = PropertiesSettings();
  var selectParameters = SelectParameters();
  var createParameters = CreateParameters();
  var moveScreen = MoveScreen();
  var snapPoints = SnapPoints();
  var statusBarMessage = StatusBarMessage();

  var itemsBeingMoved = ItemsBeingMoved();
  var itemsBeingRotated = ItemsBeingRotated();
  var itemBeingCreated = ItemBeingCreated();
  var itemsBeingEdited = ItemBeingEdited();
  var itemBeingCopied = ItemsBeingCopied();

  var screenSize = ScreenSize();
  var buttonConstantPress = ButtonConstantPress();

  double spaceBetweenPoints = 10;

  var dialogBoxForScreen = DialogBoxForScreen();
  var colorPickerData = ColorPickerData();

  void updateSingleUiElementByResponse(
    ResponseToUi RESPONSE_TO_UI,
    Type SCREEN_ELEMENT_TYPE,
    int SCREEN_ELEMENT_KEY,
  ) {
    switch (SCREEN_ELEMENT_TYPE) {
      case LineBoolean:
        LineBoolean lineBoolean =
            allScreenElements[SCREEN_ELEMENT_TYPE][SCREEN_ELEMENT_KEY];
        bool VAL = RESPONSE_TO_UI.VALUE;
        lineBoolean.updateProperties(val: VAL);
        break;
      case RectangleBoolean:
        RectangleBoolean element =
            allScreenElements[SCREEN_ELEMENT_TYPE][SCREEN_ELEMENT_KEY];
        bool VAL = RESPONSE_TO_UI.VALUE;
        element.updateProperties(val: VAL);
        break;
      case CircleBoolean:
        CircleBoolean element =
            allScreenElements[SCREEN_ELEMENT_TYPE][SCREEN_ELEMENT_KEY];
        bool VAL = RESPONSE_TO_UI.VALUE;
        element.updateProperties(val: VAL);
        break;
      case TextBoolean:
        TextBoolean element =
            allScreenElements[SCREEN_ELEMENT_TYPE][SCREEN_ELEMENT_KEY];
        bool VAL = RESPONSE_TO_UI.VALUE;
        element.updateProperties(val: VAL);
        break;
      case MultiTextBoolean:
        MultiTextBoolean element =
            allScreenElements[SCREEN_ELEMENT_TYPE][SCREEN_ELEMENT_KEY];
        bool VAL = RESPONSE_TO_UI.VALUE;
        int INPUT_PORT_INDEX = RESPONSE_TO_UI.INPUT_PORT_INDEX;
        element.updateByIndex(INPUT_PORT_INDEX, VAL);
        break;
      case MultiTextButton:
        MultiTextButton element =
            allScreenElements[SCREEN_ELEMENT_TYPE][SCREEN_ELEMENT_KEY];
        bool VAL = RESPONSE_TO_UI.VALUE;
        int INPUT_PORT_INDEX = RESPONSE_TO_UI.INPUT_PORT_INDEX;
        element.updateByIndex(INPUT_PORT_INDEX, VAL);
        break;
      default:
        throw Exception('$SCREEN_ELEMENT_TYPE does not have code'
            'to get updated from response');
    }
  }

  (double, double) SCREEN_SIZE_IN_LPI() {
    return (
      screenSize.canvasPresentSize.corner3.x,
      screenSize.canvasPresentSize.corner3.y
    );
  }
}

ShortcutActivator activatorForDialogLevel2Escape =
    // const SingleActivator(LogicalKeyboardKey.escape, control: true);
    const SingleActivator(LogicalKeyboardKey.arrowUp, control: true);

class RecordMultiText {
  late bool booleanValue;
  late String text;
  late double fontSize;
  late Color colorForeGround;
  late Color colorBackGround;

  RecordMultiText({
    required this.booleanValue,
    required this.text,
    required this.fontSize,
    required this.colorForeGround,
    required this.colorBackGround,
  });

  RecordMultiText.withDefaultValues() {
    booleanValue = false;
    text = ' ';
    fontSize = 20;
    colorForeGround = Colors.yellowAccent;
    colorBackGround = const Color.fromARGB(50, 255, 255, 255);
  }

  RecordMultiText get copy => RecordMultiText(
        booleanValue: booleanValue,
        text: text,
        fontSize: fontSize,
        colorForeGround: colorForeGround,
        colorBackGround: colorBackGround,
      );

  @override
  String toString() {
    return '''RecordMultiText {
  booleanValue : $booleanValue,
  text : $text,
  fontSize : $fontSize,
  colorForeGround : $colorForeGround,
  colorBackGround : $colorBackGround,
}''';
  }
}
