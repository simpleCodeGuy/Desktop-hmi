import 'package:flutter/material.dart';
import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/classes/input_elements.dart';
import 'package:simple_hmi/classes/logic_part.dart';
import 'package:simple_hmi/data/dialog_box_classes.dart';
import 'package:simple_hmi/providers/core_provider.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen2.dart';

import '/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_hmi/data/app_data.dart';
import 'package:simple_hmi/data/user_interface_data.dart';
import '/classes/enumerations.dart';
import '/methods/user_interface_methods.dart';
import '/providers/providers_1.dart';
import '/Presenter/presenter_logic_page.dart' as presenter_logic_page;

class ScreenCallback {
  final topBar = ScreenTopBarCallback();
  final mouseOperations = MouseOperationsOnScreenCallback();
  final newElement = NewElementOnScreenCallback();
}

class ScreenTopBarCallback {
  final screenMovement = CanvasMovementCallback();
  final operations = OperationsCallback();
  final snap = SnapOperationScreenCallback();
}

class StateCallback {
  static void numberOfSelectedItemsChanged() {
    CallbackNotifier.ref.read(moveOnScreenButtonProvider).rebuild();
    CallbackNotifier.ref.read(copyOnScreenButtonProvider).rebuild();
    CallbackNotifier.ref.read(rotateOnScreenButtonProvider).rebuild();
    CallbackNotifier.ref.read(propertiesButtonProvider).rebuild();
    CallbackNotifier.ref.read(deleteOnScreenButtonProvider).rebuild();
  }

