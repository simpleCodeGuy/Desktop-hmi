import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_hmi/classes/logic_blocks.dart';
import 'package:simple_hmi/classes/logic_part.dart';
import 'package:simple_hmi/data/app_data.dart';
import 'package:simple_hmi/data/configuration.dart';
import 'dart:math';
import 'package:simple_hmi/data/user_interface_data.dart';
import 'package:simple_hmi/methods/input_methods.dart';
import 'package:simple_hmi/methods/user_interface_methods.dart';
import 'package:simple_hmi/providers/providers_1.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen2.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen_canvas_methods.dart';
import '/classes/elements.dart';
import '/widgets/dialog_boxes_screen.dart';
import '/classes/class_extensions.dart';
import '/classes/enumerations.dart';
import '/data/model_logic.dart';

// extension DoubleCopy on double {
//   double get copy => this;
// }

class MultiTextButton {
  static double MINIMUM_FONT_SIZE = 6;

  late PointBoolean pivotPoint;
  double angleRadians = 0;

  Map<dynamic, RecordMultiText> inputRecords = {
    'default text': RecordMultiText(
      booleanValue: false,
      text: '',
      fontSize: 20,
      colorBackGround: const Color.fromARGB(255, 150, 150, 150),
      colorForeGround: const Color.fromARGB(255, 255, 255, 0),
    ),
    'text when more than one is true': RecordMultiText(
      booleanValue: false,
      text: 'Transition text',
      fontSize: 20,
      colorBackGround: const Color.fromARGB(0, 150, 150, 150),
      colorForeGround: const Color.fromARGB(255, 255, 255, 0),
    ),
    'text when all are true': RecordMultiText(
      booleanValue: false,
      text: 'All high text',
      fontSize: 20,
      colorBackGround: const Color.fromARGB(0, 150, 150, 150),
      colorForeGround: const Color.fromARGB(255, 255, 255, 0),
    ),
    1: RecordMultiText(
      booleanValue: false,
      text: '',
      fontSize: 20,
      colorBackGround: const Color.fromARGB(255, 150, 150, 150),
      colorForeGround: const Color.fromARGB(255, 255, 255, 0),
    ),
  };

  //output is a map of {port number : Output Port}
  Map<int, Map<String, dynamic>> output = {
    1: {
      'label': 'button 1',
      'buttonText': 'button 1',
      'value': true,
    },
  };

  // Map<int, bool> previousStateOutput = {
  //   1: false,
  // };

  late String _KEY;
  void assignKey(String KEY) {
    _KEY = KEY;
  }

  MultiTextButton({required this.pivotPoint});

  void updateProperties({
    PointBoolean? pivotPoint,
    double? angleRadians,
    Map<dynamic, RecordMultiText>? singleRecord,
    Map<dynamic, RecordMultiText>? completeRecord,
    Map<int, Map<String, dynamic>>? output,
    Map<int, bool>? previousStateOutput,
  }) {
    this.pivotPoint = pivotPoint ?? this.pivotPoint;
    this.angleRadians = angleRadians ?? this.angleRadians;

    if (singleRecord != null) {
      if (singleRecord.isNotEmpty) {
        final KEY = singleRecord.keys.first;
        if (Set.from(inputRecords.keys).contains(KEY)) {
          inputRecords[KEY] = singleRecord[KEY]!.copy;
        }
      }
    }

    if (completeRecord != null) {
      inputRecords.clear();
      for (dynamic key in completeRecord.keys) {
        inputRecords[key] = completeRecord[key]!.copy;
      }
    }

    if (output != null) {
      for (var key in output.keys) {
        this.output[key] = {
          'label': output[key]!['label'],
          'buttonText': output[key]!['buttonText'],
          'value': output[key]!['value'],
        };
      }
    }

    // if (previousStateOutput != null) {
    //   for (var key in previousStateOutput.keys) {
    //     this.previousStateOutput[key] = previousStateOutput[key] ?? false;
    //   }
    // }
  }

  void updateByIndex(int INDEX, bool VALUE) {
    try {
      RecordMultiText recordMultiText =
          inputRecords.values.elementAt(INDEX + 3);
      recordMultiText.booleanValue = VALUE;
    } catch (e, f) {
      throw Exception('$e\n$f');
    }
  }

