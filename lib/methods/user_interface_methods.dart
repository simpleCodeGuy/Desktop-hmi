// import 'dart:math';
import 'package:simple_hmi/classes/logic_part.dart';
import 'package:simple_hmi/data/dialog_box_classes.dart';
import 'package:simple_hmi/data/user_interface_data.dart';
import 'package:simple_hmi/methods/input_methods.dart';
// import 'package:simple_hmi/providers/core_provider.dart';
import '/classes/elements.dart';
import '/data/app_data.dart';

import 'package:simple_hmi/classes/elements.dart';
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
//widgets
import '/widgets/editor_mode_1_screen2.dart';

//providers
import '/providers/providers_1.dart';

class ElementMethods {
  static void appendCopyOfItemToElementMap({
    required Map<dynamic, dynamic> allScreenElements,
    required dynamic newElement,
    required ElementType elementType,
  }) {
    var sameElementMap = allScreenElements[elementType];

    // var listOfKeysNumericForm = sameElementMap.keys();
    bool formerKeyGreaterThanLater(String firstKey, String secondKey) =>
        num.parse(firstKey) > num.parse(secondKey);

    //getting key containing max value
    String keyOfMaxValue =
        sameElementMap.length == 0 ? '0' : sameElementMap.keys.first;
    for (String keyOfSameElement in sameElementMap.keys) {
      keyOfMaxValue = formerKeyGreaterThanLater(keyOfMaxValue, keyOfSameElement)
          ? keyOfMaxValue
          : keyOfSameElement;
    }

    String newKey = (num.parse(keyOfMaxValue) + 1).toString();

    print('newKey = ${newKey}');

    newElement.assignKey(newKey);

    allScreenElements[elementType].addAll({newKey: newElement.copy});

    // print(allScreenElements);
  }

  static List<PointBoolean> getAllSnapPoints({
    required Map<dynamic, dynamic> allElements,
    required double gap,
    required Map<SnapOn, bool> snapSelection,
    required List<ElementType> elementTypeList,
  }) {
    List<PointBoolean> allSnapPoints = [];

    for (final elementType in elementTypeList) {
      for (final elementKey in allElements[elementType].keys) {
        allSnapPoints.addAll(
          allElements[elementType][elementKey].getSnapPoints(
            snapSelection: snapSelection,
            gap: gap,
          ),
        );
      }
    }
    return allSnapPoints;
  }

  static void deleteElements({
    required dynamic sameElementMap,
    required List<dynamic> keyOfItemListString,
  }) {
    for (String keyFound in keyOfItemListString) {
      sameElementMap.remove(keyFound);
    }
  }

  static Map<String, dynamic>? getSelectedElementsCopyFromSelectRectangle({
    required Map<dynamic, dynamic> sameElementTypeMap,
    required RectangularBoundary selectRectangle,
  }) {
    Map<String, dynamic>? itemCopy = {};
    for (String keyFound in sameElementTypeMap.keys) {
      if ((sameElementTypeMap[keyFound]).isInsideSelectRectangle(
        selectRectangle,
        appData.spaceBetweenPoints,
      )) {
        itemCopy[keyFound] = sameElementTypeMap[keyFound].copy;
      }
    }
    if (itemCopy == {}) {
      return null;
    } else {
      return itemCopy;
    }
  }

  static void updateCopyOfItemInList({
    required Map<String, dynamic> sameElementTypeMap,
    required dynamic keyOfItemToBeUpdated,
    required dynamic elementToBeReplaced,
  }) {
    sameElementTypeMap[keyOfItemToBeUpdated] = elementToBeReplaced.copy;
  }

  static dynamic createNewElement(CreateParameters createParameters) {
    if (createParameters.elementType == ElementType.lineBoolean) {
      return LineBoolean(
        point1: createParameters.points[0],
        point2: createParameters.points[1],
      );
    } else if (createParameters.elementType == ElementType.rectangleBoolean) {
      return RectangleBoolean.fromOppositeCorners(
        corner1: createParameters.points[0],
        corner3: createParameters.points[1],
      );
    } else if (createParameters.elementType == ElementType.circleBoolean) {
      return CircleBoolean.fromCentrePoint(
        centre: createParameters.points[0],
        point: createParameters.points[1],
      );
    } else if (createParameters.elementType ==
        ElementType.circleBooleanPointPoint) {
      return CircleBoolean.fromOppositeCorners(
        diameterOneEnd: createParameters.points[0],
        diameterOtherEnd: createParameters.points[1],
      );
    } else if (createParameters.elementType == ElementType.text) {
      return TextBoolean(
        pivotPoint: createParameters.points[0],
        textFalse: '',
        textTrue: '',
      );
    }
  }

