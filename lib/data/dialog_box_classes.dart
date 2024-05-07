import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/methods/input_methods.dart';
import 'package:simple_hmi/methods/user_interface_methods.dart';
import 'package:simple_hmi/widgets/dialog_boxes_screen.dart';

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
//  data and classes
import '/data/app_data.dart';
import '/data/configuration.dart';
import '/data/logic_page_data.dart';
import '/classes/logic_part.dart';
import '/data/modbus_data.dart';
import '/classes/class_extensions.dart';
import '/classes/enumerations.dart';
import '/data/user_interface_data.dart';
import '/classes/input_elements.dart';
//providers
import '/providers/provider_dialog_boxes.dart';

class DialogBoxForScreen {
  Map inputProvider = {};
  Map outputProvider = {};
  dynamic contentRebuildProvider;
  dynamic neverRebuildProvider;
  ElementType? elementType;
  dynamic tempModifiedElement;
  dynamic SCREEN_REBUILD_CALLBACK;
  dynamic ref;

  DialogBoxForScreen() {
    contentRebuildProvider =
        ChangeNotifierProvider((ref) => TemporaryNotifier());
    neverRebuildProvider = ChangeNotifierProvider((ref) => TemporaryNotifier());

    // SCREEN_BUILD = StateCallback.rebuildCanvas;
  }
}

class DialogBoxForScreenOperations {
  static void createBox({
    required DialogBoxForScreen data,
    required ItemBeingCreated itemBeingCreated,
    required CreateParameters createParameters,
    required ElementType ELEMENT_TYPE,
    required MoveScreen MOVE_SCREEN,
    required Function REBUILD_SCREEN_CALLBACK,
    required Function CANCEL_SELECTED_ITEMS,
    required DialogBoxConfiguration CONFIG,
  }) {
    CANCEL_SELECTED_ITEMS();
    itemBeingCreated.updateItem_(GET_NEW_ELEMENT(ELEMENT_TYPE, MOVE_SCREEN));
    createParameters.itemSelectedForCreation_(ELEMENT_TYPE: ELEMENT_TYPE);
    initializeAsPerElement(
      data,
      itemBeingCreated.item,
      REBUILD_SCREEN_CALLBACK: REBUILD_SCREEN_CALLBACK,
    );
    REBUILD_SCREEN_CALLBACK();
    dialog(
      data: data,
      CLOSE_BUTTON_FUNCTION: closeButtonForCreate,
      closeButtonKwargs: {
        #itemBeingCreated: itemBeingCreated,
        #createParameters: createParameters,
        #data: data,
      },
      OK_BUTTON_FUNCTION: okButtonForCreate,
      okButtonKwargs: {},
      SCREEN_REBUILD: REBUILD_SCREEN_CALLBACK,
      CONFIG: CONFIG,
      TEXT_ON_OK_BUTTON: 'Create',
    );
  }