  void updateFrom(MultiTextButton other) {
    pivotPoint = other.pivotPoint.copy;
    angleRadians = other.angleRadians.copy;

    inputRecords.clear();
    output.clear();
    // previousStateOutput.clear();

    for (dynamic key in other.inputRecords.keys) {
      inputRecords[key] = other.inputRecords[key]!.copy;
    }
    for (var key in other.output.keys) {
      output[key] = {
        'label': other.output[key]!['label'],
        'buttonText': other.output[key]!['buttonText'],
        'value': other.output[key]!['value'],
      };
      // previousStateOutput[key] = other.previousStateOutput[key] ?? false;
    }
  }

  MultiTextButton get copy {
    Map<dynamic, RecordMultiText> inputRecordsCopy = {};
    Map<int, Map<String, dynamic>> outputCopy = {};
    Map<int, bool> previousStateOutputCopy = {};

    for (dynamic key in inputRecords.keys) {
      inputRecordsCopy[key] = inputRecords[key]!.copy;
    }
    for (dynamic key in output.keys) {
      outputCopy[key] = {
        'label': output[key]!['label'],
        'buttonText': output[key]!['buttonText'],
        'value': output[key]!['value'],
      };
      // previousStateOutputCopy[key] = previousStateOutput[key] ?? false;
    }

    MultiTextButton n = MultiTextButton(pivotPoint: pivotPoint.copy);
    n.updateProperties(
      pivotPoint: pivotPoint.copy,
      angleRadians: angleRadians.copy,
      completeRecord: inputRecordsCopy,
      output: outputCopy,
      previousStateOutput: previousStateOutputCopy,
    );

    // return MultiTextButton(
    //   pivotPoint: pivotPoint.copy,
    //   angleRadians: angleRadians.copy,
    //   inputRecords: inputRecordsCopy,
    //   output: outputCopy,
    //   previousStateOutput: previousStateOutputCopy,
    // );
    return n;
  }

  // Color get showColor  is not defined.
  // Instead get paintData is defined, which includes showColor

  @override
  String toString() {
    return '''MultiTextButton {
  pivotPoint : $pivotPoint,
  angleRadian : $angleRadians,
  inputRecords : $inputRecords,
  output: $output,
}''';
  }

  void move(MoveParameters moveParameters) {
    updateProperties(
      pivotPoint: pivotPoint + moveParameters.offsetAsAPoint,
    );
  }

  void rotate(RotateParameters rotateParameters) {
    var ROTATION_DATA = Rotation.getRotated(
      PIVOT_POINT_EXISTING: pivotPoint,
      ANGLE_RADIAN_EXISTING: angleRadians,
      ROTATE_PARAMETERS: rotateParameters,
    );

    updateProperties(
      pivotPoint: ROTATION_DATA.pivotPoint,
      angleRadians: ROTATION_DATA.angleRadian,
    );
  }

  ///gets point which is extreme top left of this figure
  PointBoolean get topLeft {
    return PointBoolean.getMostTopLeft(corners) ?? const PointBoolean.zero();
  }

  bool isInsideSelectRectangle(
    RectangularBoundary SELECT_RECTANGLE,
    double SPACE_BETWEEN_POINTS,
  ) {
    final ANTICLOCKWISE_LOCUS = PointBoolean.locusFromCorners(
      ANTICLOCKWISE_CORNERS: corners,
      GAP: SPACE_BETWEEN_POINTS,
    );

    return Vector.doesAnticlockwiseLocusOverlapSelectRectangle(
      ANTICLOCKWISE_LOCUS: ANTICLOCKWISE_LOCUS,
      SELECT_RECTANGLE: SELECT_RECTANGLE,
    );
  }

  List<PointBoolean> get endPoints {
    return corners;
  }

  List<PointBoolean> boundaryPoints({required double gap}) {
    return PointBoolean.boundariesFromCorners(corners, gap);
  }

  List<PointBoolean> get centrePoint {
    return [corners[0].getCentreWith(corners[2])];
  }

  List<PointBoolean> getSnapPoints({
    required Map<SnapOn, bool> snapSelection,
    required double gap,
  }) {
    List<PointBoolean> pointsList = [];
    if (snapSelection[SnapOn.endPoint] ?? false) {
      pointsList.addAll(endPoints);
    }
    if (snapSelection[SnapOn.centre] ?? false) {
      pointsList.addAll(centrePoint);
    }
    if (snapSelection[SnapOn.boundary] ?? false) {
      pointsList.addAll(boundaryPoints(gap: gap));
    }

    // print('snap points of text: $pointsList');
    return pointsList;
  }

  RectangularBoundary get getBoundary {
    return RectangularBoundary.getBoundaryFromPoints(corners) ??
        const RectangularBoundary.allCornersZero();
  }