  static Map<dynamic, dynamic> getCopyOfMovedElements({
    required Map<dynamic, dynamic> originalElementMap,
    required List<dynamic> keyOfItemsToBeMoved,
    required MoveParameters moveParameters,
    required RectangularBoundary boundaryOfAllSelectedElements,
    required RectangularBoundary screenSize,
  }) {
    Map<String, dynamic> copyOfMovedSameTypeElement = {};
    for (String keyFound in keyOfItemsToBeMoved) {
      dynamic copyOfItem = _getCopyOfMovedElement(
        itemToBeMoved: originalElementMap[keyFound],
        moveParameters: moveParameters,
        boundaryOfAllSelectedElements: boundaryOfAllSelectedElements,
        screenSize: screenSize,
      );
      copyOfMovedSameTypeElement.addAll({keyFound: copyOfItem});
    }
    return copyOfMovedSameTypeElement;
  }

  static dynamic _getCopyOfMovedElement({
    required dynamic itemToBeMoved,
    required MoveParameters moveParameters,
    required RectangularBoundary boundaryOfAllSelectedElements,
    required RectangularBoundary screenSize,
  }) {
    var newItem = itemToBeMoved.copy;
    _moveSingleElement(
      element_: newItem,
      moveParameters: moveParameters,
      boundaryOfAllSelectedElements: boundaryOfAllSelectedElements,
      screenSize: screenSize,
    );
    return newItem;
  }

  static void _moveSingleElement({
    required dynamic element_,
    required MoveParameters moveParameters,
    required RectangularBoundary boundaryOfAllSelectedElements,
    required RectangularBoundary screenSize,
  }) {
    // final RectangularBoundary boundaryOfAllSelectedElementsIfMoved =
    //     boundaryOfAllSelectedElements.move(moveParameters);

    // if (boundaryOfAllSelectedElementsIfMoved
    //     .isInsideGivenBoundary(screenSize)) {
    //   element_.move(moveParameters);
    // }
    element_.move(moveParameters);
  }

  static Map<String, dynamic> getCopyOfRotatedElements({
    required Map<dynamic, dynamic> sameElementTypeMap,
    required List<dynamic> keyOfItemsToBeRotated,
    required RotateParameters rotateParameters,
    required RectangularBoundary boundaryOfAllSelectedElements,
    required RectangularBoundary screenSize,
  }) {
    Map<String, dynamic> copyOfRotatedElement = {};
    for (String keyFound in keyOfItemsToBeRotated) {
      var copyOfItem = _getCopyOfSingleRotatedElement(
        itemToBeRotated: sameElementTypeMap[keyFound],
        rotateParameters: rotateParameters,
        boundaryOfAllSelectedElements: boundaryOfAllSelectedElements,
        screenSize: screenSize,
      );
      copyOfRotatedElement.addAll({keyFound: copyOfItem});
    }
    return copyOfRotatedElement;
  }

  static dynamic _getCopyOfSingleRotatedElement({
    required dynamic itemToBeRotated,
    required RotateParameters rotateParameters,
    required RectangularBoundary boundaryOfAllSelectedElements,
    required RectangularBoundary screenSize,
  }) {
    var elementCopy = itemToBeRotated.copy;
    _rotateSingleElement(
      element_: elementCopy,
      rotateParameters: rotateParameters,
      boundaryOfAllSelectedElements: boundaryOfAllSelectedElements,
      screenSize: screenSize,
    );
    return elementCopy;
  }