  static void editBox({
    required DialogBoxForScreen data,
    required ItemBeingEdited itemBeingEdited,
    required dynamic originalElement,
    required ElementType ELEMENT_TYPE,
    required MoveScreen MOVE_SCREEN,
    required Function REBUILD_SCREEN_CALLBACK,
    required Function CANCEL_SELECTED_ITEMS,
    required DialogBoxConfiguration CONFIG,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    initializeAsPerElement(
      data,
      itemBeingEdited.elementModified,
      REBUILD_SCREEN_CALLBACK: REBUILD_SCREEN_CALLBACK,
    );
    REBUILD_SCREEN_CALLBACK();
    dialog(
      data: data,
      CLOSE_BUTTON_FUNCTION: closeButtonForEditing,
      closeButtonKwargs: {
        #itemBeingEdited: itemBeingEdited,
        #data: data,
      },
      OK_BUTTON_FUNCTION: okButtonForEditing,
      okButtonKwargs: {
        #itemBeingEdited: itemBeingEdited,
        #originalElement: originalElement,
        #CANCEL_SELECTED_ITEM: CANCEL_SELECTED_ITEMS,
        #RECALCULATE_CLICKABLE_COORDINATES:
            ClickableCoordinatesOperations.recalculateCoordinates,
        #kwargs_recalculate_clickable_coordinates:
            kwargs_recalculate_clickable_coordinates,
      },
      SCREEN_REBUILD: REBUILD_SCREEN_CALLBACK,
      CONFIG: CONFIG,
      TEXT_ON_OK_BUTTON: 'Update',
    );
  }

  static dynamic GET_NEW_ELEMENT(
      ElementType ELEMENT_TYPE, MoveScreen moveScreen) {
    if (ELEMENT_TYPE == ElementType.multiTextButton) {
      return MultiTextButton(
          pivotPoint: moveScreen.translate + const PointBoolean(10, 10));
    }
  }

  static void updateRef(DialogBoxForScreen data, dynamic ref) {
    data.ref = ref;
  }

  static void initializeAsPerElement(
    DialogBoxForScreen data,
    dynamic element, {
    required dynamic REBUILD_SCREEN_CALLBACK,
  }) {
    data.tempModifiedElement = element;
    data.SCREEN_REBUILD_CALLBACK = REBUILD_SCREEN_CALLBACK;
    switch (element.runtimeType) {
      case MultiTextButton:
        data.elementType = ElementType.multiTextButton;
        break;
      default:
        data.elementType = ElementType.noElement;
    }
    generateProviders(data);
  }

  static void generateProviders(DialogBoxForScreen data) {
    if (data.elementType == ElementType.multiTextButton) {
      for (dynamic key in data.tempModifiedElement.inputRecords.keys) {
        data.inputProvider[key] =
            ChangeNotifierProvider((ref) => TemporaryNotifier());
        // data.inputProvider[key]['booleanValue'] =
        //     ChangeNotifierProvider((ref) => TemporaryNotifier());
        // data.inputProvider[key]['colorBackGround'] =
        //     ChangeNotifierProvider((ref) => TemporaryNotifier());
        // data.inputProvider[key]['colorForeGround'] =
        //     ChangeNotifierProvider((ref) => TemporaryNotifier());
        // data.inputProvider[key]['fontSize'] =
        //     ChangeNotifierProvider((ref) => TemporaryNotifier());
        // data.inputProvider[key]['text'] =
        //     ChangeNotifierProvider((ref) => TemporaryNotifier());
      }
      for (dynamic key in data.tempModifiedElement.output.keys) {
        data.outputProvider[key] =
            ChangeNotifierProvider((ref) => TemporaryNotifier());
        // for (dynamic stringKey in data.tempModifiedElement.output[key].keys) {
        //   data.outputProvider[key][stringKey] =
        //       ChangeNotifierProvider((ref) => TemporaryNotifier());
        // }
      }
    }
  }

  static void clear(DialogBoxForScreen data) {
    data.inputProvider.clear();
    data.outputProvider.clear();
    data.elementType = null;
    data.tempModifiedElement = null;
  }

  static void deleteInputRecord(DialogBoxForScreen data, dynamic KEY) {
    if (data.elementType == ElementType.multiTextButton) {
      data.tempModifiedElement.inputRecords.remove(KEY);
      data.inputProvider.remove(KEY);
    }
  }

  static void addInput(DialogBoxForScreen data) {
    if (data.elementType == ElementType.multiTextButton) {
      int largestKey = 0;
      for (dynamic key in data.tempModifiedElement.inputRecords.keys) {
        if (key.runtimeType == int) {
          if (key > largestKey) {
            largestKey = key;
          }
        }
      }
      data.tempModifiedElement.inputRecords[largestKey + 1] =
          RecordMultiText.withDefaultValues();
      data.inputProvider[largestKey + 1] =
          ChangeNotifierProvider((ref) => TemporaryNotifier());

      // data.inputProvider[largestKey + 1]['booleanValue'] =
      //     ChangeNotifierProvider((ref) => TemporaryNotifier());
      // data.inputProvider[largestKey + 1]['colorBackGround'] =
      //     ChangeNotifierProvider((ref) => TemporaryNotifier());
      // data.inputProvider[largestKey + 1]['colorForeGround'] =
      //     ChangeNotifierProvider((ref) => TemporaryNotifier());
      // data.inputProvider[largestKey + 1]['fontSize'] =
      //     ChangeNotifierProvider((ref) => TemporaryNotifier());
      // data.inputProvider[largestKey + 1]['text'] =
      //     ChangeNotifierProvider((ref) => TemporaryNotifier());
    }
  }

  static void addOutput(DialogBoxForScreen data) {
    if (data.elementType == ElementType.multiTextButton) {
      int largestKey = 0;
      for (int key in data.tempModifiedElement.output.keys) {
        if (key > largestKey) {
          largestKey = key;
        }
      }
      data.tempModifiedElement.output[largestKey + 1] = {
        'label': 'button ${largestKey + 1}',
        'buttonText': 'button ${largestKey + 1}',
        'value': false,
      };

      data.outputProvider[largestKey + 1] =
          ChangeNotifierProvider((ref) => TemporaryNotifier());
      // for (dynamic key
      //     in data.tempModifiedElement.output[largestKey + 1].keys) {
      //   data.outputProvider[largestKey + 1][key] =
      //       ChangeNotifierProvider((ref) => TemporaryNotifier());
      // }
      // data.tempModifiedElement.previousStateOutput[largestKey + 1] = false;
    }
  }

  static void deleteOutputRecord(DialogBoxForScreen data, int KEY) {
    if (data.elementType == ElementType.multiTextButton) {
      data.tempModifiedElement.output.remove(KEY);
      data.tempModifiedElement.previousOutputState.remove(KEY);
      data.outputProvider.remove(KEY);
    }
  }

  static void dialog({
    required DialogBoxForScreen data,
    required Function CLOSE_BUTTON_FUNCTION,
    required Map<Symbol, dynamic> closeButtonKwargs,
    required Function OK_BUTTON_FUNCTION,
    required Map<Symbol, dynamic> okButtonKwargs,
    required Function SCREEN_REBUILD,
    required DialogBoxConfiguration CONFIG,
    required String TEXT_ON_OK_BUTTON,
  }) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: CONFIG.backGround,
        surfaceTintColor: CONFIG.backGround,
        child: SizedBox(
          width: CONFIG.width,
          height: CONFIG.height +
              CONFIG.cancelButtonSize +
              CONFIG.buttonHeightForCreate,
          child: Column(children: [
            Row(children: [
              const Spacer(),
              Tooltip(
                message: 'Cancel',
                child: Container(
                  width: CONFIG.cancelButtonSize,
                  height: CONFIG.cancelButtonSize,
                  color: CONFIG.backGroundCancelButton,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Function.apply(
                          CLOSE_BUTTON_FUNCTION, [], closeButtonKwargs);
                      SCREEN_REBUILD();
                      Navigator.pop(buildContext);
                    },
                    child: Icon(Icons.close, color: CONFIG.fontColorButton),
                  ),
                ),
              ),
            ]),
            CreateEditDialogContent(
              data: data,
              CONFIG: CONFIG,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: CONFIG.backGroundUpdateButton,
              ),
              onPressed: () {
                Function.apply(OK_BUTTON_FUNCTION, [], okButtonKwargs);
                SCREEN_REBUILD();
                Navigator.pop(buildContext);
              },
              child: SizedBox(
                width: CONFIG.buttonWidth,
                height: CONFIG.buttonHeightForCreate,
                child: Center(
                  child: Text(
                    TEXT_ON_OK_BUTTON,
                    style: TextStyle(
                      color: CONFIG.fontColorButton,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  static void closeButtonForCreate({
    required ItemBeingCreated itemBeingCreated,
    required CreateParameters createParameters,
    required DialogBoxForScreen data,
  }) {
    createParameters.clear();
    itemBeingCreated.clear();
    clear(data);
  }

  static void okButtonForCreate() {}

  static void closeButtonForEditing({
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxForScreen data,
  }) {
    itemBeingEdited.scrapModifiedAndKeepOriginal_();
    itemBeingEdited.cancel_();
    clear(data);
  }

  static void okButtonForEditing({
    required ItemBeingEdited itemBeingEdited,
    required dynamic originalElement,
    required Function CANCEL_SELECTED_ITEM,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    print('###########################################');
    print('${kwargs_recalculate_clickable_coordinates}');
    itemBeingEdited.keepModified_(
      originalElement: originalElement,
      RECALCULATE_CLICKABLE_COORDINATES: RECALCULATE_CLICKABLE_COORDINATES,
      kwargs_recalculate_clickable_coordinates:
          kwargs_recalculate_clickable_coordinates,
    );
    itemBeingEdited.cancel_();
    CANCEL_SELECTED_ITEM();
  }

  static String GET_TEXT_INITIAL_VALUE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    final String TEXT;
    if (DATA.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        TEXT = DATA.tempModifiedElement.inputRecords[INPUT_KEY.first].text;
        return TEXT;
      } else if (OUTPUT_KEY.isNotEmpty) {
        TEXT = DATA.tempModifiedElement.output[OUTPUT_KEY.first]
            [OUTPUT_KEY.second];
        return TEXT;
      }
    }
    return '';
  }

  static void updateText({
    required DialogBoxForScreen data,
    required String NEW_TEXT,
    required List INPUT_KEY,
    // dynamic INPUT_KEY_2,
    required List OUTPUT_KEY,
    // dynamic OUTPUT_KEY_2,
  }) {
    if (data.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        data.tempModifiedElement.inputRecords[INPUT_KEY.first].text =
            NEW_TEXT.copy;
      } else if (OUTPUT_KEY.isNotEmpty) {
        data.tempModifiedElement.output[OUTPUT_KEY.first][OUTPUT_KEY.second] =
            NEW_TEXT.copy;
      }
    }
  }

  static dynamic GET_REBUILDING_PROVIDER_AFTER_TEXT_CHANGE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
    // dynamic INPUT_KEY_2,
    // dynamic OUTPUT_KEY_2,
  }) {
    if (DATA.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        return DATA.inputProvider[INPUT_KEY.first];
      } else if (OUTPUT_KEY.isNotEmpty) {
        return DATA.outputProvider[OUTPUT_KEY.first];
      }
    }
    return DATA.neverRebuildProvider;
  }

  static dynamic GET_REBUILDING_PROVIDER_AFTER_BOOLEAN_CHANGE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    return GET_REBUILDING_PROVIDER_AFTER_TEXT_CHANGE(
      DATA: DATA,
      INPUT_KEY: INPUT_KEY,
      // INPUT_KEY_2: INPUT_KEY_2,
      OUTPUT_KEY: OUTPUT_KEY,
      // OUTPUT_KEY_2: OUTPUT_KEY_2,
    );
  }