  static void rebuildCanvas() {
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static void rebuildWidgetTypeWidth() {
    CallbackNotifier.ref.read(widgetTypeWidthProvider).rebuild();
  }
}

class CanvasMovementCallback {
  static void topLeft() {
    MoveScreen.topLeftShift(appData.moveScreen, appData.allScreenElements);

    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void left() {
    MoveScreen.leftShift(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void right() {
    MoveScreen.rightShift(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void up() {
    MoveScreen.upShift(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void down() {
    MoveScreen.downShift(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void zoomOriginal() {
    MoveScreen.zoomOriginal(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void zoomIn() {
    MoveScreen.zoomIn(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static void zoomOut() {
    MoveScreen.zoomOut(appData.moveScreen);
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }

  static UPDATE_AFTER_CANVAS_MOVEMENT_METHODS() {
    appData.gridScreen.generateGridPoints(
      currentScreenSize: appData.screenSize.canvasPresentSize,
      moveScreen: appData.moveScreen,
    );
    appData.snapPoints
        .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
      snapSelection: appData.snapPoints.snapSelection,
      allElements: appData.allScreenElements,
      gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
      moveScreen: appData.moveScreen,
    );
    StateCallback.rebuildCanvas();
  }

  static update_after_each_canvas_movement_click() {
    UPDATE_AFTER_CANVAS_MOVEMENT_METHODS();
  }
}

class OperationsCallback {
  static void cancelOnScreenButtonPressed() {
    KeyboardPressed.escapePressed();
  }

  static void editPropertiesButtonPressed() {
    EditOperationMethods.initializeEditingData(
      selectParameters: appData.selectParameters,
      allScreenElements: appData.allScreenElements,
      itemBeingEdited: appData.itemsBeingEdited,
    );

    print(appData.itemsBeingEdited);

    final ORIGINAL_ELEMENT_TYPE = appData.itemsBeingEdited.elementType;
    final ORIGINAL_ELEMENT_KEY = appData.itemsBeingEdited.keyOfItem;

    EditOperationMethods.openEditDialog(
        itemBeingEdited: appData.itemsBeingEdited,
        originalElement: appData.allScreenElements[ORIGINAL_ELEMENT_TYPE]
            [ORIGINAL_ELEMENT_KEY],
        CONFIG: appConfig.propertiesUpdate,
        colorPickerData: appData.colorPickerData,
        data: appData.dialogBoxForScreen,
        ELEMENT_TYPE: ORIGINAL_ELEMENT_TYPE,
        MOVE_SCREEN: appData.moveScreen,
        REBUILD_SCREEN_CALLBACK: StateCallback.rebuildCanvas,
        CANCEL_SELECTED_ITEMS: appData.selectParameters.cancelSelectedItems,
        kwargs_recalculate_clickable_coordinates: {
          #clickableCoordinates: appData.clickableCoordinates,
          #ALL_ELEMENTS: appData.allScreenElements,
          #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
        });
  }

  void deleteButtonPressed() {
    DeleteItems.deleteItemsWhichAreSelected(
        selectedItemsKeyMAPelementTypeListString:
            appData.selectParameters.keyOfAllSelectedElements,
        allElementsMAPelementTypeStringElement: appData.allScreenElements,
        RECALCULATE_CLICKABLE_COORDINATES:
            ClickableCoordinatesOperations.recalculateCoordinates,
        kwargs_recalculate_clickable_coordinates: {
          #clickableCoordinates: appData.clickableCoordinates,
          #ALL_ELEMENTS: appData.allScreenElements,
          #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
        });

    appData.selectParameters.cancelSelectedItems();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static void moveOnScreenButtonPressed() {
    ItemsBeingMoved.startMoveOperation(appData.itemsBeingMoved);
    ItemsBeingRotated.rotationCancel(appData.itemsBeingRotated);
  }

  static void rotateOnScreenButtonPressed() {
    ItemsBeingRotated.startRotateOperation(appData.itemsBeingRotated);
    ItemsBeingMoved.movementCancel(appData.itemsBeingMoved);
  }

  static void copyOnScreenButtonPressed() {
    appData.itemBeingCopied.startSingle();
    ItemsBeingMoved.movementCancel(appData.itemsBeingMoved);
    ItemsBeingRotated.rotationCancel(appData.itemsBeingRotated);
  }

  static void copyMultipleOnScreenButtonPressed() {
    appData.itemBeingCopied.startMultiple();
    ItemsBeingMoved.movementCancel(appData.itemsBeingMoved);
    ItemsBeingRotated.rotationCancel(appData.itemsBeingRotated);
  }

  void startSimulationButtonPressed() {}

  void stopSimulationButtonPressed() {}

  void undoButtonPressed() {}

  void redoButtonPressed() {}
}

class MouseOperationsOnScreenCallback {
  void mouseClickedOnScreen() {
    final ELEMENT_TYPE_AND_KEY =
        ClickableCoordinatesOperations.GET_ELEMENT_DETAILS_ON_CLICK(
            CLICKABLE_COORDINATES: appData.clickableCoordinates,
            CREATE_PARAMETERS: appData.createParameters,
            EDITED: appData.itemsBeingEdited,
            MOVED: appData.itemsBeingMoved,
            COPIED: appData.itemBeingCopied,
            ROTATED: appData.itemsBeingRotated,
            SELECT_PARAMETERS: appData.selectParameters,
            ALL_ELEMENTS: appData.allScreenElements,
            CURRENT_MOUSE_POSITION: appData.snapPoints.currentMousePosition,
            GRID_GAP: appData.gridScreen.gapBetweenGridPoints);

    if (ELEMENT_TYPE_AND_KEY != null) {
      UserInputOperations.dialog(
        element: appData.allScreenElements[ELEMENT_TYPE_AND_KEY.elementType]
            [ELEMENT_TYPE_AND_KEY.key],
        CONFIG: appConfig.userAlertBox,
      );
    } else {
      //Item creation
      if (appData.createParameters.elementType != ElementType.noElement) {
        CreateParameters.addAnotherPoint(appData.createParameters);

        if (ItemBeingCreated.updateItemBeingCreated(appData.itemBeingCreated,
            snapPoints: appData.snapPoints,
            createParameters: appData.createParameters,
            RECALCULATE_CLICKABLE_COORDINATES:
                ClickableCoordinatesOperations.recalculateCoordinates,
            kwargs_recalculate_clickable_coordinates: {
              #clickableCoordinates: appData.clickableCoordinates,
              #ALL_ELEMENTS: appData.allScreenElements,
              #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
            }).itemCreationComplete) {
          appData.snapPoints
              .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
            snapSelection: appData.snapPoints.snapSelection,
            allElements: appData.allScreenElements,
            gapBetweenBoundarySnapPoints:
                gapBetweenBoundaryPointsDuringSnapping,
            moveScreen: appData.moveScreen,
          );
        }
        CallbackNotifier.ref.read(screenProvider).rebuild();
      }

      //Item movement
      if (appData.itemsBeingMoved.waitingForFirstPoint) {
        ItemsBeingMoved.fromPointUpdated(appData.itemsBeingMoved,
            snapPoints: appData.snapPoints);
      } else if (appData.itemsBeingMoved.waitingForSecondPoint) {
        ItemsBeingMoved.movementComplete(
          itemsBeingMoved_: appData.itemsBeingMoved,
          allElementsMap_: appData.allScreenElements,
          selectParameters: appData.selectParameters,
          RECALCULATE_CLICKABLE_COORDINATES:
              ClickableCoordinatesOperations.recalculateCoordinates,
          kwargs_recalculate_clickable_coordinates: {
            #clickableCoordinates: appData.clickableCoordinates,
            #ALL_ELEMENTS: appData.allScreenElements,
            #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
          },
        );

        //UPDATE SELECTED ITEMS DUE TO SAME KEY,  BUT ELEMENT LOCATION CHANGE
        SelectParameters.updateSelectedElementsKeepingSameKeys(
            appData.selectParameters,
            allElements: appData.allScreenElements);

        CallbackNotifier.ref.read(screenProvider).rebuild();
      }

      //Item copy
      if (appData.itemBeingCopied.waitingForFirstPoint) {
        appData.itemBeingCopied
            .fromPointUpdated(snapPoints: appData.snapPoints);
      } else if (appData.itemBeingCopied.waitingForSecondPoint) {
        if (appData.itemBeingCopied.multipleCopyInProgress) {
          appData.itemBeingCopied.completeOneCopy(
            allElementsMap_: appData.allScreenElements,
            selectParameters: appData.selectParameters,
            RECALCULATE_CLICKABLE_COORDINATES:
                ClickableCoordinatesOperations.recalculateCoordinates,
            kwargs_recalculate_clickable_coordinates: {
              #clickableCoordinates: appData.clickableCoordinates,
              #ALL_ELEMENTS: appData.allScreenElements,
              #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
            },
          );
        } else {
          appData.itemBeingCopied.complete(
            allElementsMap_: appData.allScreenElements,
            selectParameters: appData.selectParameters,
            RECALCULATE_CLICKABLE_COORDINATES:
                ClickableCoordinatesOperations.recalculateCoordinates,
            kwargs_recalculate_clickable_coordinates: {
              #clickableCoordinates: appData.clickableCoordinates,
              #ALL_ELEMENTS: appData.allScreenElements,
              #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
            },
          );
        }

        //UPDATE SELECTED ITEMS DUE TO SAME KEY,  BUT ELEMENT LOCATION CHANGE
        // SelectParameters.updateSelectedElementsKeepingSameKeys(
        //     appData.selectParameters,
        //     allElements: appData.allScreenElements);

        CallbackNotifier.ref.read(screenProvider).rebuild();
      }

      //Item rotation
      if (appData.itemsBeingRotated.waitingForCentre) {
        ItemsBeingRotated.centrePointFound(appData.itemsBeingRotated,
            snapPoints: appData.snapPoints);
      } else if (appData.itemsBeingRotated.waitingForFrom) {
        if (appData.snapPoints.snapPointOnScreen
            .isNotEqualTo(appData.itemsBeingRotated.centrePoint)) {
          ItemsBeingRotated.fromPointFound(appData.itemsBeingRotated,
              snapPoints: appData.snapPoints);
        }
      } else if (appData.itemsBeingRotated.waitingForTo) {
        ItemsBeingRotated.rotationComplete(
          itemsBeingRotated_: appData.itemsBeingRotated,
          allElementsMap_: appData.allScreenElements,
          selectParameters: appData.selectParameters,
          clickableCoordinates: appData.clickableCoordinates,
          GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
        );
        SelectParameters.updateSelectedElementsKeepingSameKeys(
          appData.selectParameters,
          allElements: appData.allScreenElements,
        );

        CallbackNotifier.ref.read(screenProvider).rebuild();
      }
    }
  }

  void mouseDragStartOnScreen() {
    appData.selectParameters.updateFirstPointFromMousePosition();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  void mouseDragContinueOnScreen(PointBoolean localMousePosition) {
    if (appData.selectParameters.firstPointOfSelectRectangleReceived) {
      SnapPoints.updateCurrentMousePosition(
        appData.snapPoints,
        currentMousePosition: localMousePosition,
        moveScreen: appData.moveScreen,
        gridScreen: appData.gridScreen,
      );
      appData.selectParameters.updateSecondPointFromMousePosition();
      CallbackNotifier.ref.read(screenProvider).rebuild();
    }
  }

  void mouseDragStopOnScreen() {
    if (appData.selectParameters.isSelectionRectangleStillChanging) {
      appData.selectParameters.selectionComplete();

      CallbackNotifier.ref.read(screenProvider).rebuild();
    }
  }

  void mouseEnteredScreen() {
    appData.snapPoints.mouseIsInsideScreen();
  }

  void mouseExitedScreen() {
    appData.snapPoints.mouseIsOutsideScreen();

    CallbackNotifier.ref.read(xySnapPositionMessageProvider).rebuild();
  }

  void mouseMovedOnScreen({
    required PointBoolean currentLocalMousePosition,
  }) {
    if (!appData.snapPoints.mouseFirstTimeMovedOnScreen) {
      //This code is to create snapPoints from grid points when mouse first
      //moves to screen

      appData.snapPoints
          .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
        snapSelection: appData.snapPoints.snapSelection,
        allElements: appData.allScreenElements,
        gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
        moveScreen: appData.moveScreen,
      );
      appData.snapPoints.mouseFirstTimeMovedOnScreen = true;
    }

    appData.snapPoints.mouseIsInsideScreen();
    SnapPoints.updateCurrentMousePosition(
      appData.snapPoints,
      currentMousePosition: currentLocalMousePosition,
      moveScreen: appData.moveScreen,
      gridScreen: appData.gridScreen,
    );
    bool newSnapPointCalculated =
        appData.snapPoints.calculateSnapPointOnScreenDueToMouseMovement(
      snapPrecision: snapPrecision,
      moveScreen: appData.moveScreen,
      gridScreen: appData.gridScreen,
    );
    //REBUILD SCREEN IF NEW SNAP POINT IS GENERATED
    if (newSnapPointCalculated) {
      //Item creation
      if (appData.createParameters.arePointsAvailableForCreationStarting) {
        ItemBeingCreated.updateItemBeingCreated(
          appData.itemBeingCreated,
          snapPoints: appData.snapPoints,
          createParameters: appData.createParameters,
          RECALCULATE_CLICKABLE_COORDINATES:
              ClickableCoordinatesOperations.recalculateCoordinates,
          kwargs_recalculate_clickable_coordinates: {
            #clickableCoordinates: appData.clickableCoordinates,
            #ALL_ELEMENTS: appData.allScreenElements,
            #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
          },
        );
      }

      //Item movement
      if (appData.itemsBeingMoved.waitingForSecondPoint) {
        ItemsBeingMoved.updateDueToMouseMovement(
          appData.itemsBeingMoved,
          snapPoints: appData.snapPoints,
          selectParameters: appData.selectParameters,
          allElements: appData.allScreenElements,
          screenSize: appData.screenSize,
          moveScreen: appData.moveScreen,
        );
      }

      //Item copy
      if (appData.itemBeingCopied.waitingForSecondPoint) {
        appData.itemBeingCopied.updateDueToMouseMovement(
          snapPoints: appData.snapPoints,
          selectParameters: appData.selectParameters,
          allElements: appData.allScreenElements,
          screenSize: appData.screenSize,
          moveScreen: appData.moveScreen,
        );
      }

      //Item rotation
      if (appData.itemsBeingRotated.waitingForTo) {
        ItemsBeingRotated.updateItemsBeingRotated(
          appData.itemsBeingRotated,
          allElementsMap: appData.allScreenElements,
          selectParameters: appData.selectParameters,
          screenSize: appData.screenSize,
          snapPoints: appData.snapPoints,
        );
      }

      CallbackNotifier.ref.read(xySnapPositionMessageProvider).rebuild();
      StateCallback.rebuildCanvas();
    }
  }
}

class SnapOperationScreenCallback {
  void snapOnGridButtonPressed() {
    appData.snapPoints
        .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
      snapSelection: SnapPoints.getSnapSelectionWithToggledGrid(
          appData.snapPoints.snapSelection),
      allElements: appData.allScreenElements,
      gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
      moveScreen: appData.moveScreen,
    );

    CallbackNotifier.ref.read(snapOnGridButtonProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  void snapOnBoundaryButtonPressed() {
    appData.snapPoints
        .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
      snapSelection: SnapPoints.getSnapSelectionWithToggledBoundary(
          appData.snapPoints.snapSelection),
      allElements: appData.allScreenElements,
      gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
      moveScreen: appData.moveScreen,
    );

    CallbackNotifier.ref.read(snapOnBoundaryButtonProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  void snapOnEndPointButtonPressed() {
    appData.snapPoints
        .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
      snapSelection: SnapPoints.getSnapSelectionWithToggledEndPoint(
          appData.snapPoints.snapSelection),
      allElements: appData.allScreenElements,
      gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
      moveScreen: appData.moveScreen,
    );
    CallbackNotifier.ref.read(snapOnEndPointsButtonProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  void snapOnCentreButtonPressed() {
    appData.snapPoints
        .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
      snapSelection: SnapPoints.getSnapSelectionWithToggledCentre(
          appData.snapPoints.snapSelection),
      allElements: appData.allScreenElements,
      gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
      moveScreen: appData.moveScreen,
    );
    CallbackNotifier.ref.read(snapOnCentreButtonProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }
}

class NewElementOnScreenCallback {
  void lineCreateButtonPressed() {
    appData.selectParameters.cancelSelectedItems();
    appData.createParameters.itemSelectedForCreation_(
      ELEMENT_TYPE: ElementType.lineBoolean,
    );
  }

  void rectangleCreateButtonPressed() {
    appData.selectParameters.cancelSelectedItems();
    appData.createParameters.itemSelectedForCreation_(
      ELEMENT_TYPE: ElementType.rectangleBoolean,
    );
  }

  void circleCentrePointCreateButtonPressed() {
    appData.selectParameters.cancelSelectedItems();
    appData.createParameters.itemSelectedForCreation_(
      ELEMENT_TYPE: ElementType.circleBoolean,
    );
  }

  void circlePointPointCreateButtonPressed() {
    appData.createParameters.itemSelectedForCreation_(
      ELEMENT_TYPE: ElementType.circleBooleanPointPoint,
    );
  }

  void textCreateButtonPressed() {
    appData.selectParameters.cancelSelectedItems();
    appData.itemBeingCreated.item = TextBoolean(
      pivotPoint: appData.moveScreen.translate + const PointBoolean(10, 10),
      textFalse: ' ',
      textTrue: ' ',
    );

    appData.createParameters.itemSelectedForCreation_(
      ELEMENT_TYPE: ElementType.text,
    );

    StateCallback.rebuildCanvas();

    appData.itemBeingCreated.textCreateDialog(appConfig.propertiesUpdate);
  }

  static void multiTextCreateButtonPressed() {
    appData.selectParameters.cancelSelectedItems();

    appData.itemBeingCreated.updateItem_(MultiTextBoolean(
      pivotPoint: appData.moveScreen.translate + const PointBoolean(10, 10),
    ));

    appData.createParameters.itemSelectedForCreation_(
      ELEMENT_TYPE: ElementType.multiText,
    );

    StateCallback.rebuildCanvas();

    // print('ITEM SELECTED FOR CREATION');

    MultiTextMethods.multiTextCreateDialog_(
      // itemBeingCreated: appData.itemBeingCreated,
      multiTextBoolean: appData.itemBeingCreated.item,
      colorPickerData: appData.colorPickerData,
      CONFIG: appConfig.propertiesUpdate,
    );

    // print('MULTI TEXT CREATE BUTTON PRESSED');
  }

  static void multiTextButtonIconPressed() {
    DialogBoxForScreenOperations.createBox(
      data: appData.dialogBoxForScreen,
      itemBeingCreated: appData.itemBeingCreated,
      createParameters: appData.createParameters,
      ELEMENT_TYPE: ElementType.multiTextButton,
      MOVE_SCREEN: appData.moveScreen,
      REBUILD_SCREEN_CALLBACK: StateCallback.rebuildCanvas,
      CANCEL_SELECTED_ITEMS: appData.selectParameters.cancelSelectedItems,
      CONFIG: appConfig.propertiesUpdate,
    );
  }

  static void toggleButtonIconPressed() {
    print('toggle button pressed');
  }

  //text create callback
  static void textSizeDecreaseButtonPressed() {
    appData.itemBeingCreated.decreaseTextFontSize();
    CallbackNotifier.ref.read(textSizeProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static void textSizeIncreaseButtonPressed() {
    appData.itemBeingCreated.increaseTextFontSize();
    CallbackNotifier.ref.read(textSizeProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static void textUpdated(String text, {required bool isTrueText}) {
    if (isTrueText) {
      appData.itemBeingCreated.updateTrueTextTo(text);
    } else {
      appData.itemBeingCreated.updateFalseTextTo(text);
    }

    CallbackNotifier.ref.read(textSizeProvider).rebuild();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static void cancelTextCreateButtonPressed() {
    appData.createParameters.clear();
    appData.itemBeingCreated.clear();
    StateCallback.rebuildCanvas();
    // CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static void updateTextCreateButtonPressed() {}

  static void cancelMultiTextCreateButtonPressed() {
    appData.createParameters.clear();
    appData.itemBeingCreated.clear();
    StateCallback.rebuildCanvas();
  }
}

class WindowCallback {
  void screenSizeChanged({
    required RectangularBoundary currentScreenSize,
  }) {
    appData.gridScreen.generateGridPoints(
      currentScreenSize: currentScreenSize,
      moveScreen: appData.moveScreen,
    );
    appData.snapPoints
        .recalculateAllSnapPointsDueToSelectionChangeOrElementsChange(
      snapSelection: appData.snapPoints.snapSelection,
      allElements: appData.allScreenElements,
      gapBetweenBoundarySnapPoints: gapBetweenBoundaryPointsDuringSnapping,
      moveScreen: appData.moveScreen,
    );

    // print('SCREEN SIZE CHANGED');
    presenter_logic_page.presenter.screenSizeHasChanged();

    CallbackNotifier.ref.read(screenProvider).rebuild();
  }
}

class KeyboardPressed {
  void escapePressedInApp() {
    print('ESCAPE PRESSED');
    appData.selectParameters.cancelSelectedItems();
    appData.itemBeingCreated.clear();
    CreateParameters.emptyAll(appData.createParameters);
    ItemsBeingMoved.movementCancel(appData.itemsBeingMoved);
    ItemsBeingRotated.rotationCancel(appData.itemsBeingRotated);
    appData.itemsBeingEdited.cancel_();
    appData.itemBeingCopied.cancel();
    CallbackNotifier.ref.read(screenProvider).rebuild();
  }

  static escapePressed() {
    KeyboardPressed().escapePressedInApp();
  }
}

class CallbackScreenEditing {
  static void multiTextFontSizeRebuild() {
    CallbackNotifier.ref.read(multitextWidgetFontSizeProvider).rebuild();
  }

  static void multiTextTextFieldRebuild() {
    CallbackNotifier.ref.read(multitextWidgetTextProvider).rebuild();
  }

  static void multiTextBooleanRebuild() {
    CallbackNotifier.ref.read(multitextWidgetBooleanProvider).rebuild();
  }

  // static void multiTextEntryCreateAddedOrDeleted() {
  //   Navigator.pop(buildContext);
  //   MultiTextMethods.multiTextCreateDialog_(
  //     // itemBeingCreated: appData.itemBeingCreated,
  //     multiTextBoolean: appData.itemBeingCreated.item,
  //     colorPickerData: appData.colorPickerData,
  //     CONFIG: appConfig.propertiesUpdate,
  //   );
  //   StateCallback.rebuildCanvas();
  //   // multiTextTextFieldRebuild();
  //   // CallbackNotifier.ref.read(multitextDialogWidgetProvider).rebuild();
  // }

  static void multiTextEntryAddedOrDeleted(bool THIS_IS_CREATE_DIALOG) {
    Navigator.pop(buildContext);
    if (THIS_IS_CREATE_DIALOG) {
      MultiTextMethods.multiTextCreateDialog_(
        multiTextBoolean: appData.itemBeingCreated.item,
        colorPickerData: appData.colorPickerData,
        CONFIG: appConfig.propertiesUpdate,
      );
    } else {
      MultiTextMethods.multiTextEditDialog_(
          // itemBeingCreated: appData.itemBeingCreated,
          itemBeingEdited: appData.itemsBeingEdited,
          originalElement: appData.allScreenElements[ElementType.multiText]
              [appData.itemsBeingEdited.keyOfItem],
          colorPickerData: appData.colorPickerData,
          CONFIG: appConfig.propertiesUpdate,
          kwargs_recalculate_clickable_coordinates: {
            #clickableCoordinates: appData.clickableCoordinates,
            #ALL_ELEMENTS: appData.allScreenElements,
            #GRID_GAP: appData.gridScreen.gapBetweenGridPoints,
          });
    }
    StateCallback.rebuildCanvas();
    // multiTextTextFieldRebuild();
    // CallbackNotifier.ref.read(multitextDialogWidgetProvider).rebuild();
  }

  static void colorPickerHasUpdated() {
    CallbackNotifier.ref.read(colorPickerProvider).rebuild();
    StateCallback.rebuildCanvas();
  }
}