  static void _rotateSingleElement({
    required dynamic element_,
    required RotateParameters rotateParameters,
    required RectangularBoundary boundaryOfAllSelectedElements,
    required RectangularBoundary screenSize,
  }) {
    // if (boundaryOfAllSelectedElements.isAfterRotationRemainInsideGivenBoundary(
    //   rotateParameters: rotateParameters,
    //   rectangularBoundary: screenSize,
    // )) {
    //   element_.rotate(rotateParameters);
    // }
    element_.rotate(rotateParameters);
  }

  static PointBoolean getTopLeft({required Map<dynamic, dynamic> allElements}) {
    List<PointBoolean> points = [];
    for (final ELEMENT_TYPE in allElements.keys) {
      for (final ELEMENT_KEY in allElements[ELEMENT_TYPE].keys) {
        points.add(allElements[ELEMENT_TYPE][ELEMENT_KEY].topLeft);
      }
    }
    return PointBoolean.getMostTopLeft(points) ?? const PointBoolean.zero();
  }
}

class EditOperationMethods {
  static void minusPressedInWidgetTypeWidth({
    required dynamic itemModified,
    required double STEP_SIZE,
    required dynamic PROPERTY_STRING,
    required double? LOWER_CONSTRAINT,
    required double CURRENT_VALUE,
  }) {
    Map<String, Map<Property, dynamic>> NEW_PROPERTY = {
      PROPERTY_STRING: {Property.value: CURRENT_VALUE - STEP_SIZE}
    };

    if (LOWER_CONSTRAINT == null) {
      if (CURRENT_VALUE - STEP_SIZE >= 0.5) {
        itemModified.updateProperty(NEW_PROPERTY);
      }
    } else if (CURRENT_VALUE - STEP_SIZE >= LOWER_CONSTRAINT) {
      itemModified.updateProperty(NEW_PROPERTY);
    }
  }

  static void plusPressedInWidgetTypeWidth({
    required dynamic itemModified,
    required double STEP_SIZE,
    required dynamic PROPERTY_STRING,
    required double? UPPER_CONSTRAINT,
    required double CURRENT_VALUE,
  }) {
    Map<String, Map<Property, dynamic>> NEW_PROPERTY = {
      PROPERTY_STRING: {Property.value: CURRENT_VALUE + STEP_SIZE}
    };

    if (UPPER_CONSTRAINT == null) {
      itemModified.updateProperty(NEW_PROPERTY);
    } else if (CURRENT_VALUE + STEP_SIZE <= UPPER_CONSTRAINT) {
      itemModified.updateProperty(NEW_PROPERTY);
    }
  }

  ///This is the FIRST step in editing an element
  ///
  ///Editing operation of any element requires following steps
  ///- 1 initializeEditingData_
  ///- 2 openEditDialog_
  ///- 3 clearEditingData_
  static void initializeEditingData({
    required SelectParameters selectParameters,
    required Map<dynamic, dynamic> allScreenElements,
    required ItemBeingEdited itemBeingEdited,
  }) {
    ElementType? elementType;
    String? elementKey;
    dynamic element;

    //identifying details of selected element which is to be edited
    for (var el in selectParameters.keyOfAllSelectedElements.keys) {
      if (appData.selectParameters.keyOfAllSelectedElements[el].length == 1) {
        elementType = el;
        elementKey = appData.selectParameters.keyOfAllSelectedElements[el][0];
        break;
      }
    }
    element = allScreenElements[elementType][elementKey];

    itemBeingEdited.editStarted(
      ORIGINAL_ELEMENT: element,
      ELEMENT_TYPE: elementType ?? ElementType.lineBoolean,
      KEY_OF_ITEM: elementKey ?? '',
    );
  }