  static bool GET_BOOLEAN_VALUE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    final bool BOOL_VAL;
    if (DATA.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        BOOL_VAL =
            DATA.tempModifiedElement.inputRecords[INPUT_KEY.first].booleanValue;
        return BOOL_VAL.copy;
      } else if (OUTPUT_KEY.isNotEmpty) {
        BOOL_VAL = DATA.tempModifiedElement.output[OUTPUT_KEY.first]
            [OUTPUT_KEY.second];
        return BOOL_VAL.copy;
      }
    }
    return false;
  }

  static void updateBooleanValue({
    required bool NEW_BOOL_VALUE,
    required DialogBoxForScreen data,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (data.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        data.tempModifiedElement.inputRecords[INPUT_KEY.first].booleanValue =
            NEW_BOOL_VALUE.copy;
      } else if (OUTPUT_KEY.isNotEmpty) {
        data.tempModifiedElement.output[OUTPUT_KEY.first][OUTPUT_KEY.second] =
            NEW_BOOL_VALUE.copy;
      }
    }
  }

  static String GET_NAME_OF_TEXT({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (DATA.elementType == ElementType.multiTextButton) {
      MultiTextButton MULTI_TEXT_BUTTON = DATA.tempModifiedElement;
      if (INPUT_KEY.isNotEmpty) {
        if (INPUT_KEY.first.runtimeType == String) {
          return INPUT_KEY.first;
        } else {
          return 'Input: Enter text when value is true';
        }
        // return DATA.tempModifiedElement.inputRecords[INPUT_KEY_1].text;
      } else if (OUTPUT_KEY.isNotEmpty) {
        return 'Output: ${OUTPUT_KEY.second}';
        // return DATA.tempModifiedElement.output[OUTPUT_KEY_1][OUTPUT_KEY_2].copy;
        // return '';
      }
    }
    return ' ';
  }

  static dynamic GET_REBUILDING_PROVIDER_AFTER_FONT_SIZE_CHANGE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    return GET_REBUILDING_PROVIDER_AFTER_TEXT_CHANGE(
      DATA: DATA,
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
    );
  }

  static double GET_FONT_SIZE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (DATA.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        double VALUE =
            DATA.tempModifiedElement.inputRecords[INPUT_KEY.first].fontSize;
        return VALUE.copy;
      }
    }
    return 8.0;
  }

  static void increaseFontSize({
    required DialogBoxForScreen data,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (data.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        data.tempModifiedElement.inputRecords[INPUT_KEY.first].fontSize += 1.0;
      }
    }
  }

  static void decreaseFontSize({
    required DialogBoxForScreen data,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (data.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        if (data.tempModifiedElement.inputRecords[INPUT_KEY.first].fontSize >
            TextBoolean.MINIMUM_FONT_SIZE) {
          data.tempModifiedElement.inputRecords[INPUT_KEY.first].fontSize -=
              1.0;
        }
      }
    }
  }

  static dynamic GET_REBUILDING_PROVIDER_AFTER_COLOR_CHANGE({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) =>
      GET_REBUILDING_PROVIDER_AFTER_TEXT_CHANGE(
          DATA: DATA, INPUT_KEY: INPUT_KEY, OUTPUT_KEY: OUTPUT_KEY);

  static Color GET_COLOR({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (DATA.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        if (INPUT_KEY.second == 'colorForeGround') {
          Color VALUE = DATA.tempModifiedElement.inputRecords[INPUT_KEY.first]
              .colorForeGround;
          return VALUE.copy;
        } else if (INPUT_KEY.second == 'colorBackGround') {
          Color VALUE = DATA.tempModifiedElement.inputRecords[INPUT_KEY.first]
              .colorBackGround;
          return VALUE.copy;
        } else {
          return Colors.white;
        }
      }
    }
    return Colors.white;
  }

  static String GET_NAME_OF_COLOR({
    required DialogBoxForScreen DATA,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (DATA.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        if (INPUT_KEY.second == 'colorBackGround') {
          return 'font highlight color';
        } else {
          return 'font color';
        }
      }
    }
    return '';
  }

  static void updateColor({
    required Color NEW_COLOR,
    required DialogBoxForScreen data,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
  }) {
    if (data.elementType == ElementType.multiTextButton) {
      if (INPUT_KEY.isNotEmpty) {
        if (INPUT_KEY.second == 'colorBackGround') {
          data.tempModifiedElement.inputRecords[INPUT_KEY.first]
              .colorBackGround = NEW_COLOR.copy;
        } else if (INPUT_KEY.second == 'colorForeGround') {
          data.tempModifiedElement.inputRecords[INPUT_KEY.first]
              .colorForeGround = NEW_COLOR.copy;
        }
      }
    }
  }

  static void colorPickerDialog({
    required DialogBoxForScreen data,
    required List INPUT_KEY,
    required List OUTPUT_KEY,
    required DialogBoxConfiguration CONFIG,
  }) {
    Color EXISTING_COLOR = DialogBoxForScreenOperations.GET_COLOR(
      DATA: data,
      INPUT_KEY: INPUT_KEY,
      OUTPUT_KEY: OUTPUT_KEY,
    );

    dynamic PROVIDER =
        DialogBoxForScreenOperations.GET_REBUILDING_PROVIDER_AFTER_COLOR_CHANGE(
            DATA: data, INPUT_KEY: INPUT_KEY, OUTPUT_KEY: OUTPUT_KEY);

    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: CONFIG.backGroundColorPicker,
        surfaceTintColor: CONFIG.backGroundColorPicker,
        child: SizedBox(
          height: 800,
          child: Column(
            children: [
              Text(
                'Pick a color',
                style: TextStyle(
                  color: CONFIG.fontColorContent,
                ),
                textAlign: TextAlign.center,
              ),
              SingleChildScrollView(
                child: MaterialPicker(
                  portraitOnly: true,
                  // enableLabel: true,
                  pickerColor: EXISTING_COLOR,
                  // pickerColors: [Colors.yellow, Colors.blue],
                  onColorChanged: (color) {
                    DialogBoxForScreenOperations.updateColor(
                      NEW_COLOR: color,
                      data: data,
                      INPUT_KEY: INPUT_KEY,
                      OUTPUT_KEY: OUTPUT_KEY,
                    );
                    data.ref.read(PROVIDER).rebuild();
                    data.SCREEN_REBUILD_CALLBACK();
                    Navigator.pop(buildContext);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget HORIZONTAL_BANNER({
    required String TEXT,
    required double FONT_SIZE,
    required double BANNER_HEIGHT,
    required Color FONT_COLOR,
  }) {
    return SizedBox(
      height: BANNER_HEIGHT,
      child: Center(
        child: Text(
          TEXT,
          style: TextStyle(
            fontSize: FONT_SIZE,
            color: FONT_COLOR,
          ),
        ),
      ),
    );
  }
}

class UserInputOperations {
  static dialog({
    required dynamic element,
    required UserAlertBoxConfiguration CONFIG,
  }) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: CONFIG.colorAlertBox,
        surfaceTintColor: CONFIG.colorAlertBox,
        child: SizedBox(
          width: CONFIG.widthDialogBox,
          height: CONFIG.heightDialogBox,
          child: Column(
            children: [CLOSE_BUTTON_BANNER(CONFIG, context)] +
                [VERTICAL_SPACE(CONFIG)] +
                [
                  SizedBox(
                      height: CONFIG.heightDialogBox -
                          3 * CONFIG.heightVerticalSpace,
                      width: CONFIG.widthDialogBox,
                      child: ListView(
                          children: inputButtons(element, CONFIG, context)))
                ] +
                [VERTICAL_SPACE(CONFIG)],
          ),
        ),
      ),
    );
  }

  static Widget VERTICAL_SPACE(UserAlertBoxConfiguration CONFIG) {
    return SizedBox(height: CONFIG.heightVerticalSpace);
  }

  static Widget CLOSE_BUTTON_BANNER(
      UserAlertBoxConfiguration CONFIG, BuildContext CONTEXT) {
    return SizedBox(
        height: CONFIG.cancelButtonSize,
        width: CONFIG.widthDialogBox,
        child: Row(
          children: [
            SizedBox(
              width: CONFIG.widthDialogBox - CONFIG.cancelButtonSize,
              height: CONFIG.cancelButtonSize,
            ),
            Container(
              width: CONFIG.cancelButtonSize,
              height: CONFIG.cancelButtonSize,
              color: CONFIG.colorCancelButton,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(CONTEXT);
                },
                child: Icon(
                  Icons.close,
                  color: CONFIG.colorFont,
                ),
              ),
            ),
          ],
        ));
  }

  static List<Widget> inputButtons(
    dynamic element,
    UserAlertBoxConfiguration CONFIG,
    BuildContext CONTEXT,
  ) {
    switch (element.runtimeType) {
      case MultiTextButton:
        return inputButtonMultiTextButton(element, CONFIG, CONTEXT);

      default:
        return [const SizedBox(width: 50, height: 50)];
    }
  }

  static List<Widget> inputButtonMultiTextButton(
    dynamic element,
    UserAlertBoxConfiguration CONFIG,
    BuildContext CONTEXT,
  ) {
    MultiTextButton multiTextButton = element;
    List<Widget> widget = [];

    for (int key in multiTextButton.output.keys) {
      widget.add(
        Row(
          children: [
            Spacer(),
            Container(
              width: CONFIG.widthUserInputButton,
              height: CONFIG.heightUserInputButton,
              color: CONFIG.colorButton,
              child: TextButton(
                onPressed: () {
                  multiTextButton.userInputReceived(key);
                  // print(
                  //     '''button pressed : ${multiTextButton.output[key]!['buttonText']}''');
                  Navigator.pop(CONTEXT);
                },
                child: Text(
                  multiTextButton.output[key]!['buttonText'],
                  style: TextStyle(
                    color: CONFIG.colorFont,
                    fontSize: CONFIG.fontSizeUserInputButton,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      );
      widget.add(VERTICAL_SPACE(CONFIG));
    }
    widget.removeAt(widget.length - 1);
    return widget;
  }
}