  Map<dynamic, Map<String, Map<Property, dynamic>>> get propertyMap {
    // Set INTEGER_KEYS = Set.from(
    //     inputRecords.keys.where((element) => element.runtimeType == int));

    Map<int, Map<String, Map<Property, dynamic>>> m = {};
    for (int i in inputRecords.keys) {
      m.addAll({
        i: {
          'text': {
            Property.propertyType: PropertyTypeOfElement.string,
            Property.value: inputRecords[i]!.text,
            Property.lowerConstraint: 0,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'boolean value': {
            Property.propertyType: PropertyTypeOfElement.boolean,
            Property.value: inputRecords[i]!.booleanValue,
            Property.lowerConstraint: null,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'text color': {
            Property.propertyType: PropertyTypeOfElement.color,
            Property.value: inputRecords[i]!.colorForeGround,
            Property.lowerConstraint: null,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'background color': {
            Property.propertyType: PropertyTypeOfElement.color,
            Property.value: inputRecords[i]!.colorBackGround,
            Property.lowerConstraint: null,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'font size': {
            Property.propertyType: PropertyTypeOfElement.fontSize,
            Property.value: inputRecords[i]!.fontSize,
            Property.lowerConstraint: 6,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          }
        },
      });
    }
    return m;
  }

  void updateProperty(
      Map<dynamic, Map<String, Map<Property, dynamic>>> propertyMap) {
    Set<int> EXISITING_KEYS = Set.from(inputRecords.keys);

    for (final keyFound in propertyMap.keys) {
      if (EXISITING_KEYS.contains(keyFound)) {
        var propertyInput = propertyMap[keyFound];
        for (final propertyString in propertyInput!.keys) {
          switch (propertyString) {
            case 'text':
              inputRecords[keyFound]!.text =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'boolean value':
              inputRecords[keyFound]!.booleanValue =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'text color':
              inputRecords[keyFound]!.colorForeGround =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'background color':
              inputRecords[keyFound]!.colorBackGround =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'font size':
              inputRecords[keyFound]!.fontSize =
                  propertyInput[propertyString]![Property.value];
              break;
          }
        }
      }
    }
  }

  MultiTextButton getCopyDueToScreenMoved(MoveScreen moveScreen) {
    MultiTextButton temp = copy;

    //translation
    final NEW_PIVOT_POINT = MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: temp.pivotPoint,
    );

    // final PAINT_DATA = paintData;

    temp.updateProperties(pivotPoint: NEW_PIVOT_POINT);

    for (final integerKey in temp.inputRecords.keys) {
      temp.inputRecords[integerKey]!.fontSize *= moveScreen.scale;
    }

    return temp;
  }

  PointBoolean pivot_after_screen_move(MoveScreen moveScreen) {
    return MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: pivotPoint,
    );
  }

  void paint({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {
    if (angleRadians == 0) {
      PaintElements.nonRotationPreOperations(
        canvas: canvas,
        PIVOT: pivot_after_screen_move(moveScreen),
      );

      paintNonRotated(
        canvas: canvas,
        moveScreen: moveScreen,
        overrideColor: overrideColor,
        percentageOpacity: percentageOpacity,
      );

      PaintElements.nonRotationPostOperations(canvas: canvas);
    } else {
      PaintElements.rotationPreOperations(
        canvas: canvas,
        PIVOT: pivot_after_screen_move(moveScreen),
        ANGLE_RADIANS: angleRadians,
      );

      paintNonRotated(
        canvas: canvas,
        moveScreen: moveScreen,
        overrideColor: overrideColor,
        percentageOpacity: percentageOpacity,
      );

      PaintElements.rotationPostOperations(canvas: canvas);
    }
  }

  void paintNonRotated({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {
    final TEXT_WHEN_SCREEN_MOVED = getCopyDueToScreenMoved(moveScreen);
    final PAINT_DATA = TEXT_WHEN_SCREEN_MOVED.paintData;

    if (PAINT_DATA.showText == ' ') {
      final textSpan = TextSpan(
        text: PAINT_DATA.showText,
        style: TextStyle(
          fontSize: PAINT_DATA.showFontSize,
          fontFamily: 'RobotoMono',
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      //layout must be called first, only after that any size related property of
      //textPaint can be accessed
      textPainter.layout();

      final WIDTH = textPainter.width;
      final HEIGHT = textPainter.height;

      final paint = Paint();
      if (overrideColor == null) {
        paint.color = const Color.fromARGB(50, 255, 255, 255);
      } else {
        paint.color = overrideColor.withAlpha(50);
      }
      canvas.drawRect(
        Rect.fromPoints(
          const Offset(0, 0),
          Offset(WIDTH, HEIGHT),
        ),
        paint,
      );
    } else {
      var ORIGINAL_COLOR = overrideColor ?? PAINT_DATA.showColor;

      var color = Color.fromARGB(
        ORIGINAL_COLOR.alpha,
        ORIGINAL_COLOR.red,
        ORIGINAL_COLOR.green,
        ORIGINAL_COLOR.blue,
      );
      color = color.withAlpha(color.alpha * (percentageOpacity ?? 100) ~/ 100);

      final textSpan = TextSpan(
        text: PAINT_DATA.showText,
        style: TextStyle(
          color: color,
          fontSize: PAINT_DATA.showFontSize,
          fontFamily: 'RobotoMono',
          // fontStyle: FontStyle.italic,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );

      textPainter.paint(canvas, const Offset(0, 0));
    }
  }

  void paintUserMode({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {}

  ({String showText, Color showColor, Color showbgColor, double showFontSize})
      get paintData {
    Set INTEGER_KEYS =
        Set.from(inputRecords.keys.where((item) => item.runtimeType == int));

    int countTrueFound = 0;
    int keyLastTrueFound = -1;
    for (int i in INTEGER_KEYS) {
      if (inputRecords[i]!.booleanValue == true) {
        countTrueFound += 1;
        keyLastTrueFound = i;
      }
    }

    if (countTrueFound == 0) {
      return (
        showText: inputRecords['default text']!.text,
        showbgColor: inputRecords['default text']!.colorBackGround,
        showColor: inputRecords['default text']!.colorForeGround,
        showFontSize: inputRecords['default text']!.fontSize,
      );
    } else if (countTrueFound == 1) {
      return (
        showText: inputRecords[keyLastTrueFound]!.text,
        showColor: inputRecords[keyLastTrueFound]!.colorForeGround,
        showFontSize: inputRecords[keyLastTrueFound]!.fontSize,
        showbgColor: inputRecords[keyLastTrueFound]!.colorBackGround
      );
    } else if (countTrueFound == INTEGER_KEYS.length) {
      return (
        showText: inputRecords['text when all are true']!.text,
        showColor: inputRecords['text when all are true']!.colorForeGround,
        showFontSize: inputRecords['text when all are true']!.fontSize,
        showbgColor: inputRecords['text when all are true']!.colorBackGround
      );
    } else {
      return (
        showText: inputRecords['text when more than one is true']!.text,
        showColor:
            inputRecords['text when more than one is true']!.colorForeGround,
        showFontSize: inputRecords['text when more than one is true']!.fontSize,
        showbgColor:
            inputRecords['text when more than one is true']!.colorBackGround
      );
    }
  }

  List<PointBoolean> get corners {
    final PAINT_DATA = paintData;

    final textSpan = TextSpan(
      text: PAINT_DATA.showText,
      style: TextStyle(
        fontSize: PAINT_DATA.showFontSize,
        fontFamily: 'RobotoMono',
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    //layout must be called first, only after that any size related property of
    //textPaint can be accessed
    textPainter.layout();

    final WIDTH = textPainter.width;
    final HEIGHT = textPainter.height;
    return [
      pivotPoint,
      pivotPoint +
          PointBoolean.rotatePointByAngle(PointBoolean(WIDTH, 0), angleRadians),
      pivotPoint +
          PointBoolean.rotatePointByAngle(
              PointBoolean(WIDTH, HEIGHT), angleRadians),
      pivotPoint +
          PointBoolean.rotatePointByAngle(
              PointBoolean(0, HEIGHT), angleRadians),
    ];
  }

  void addRecordEntry_() {
    RecordMultiText newRecordEntry = RecordMultiText.withDefaultValues();
    final Set<int> INTEGER_KEYS = Set.from(
        inputRecords.keys.where((element) => element.runtimeType == int));
    final int LARGEST_NUMBER = INTEGER_KEYS
        .reduce((value, element) => element > value ? element : value);
    final int NEW_KEY = LARGEST_NUMBER + 1;

    inputRecords[NEW_KEY] = newRecordEntry;
  }

  void deleteRecordEntry_(int KEY) {
    if (inputRecords.length - 3 > 1) {
      inputRecords.remove(KEY);
      output.remove(KEY);
      // previousStateOutput.remove(KEY);
    }
  }

  Map<double, Map<double, bool>> getClickableCoordinates(double GRID_GAP) {
    final PAINT_DATA = paintData;

    final textSpan = TextSpan(
      text: PAINT_DATA.showText,
      style: TextStyle(
        fontSize: PAINT_DATA.showFontSize,
        fontFamily: 'RobotoMono',
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    //layout must be called first, only after that any size related property of
    //textPaint can be accessed
    textPainter.layout();

    final WIDTH = textPainter.width;
    final HEIGHT = textPainter.height;

    return ClickableCoordinatesOperations
        .GET_CLICKABLE_COORDINATES_FROM_RECTANGLE(
      WIDTH: WIDTH,
      HEIGHT: HEIGHT,
      PIVOT_POINT: pivotPoint,
      GRID_GAP: GRID_GAP,
      ANGLE_RADIANS: angleRadians,
    );
  }

  ///Text button dialog
  ///```
  ///------------------------------X
  ///     Operation 1 button
  ///     Operation 2 button
  ///-------------------------------
  ///```
  ///Confirmation dialog
  ///```
  ///------------------------------x
  ///    Do you want to want to
  ///        "Operation 1"
  ///          <Confirm>
  ///-------------------------------
  ///```
  void userDialog_({
    required UserAlertBoxConfiguration CONFIG,
    required void Function(
            ({
              Type elementDataType,
              String keyOfElement,
              int keyOfOutputPort,
              ValueRequestFromUi valueRequestFromUi
            }))
        enqueueRequestsFromUi,
  }) {
    void confirmationDialog_(int outputKey) {
      showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (context) => Dialog(
          child: Container(
            width: CONFIG.widthConfirmationBox,
            color: CONFIG.colorConfirmationBox,
            child: Column(
              children: [
                Container(
                  width: CONFIG.cancelButtonSize,
                  height: CONFIG.cancelButtonSize,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(buildContext);
                    },
                    child: Icon(Icons.close, color: CONFIG.colorFont),
                  ),
                ),
                Text(
                  'Are you sure, you want to operate\n${output[outputKey]!['buttonText']}',
                  style: TextStyle(color: CONFIG.colorFont),
                ),
                Container(
                  width: CONFIG.widthConfirmButton,
                  height: CONFIG.heightConfirmButton,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      var keysOfOutput = output.keys;
                      int i = 0;
                      for (i = 0; i < keysOfOutput.length; ++i) {
                        if (outputKey == keysOfOutput.elementAt(i)) {
                          break;
                        }
                      }
                      enqueueRequestsFromUi(_GET_REQUEST_FROM_INDEX(i));
                      // for (var key in output.keys) {
                      //   if (key == outputKey) {
                      //     output[outputKey]!['value'] = true;
                      //     continue;
                      //   }
                      //   output[key]!['value'] = false;
                      // }
                      Navigator.pop(buildContext);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: CONFIG.colorFont),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    List<Widget> listWidget_() {
      List<Widget> listOfWidget = [];
      for (var key in output.keys) {
        listOfWidget.add(
          Container(
            width: CONFIG.widthButton,
            color: CONFIG.colorButton,
            child: TextButton(
              onPressed: () {
                confirmationDialog_(key);
                Navigator.pop(buildContext);
              },
              child: Text(
                output[key]!['buttonText'],
                style: TextStyle(color: CONFIG.colorFont),
              ),
            ),
          ),
        );
      }

      return listOfWidget;
    }

    Widget alertBox() {
      return Container(
        color: CONFIG.colorAlertBox,
        width: CONFIG.widthDialogBox,
        child: Column(
          children: [
            Container(
              width: CONFIG.cancelButtonSize,
              height: CONFIG.cancelButtonSize,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: Icon(Icons.close, color: CONFIG.colorFont),
              ),
            ),
            ListView(children: listWidget_()),
          ],
        ),
      );
    }

    showDialog(
      context: buildContext,
      barrierDismissible: true,
      builder: (context) => Dialog(
        child: alertBox(),
      ),
    );
  }

  //-------------------------------------Logic------------------------------------
  // Map<int, OutputPort> processBlock_(Map<int, InputPort> input) {
  //   scanInput_(input);
  //   return generateOutput();
  // }

  // void scanInput_(Map<int, InputPort> input) {
  //   for (var key in input.keys) {
  //     inputRecords[key]!.booleanValue = input[key]!.value.copy;
  //   }
  // }

  ({
    Type elementDataType,
    String keyOfElement,
    int keyOfOutputPort,
    ValueRequestFromUi valueRequestFromUi
  }) _GET_REQUEST_FROM_INDEX(int i) {
    return (
      elementDataType: MultiTextButton,
      keyOfElement: _KEY,
      keyOfOutputPort: i,
      valueRequestFromUi: ValueRequestFromUi.fromBoolean(true),
    );
  }

  // Map<int, OutputPort> generateOutput() {
  //   Map<int, OutputPort> outputPortMap = {};

  //   for (var key in output.keys) {
  //     if (output[key]!['value'] == true) {
  //       if (previousStateOutput[key] == true) {
  //         output[key]!['value'] = false;
  //       }
  //     }
  //     //previousStateOuput <- output
  //     previousStateOutput[key] = output[key]!['value'].copy;
  //     outputPortMap[key] = OutputPort(
  //       label: output[key]!['label'],
  //       portType: [PortType.boolean],
  //       value: output[key]!['label'],
  //     );
  //   }

  //   return outputPortMap;
  // }

  void userInputReceived(int key) {
    // print('USER INPUT KEY RECEIVED $key');
    for (int i in output.keys) {
      if (i == key) {
        output[i]!['value'] = true;
        // print('USER INPUT KEY RECEIVED $i ${output[key]!['value']}');
      } else {
        output[i]!['value'] = false;
        // print('USER INPUT KEY RECEIVED $i ${output[key]!['value']}');
      }
    }
    // print(this);
  }
  //----------------------methods for create dialog, edit dialog------------------
  // void editDialog_({
  //   required ItemBeingEdited itemBeingEdited,
  //   required ColorPickerData colorPickerData,
  //   required DialogBoxConfiguration CONFIG,
  // }) {}

  // static void createDialog_({
  //   required MultiTextButton multiTextButton,
  //   required ColorPickerData colorPickerData,
  //   required DialogBoxConfiguration CONFIG,
  // }) {
  //   showDialog(
  //     context: buildContext,
  //     barrierDismissible: false,
  //     builder: (context) => Dialog(
  //       backgroundColor: CONFIG.backGround,
  //       surfaceTintColor: CONFIG.backGround,
  //       child: SizedBox(
  //         width: CONFIG.width,
  //         child: Column(children: [
  //           Row(children: [
  //             const Spacer(),
  //             Tooltip(
  //               message: 'Cancel',
  //               child: Container(
  //                 width: CONFIG.cancelButtonSize,
  //                 height: CONFIG.cancelButtonSize,
  //                 color: CONFIG.backGroundCancelButton,
  //                 alignment: Alignment.center,
  //                 child: TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(buildContext);
  //                   },
  //                   child: Icon(Icons.close, color: CONFIG.fontColorButton),
  //                 ),
  //               ),
  //             ),
  //           ]),
  //           MultiTextButtonCreateDialogWidget(
  //             CONFIG: CONFIG,
  //             colorPickerData: colorPickerData,
  //             multiTextButton: multiTextButton,
  //           ),
  //         ]),
  //       ),
  //     ),
  //   );
  // }

  // static List<Widget> widgetForEachInput_({
  //   required MultiTextButton multiTextButton,
  //   required ColorPickerData colorPickerData,
  //   required DialogBoxConfiguration CONFIG,
  //   required bool THIS_IS_CREATE_DIALOG,
  // }) {
  //   List<Widget> widgetForText = [];

  //   // var propertyMap = multiTextBoolean.propertyMap;

  //   bool selectAlternatingColorOne = true;

  //   for (dynamic i in multiTextButton.inputRecords.keys) {
  //     providerForScreenDialog.addAll(
  //         {i: ChangeNotifierProvider((ref) => RecordMultiTextNotifier())});

  //     if (i.runtimeType != String) {
  //       widgetForText.add(RecordMultiTextDeleteWidget(
  //         element: multiTextButton,
  //         KEY: i,
  //         SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
  //         CONFIG: CONFIG,
  //         THIS_IS_CREATE_DIALOG: THIS_IS_CREATE_DIALOG,
  //       ));
  //     }
  //     widgetForText.add(RecordMultiTextEditWidget(
  //       recordMultiText: multiTextButton.inputRecords[i] ??
  //           RecordMultiText.withDefaultValues(),
  //       colorPickerData: colorPickerData,
  //       SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
  //       CONFIG: CONFIG,
  //       provider: providerForEachRecord[i],
  //     ));
  //     return widgetForText;
  //   }
  // }
}