  ///This is the SECOND step in editing an element
  ///
  ///Editing operation of any element requires following steps
  ///- 1 initializeEditingData_
  ///- 2 openEditDialog_
  ///- 3 clearEditingData_
  static void openEditDialog({
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxConfiguration CONFIG,
    required dynamic originalElement,
    required ColorPickerData colorPickerData,
    required DialogBoxForScreen data,
    required ElementType ELEMENT_TYPE,
    required MoveScreen MOVE_SCREEN,
    required Function REBUILD_SCREEN_CALLBACK,
    required Function CANCEL_SELECTED_ITEMS,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    switch (itemBeingEdited.elementType) {
      case ElementType.lineBoolean:
        LineBoolean.editDialog_(
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          DIALOG_BOX_CONFIG: CONFIG,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
        );
        break;
      case ElementType.rectangleBoolean:
        RectangleBoolean.editDialog_(
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          DIALOG_BOX_CONFIG: CONFIG,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
        );
        break;
      case ElementType.circleBoolean:
        CircleBoolean.editDialog_(
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          DIALOG_BOX_CONFIG: CONFIG,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
        );
        break;
      case ElementType.circleBooleanPointPoint:
        CircleBoolean.editDialog_(
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          DIALOG_BOX_CONFIG: CONFIG,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
        );
        break;
      case ElementType.text:
        TextBoolean.editDialog_(
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          DIALOG_BOX_CONFIG: CONFIG,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
        );
        break;
      case ElementType.multiText:
        MultiTextMethods.multiTextEditDialog_(
          CONFIG: CONFIG,
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          colorPickerData: colorPickerData,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
          // itemBeingCreated: itemBeingCreated,
        );
      case ElementType.multiTextButton:
        DialogBoxForScreenOperations.editBox(
          data: data,
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          ELEMENT_TYPE: ELEMENT_TYPE,
          MOVE_SCREEN: MOVE_SCREEN,
          REBUILD_SCREEN_CALLBACK: REBUILD_SCREEN_CALLBACK,
          CANCEL_SELECTED_ITEMS: CANCEL_SELECTED_ITEMS,
          CONFIG: CONFIG,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
        );
        break;
      default:
    }
  }

  ///This is the THIRD step in editing an element
  ///This method is called in when update or cancel button is tapped.
  ///
  ///Editing operation of any element requires following steps
  ///- 1 initializeEditingData_
  ///- 2 openEditDialog_
  ///- 3 clearEditingData_
  static void clearEditingData_(dynamic itemBeingEdited) {
    // itemBeingEdited.cancel_();
    KeyboardPressed.escapePressed();
  }

  static void colorPickerDialog({
    required dynamic itemModified,
    required String PROPERTY_STRING,
    required DialogBoxConfiguration CONFIG,
  }) {
    // ItemBeingEdited.updateNoOfLayerOfOpenDialog(itemBeingEdited_,
    //     noOfLayersOfDialogOpen: 2);
    final PROPERTY_ENTRY = itemModified.property[PROPERTY_STRING];

    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: CONFIG.backGroundColorPicker,
        surfaceTintColor: CONFIG.backGroundColorPicker,
        child: SizedBox(
          height: 800,
          child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              activatorForDialogLevel2Escape: () {
                print('COLOR PICKER:  ESCAPE PRESSED');
              }
            },
            child: Focus(
              autofocus: true,
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
                      pickerColor: PROPERTY_ENTRY[Property.value],
                      // pickerColors: [Colors.yellow, Colors.blue],
                      onColorChanged: (color) {
                        // Map propertyTemp =
                        //     itemBeingEdited_.elementBeingEdited.property;
                        // propertyTemp[propertyKey][Property.value] = color;
                        final NEW_PROPERTY = {
                          PROPERTY_STRING: {Property.value: color}
                        };

                        itemModified.updateProperty(NEW_PROPERTY);
                        // ItemBeingEdited.updateNoOfLayerOfOpenDialog(
                        //     itemBeingEdited_,
                        //     noOfLayersOfDialogOpen: 1);
                        CallbackNotifier.ref
                            .read(widgetTypeColorProvider)
                            .rebuild();
                        StateCallback.rebuildCanvas();
                        Navigator.pop(buildContext);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static dialogBox_({
    // required dynamic element_,
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required dynamic originalElement,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: DIALOG_BOX_CONFIG.backGround,
        child: SizedBox(
          width: DIALOG_BOX_CONFIG.width,
          child: Padding(
            padding: EdgeInsets.all(DIALOG_BOX_CONFIG.boxPadding),
            child: ListView(
              children: widgetColumnSubpart(
                DIALOG_BOX_CONFIG: DIALOG_BOX_CONFIG,
                itemBeingEdited: itemBeingEdited,
                originalElement: originalElement,
                RECALCULATE_CLICKABLE_COORDINATES:
                    RECALCULATE_CLICKABLE_COORDINATES,
                kwargs_recalculate_clickable_coordinates:
                    kwargs_recalculate_clickable_coordinates,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<Widget> widgetColumnSubpart({
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required ItemBeingEdited itemBeingEdited,
    required dynamic originalElement,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    final itemModified = itemBeingEdited.elementModified;
    final property = itemModified.property;
    List<Widget> columnWidget = [];

    for (String propertyString in property.keys) {
      switch (property[propertyString][Property.propertyType]) {
        case PropertyTypeOfElement.boolean:
          columnWidget.add(
            widgetPropertyTypeBoolean(
              PROPERTY_STRING: propertyString,
              itemModified: itemModified,
              DIALOG_BOX_CONFIG: DIALOG_BOX_CONFIG,
            ),
          );
          break;
        case PropertyTypeOfElement.width:
          columnWidget.add(
            widgetPropertyTypeWidth(
              itemModified: itemModified,
              PROPERTY_STRING: propertyString,
              CONFIG: DIALOG_BOX_CONFIG,
            ),
          );
          break;
        case PropertyTypeOfElement.color:
          columnWidget.add(
            widgetPropertyTypeColor(
              itemModified: itemModified,
              PROPERTY_STRING: propertyString,
              CONFIG: DIALOG_BOX_CONFIG,
            ),
          );
          break;
      }
    }
    columnWidget.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: DIALOG_BOX_CONFIG.backGroundCancelButton,
          ),
          onPressed: () {
            itemBeingEdited.scrapModifiedAndKeepOriginal_();
            EditOperationMethods.clearEditingData_(itemBeingEdited);
            // StateCallback.rebuildCanvas();
            // StateCallback.numberOfSelectedItemsChanged();

            Navigator.pop(buildContext);
          },
          child: SizedBox(
            width: DIALOG_BOX_CONFIG.buttonWidth,
            child: Text(
              'Cancel',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DIALOG_BOX_CONFIG.fontColorButton,
              ),
            ),
          ),
        ),
        SizedBox(
          width: DIALOG_BOX_CONFIG.buttonWidth * 2,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: DIALOG_BOX_CONFIG.backGroundUpdateButton,
          ),
          onPressed: () {
            // ItemBeingEdited.copyToOriginal(
            //   originalElement_: element_,
            //   itemBeingEdited: itemBeingEdited_,
            // );
            itemBeingEdited.keepModified_(
              originalElement: originalElement,
              RECALCULATE_CLICKABLE_COORDINATES:
                  ClickableCoordinatesOperations.recalculateCoordinates,
              kwargs_recalculate_clickable_coordinates:
                  kwargs_recalculate_clickable_coordinates,
            );
            EditOperationMethods.clearEditingData_(itemBeingEdited);
            Navigator.pop(buildContext);
          },
          child: SizedBox(
            width: DIALOG_BOX_CONFIG.buttonWidth,
            child: Text(
              'Update',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DIALOG_BOX_CONFIG.fontColorButton,
              ),
            ),
          ),
        ),
      ],
    ));

    return columnWidget;
  }

  static Widget widgetPropertyTypeBoolean({
    required String PROPERTY_STRING,
    required dynamic itemModified,
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
  }) {
    return WidgetTypeBoolean(
      PROPERTY_STRING: PROPERTY_STRING,
      itemModified: itemModified,
      CONFIG: DIALOG_BOX_CONFIG,
    );
  }

  static Widget widgetPropertyTypeWidth({
    required dynamic itemModified,
    required String PROPERTY_STRING,
    required DialogBoxConfiguration CONFIG,
  }) {
    return WidgetTypeWidth(
      itemModified: itemModified,
      PROPERTY_STRING: PROPERTY_STRING,
      CONFIG: CONFIG,
    );
  }

  static Widget widgetPropertyTypeColor({
    required dynamic itemModified,
    required DialogBoxConfiguration CONFIG,
    required String PROPERTY_STRING,
  }) {
    return WidgetTypeColor(
      itemModified: itemModified,
      PROPERTY_STRING: PROPERTY_STRING,
      CONFIG: CONFIG,
    );
  }
}

class MultiTextMethods {
  static double MINIMUM_FONT_SIZE = 6;

  static void multiTextEditDialog_({
    required ItemBeingEdited itemBeingEdited,
    required MultiTextBoolean originalElement,
    required ColorPickerData colorPickerData,
    required DialogBoxConfiguration CONFIG,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    MultiTextBoolean modifiedElement = itemBeingEdited.elementModified;
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: CONFIG.backGround,
        surfaceTintColor: CONFIG.backGround,
        child: MultiTextEditDialogWidget(
          CONFIG: CONFIG,
          colorPickerData: colorPickerData,
          // multiTextBoolean: multiTextBoolean,
          itemBeingEdited: itemBeingEdited,
          originalElement: originalElement,
          modifiedElement: modifiedElement,
          kwargs_recalculate_clickable_coordinates:
              kwargs_recalculate_clickable_coordinates,
          // itemBeingCreated: itemBeingCreated,
        ),
      ),
    );
  }

  static void multiTextCreateDialog_({
    required MultiTextBoolean multiTextBoolean,
    required ColorPickerData colorPickerData,
    required DialogBoxConfiguration CONFIG,
  }) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: CONFIG.backGround,
        surfaceTintColor: CONFIG.backGround,
        child: MultiTextCreateDialogWidget(
          CONFIG: CONFIG,
          colorPickerData: colorPickerData,
          // itemBeingCreated: itemBeingCreated,
          multiTextBoolean: multiTextBoolean,
        ),
      ),
    );
  }

  static List<Widget> widgetForEachColumn_({
    required MultiTextBoolean multiTextBoolean,
    required ColorPickerData colorPickerData,
    required DialogBoxConfiguration CONFIG,
    required bool THIS_IS_CREATE_DIALOG,
  }) {
    List<Widget> widgetForText = [];

    var propertyMap = multiTextBoolean.propertyMap;

    bool selectAlternatingColorOne = true;

    for (int i in propertyMap.keys) {
      widgetForText.add(MultitextWidgetDelete(
        multiTextBoolean: multiTextBoolean,
        KEY_OF_RECORD: i,
        SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
        CONFIG: CONFIG,
        THIS_IS_CREATE_DIALOG: THIS_IS_CREATE_DIALOG,
      ));
      widgetForText.add(MultitextWidgetBoolean(
        multiTextBoolean: multiTextBoolean,
        KEY_OF_RECORD: i,
        SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
        CONFIG: CONFIG,
      ));
      widgetForText.add(MultitextWidgetText(
        multiTextBoolean: multiTextBoolean,
        KEY_OF_RECORD: i,
        SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
        CONFIG: CONFIG,
      ));
      widgetForText.add(MultitextWidgetFontSize(
        multiTextBoolean: multiTextBoolean,
        KEY_OF_RECORD: i,
        SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
        CONFIG: CONFIG,
      ));
      widgetForText.add(MultitextWidgetColorBackground(
        multiTextBoolean: multiTextBoolean,
        colorPickerData: colorPickerData,
        KEY_OF_RECORD: i,
        SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
        CONFIG: CONFIG,
      ));
      widgetForText.add(MultitextWidgetColorForeground(
        multiTextBoolean: multiTextBoolean,
        colorPickerData: colorPickerData,
        KEY_OF_RECORD: i,
        SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
        CONFIG: CONFIG,
      ));
      selectAlternatingColorOne = !selectAlternatingColorOne;
    }
    widgetForText.add(MultitextWidgetAdd(
      multiTextBoolean: multiTextBoolean,
      SELECT_ALTERNATING_COLOR_ONE: selectAlternatingColorOne,
      CONFIG: CONFIG,
      THIS_IS_CREATE_DIALOG: THIS_IS_CREATE_DIALOG,
    ));
    return widgetForText;
  }

  static Widget updateCancelDialogForCreate_({
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required MultiTextBoolean multiTextBoolean,
  }) {
    return SizedBox(
      height: 200,
      width: 800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: DIALOG_BOX_CONFIG.backGroundCancelButton,
            ),
            onPressed: () {
              KeyboardPressed.escapePressed();
              Navigator.pop(buildContext);
            },
            child: SizedBox(
              width: DIALOG_BOX_CONFIG.buttonWidth,
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DIALOG_BOX_CONFIG.fontColorButton,
                ),
              ),
            ),
          ),
          SizedBox(
            width: DIALOG_BOX_CONFIG.buttonWidth * 2,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: DIALOG_BOX_CONFIG.backGroundUpdateButton,
            ),
            onPressed: () {
              Navigator.pop(buildContext);
            },
            child: SizedBox(
              width: DIALOG_BOX_CONFIG.buttonWidth,
              child: Text(
                'Create',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DIALOG_BOX_CONFIG.fontColorButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget updateCancelDialogForEdit_({
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required MultiTextBoolean multiTextBoolean,
    required ItemBeingEdited itemBeingEdited,
    required MultiTextBoolean originalElement,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    return SizedBox(
      height: 200,
      width: 800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: DIALOG_BOX_CONFIG.backGroundCancelButton,
            ),
            onPressed: () {
              itemBeingEdited.scrapModifiedAndKeepOriginal_();
              EditOperationMethods.clearEditingData_(itemBeingEdited);
              Navigator.pop(buildContext);
            },
            child: SizedBox(
              width: DIALOG_BOX_CONFIG.buttonWidth,
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DIALOG_BOX_CONFIG.fontColorButton,
                ),
              ),
            ),
          ),
          SizedBox(
            width: DIALOG_BOX_CONFIG.buttonWidth * 2,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: DIALOG_BOX_CONFIG.backGroundUpdateButton,
            ),
            onPressed: () {
              itemBeingEdited.keepModified_(
                originalElement: originalElement,
                RECALCULATE_CLICKABLE_COORDINATES:
                    RECALCULATE_CLICKABLE_COORDINATES,
                kwargs_recalculate_clickable_coordinates:
                    kwargs_recalculate_clickable_coordinates,
              );
              EditOperationMethods.clearEditingData_(itemBeingEdited);
              Navigator.pop(buildContext);
            },
            child: SizedBox(
              width: DIALOG_BOX_CONFIG.buttonWidth,
              child: Text(
                'Update',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DIALOG_BOX_CONFIG.fontColorButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void increase_font_size_({
    required MultiTextBoolean multiTextItem,
    required int RECORD_KEY,
  }) {
    double EXISTING_FONT_SIZE = multiTextItem.records[RECORD_KEY]!.fontSize;
    final Map<int, Map<String, Map<Property, dynamic>>> PROPERTY_MAP = {
      RECORD_KEY: {
        'font size': {Property.value: EXISTING_FONT_SIZE + 1}
      }
    };

    multiTextItem.updateProperty(PROPERTY_MAP);
  }

  static void decrease_font_size_({
    required MultiTextBoolean multiTextItem,
    required int RECORD_KEY,
  }) {
    double EXISTING_FONT_SIZE = multiTextItem.records[RECORD_KEY]!.fontSize;

    if (EXISTING_FONT_SIZE > MINIMUM_FONT_SIZE) {
      final Map<int, Map<String, Map<Property, dynamic>>> PROPERTY_MAP = {
        RECORD_KEY: {
          'font size': {Property.value: EXISTING_FONT_SIZE - 1}
        }
      };
      multiTextItem.updateProperty(PROPERTY_MAP);
    }
  }

  static void updateText_({
    required MultiTextBoolean multiTextItem,
    required String NEW_TEXT,
    required int RECORD_KEY,
  }) {
    final Map<int, Map<String, Map<Property, dynamic>>> PROPERTY_MAP;
    if (NEW_TEXT == '') {
      PROPERTY_MAP = {
        RECORD_KEY: {
          'text': {Property.value: ' '}
        }
      };
    } else {
      PROPERTY_MAP = {
        RECORD_KEY: {
          'text': {Property.value: NEW_TEXT}
        }
      };
    }
    multiTextItem.updateProperty(PROPERTY_MAP);
  }

  static void updateBooleanValue_({
    required MultiTextBoolean multiTextBoolean,
    required bool BOOLEAN_VALUE,
    required int RECORD_KEY,
  }) {
    final Map<int, Map<String, Map<Property, dynamic>>> PROPERTY_MAP = {
      RECORD_KEY: {
        'boolean value': {Property.value: BOOLEAN_VALUE}
      }
    };
    multiTextBoolean.updateProperty(PROPERTY_MAP);
  }
}
