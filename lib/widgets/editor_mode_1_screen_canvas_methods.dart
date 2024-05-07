import 'package:flutter/material.dart';
import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/data/configuration.dart';
import 'package:simple_hmi/data/user_interface_data.dart';
import '/data/app_data.dart';
import '/classes/enumerations.dart';

class PaintElements {
  static Map whatToPaint = {
    ElementType.lineBoolean: {
      "existing": true,
      "selected": true,
      "created": true,
      "moved": true,
      "copied": true,
      "rotated": true,
      "edited": true,
    },
    ElementType.rectangleBoolean: {
      "existing": true,
      "selected": false,
      "created": false,
      "moved": false,
      "copied": false,
      "rotated": false,
      "edited": false,
    },
    ElementType.circleBoolean: {
      "existing": true,
      "selected": false,
      "created": false,
      "moved": false,
      "copied": false,
      "rotated": false,
      "edited": false,
    },
    ElementType.circleBooleanPointPoint: {
      "existing": true,
      "selected": false,
      "created": false,
      "moved": false,
      "copied": false,
      "rotated": false,
      "edited": false,
    },
    ElementType.text: {
      "existing": true,
      "selected": false,
      "created": false,
      "moved": false,
      "copied": false,
      "rotated": false,
      "edited": false,
    },
    ElementType.multiText: {
      "existing": true,
      "selected": false,
      "created": false,
      "moved": false,
      "copied": false,
      "rotated": false,
      "edited": false,
    },
    ElementType.multiTextButton: {
      "existing": true,
      "selected": false,
      "created": false,
      "moved": false,
      "copied": false,
      "rotated": false,
      "edited": false,
    },
  };

  static final List<ElementType> elementTypeList = [
    ElementType.lineBoolean,
    ElementType.rectangleBoolean,
    ElementType.circleBoolean,
    ElementType.circleBooleanPointPoint,
    ElementType.text,
    ElementType.multiText,
    ElementType.multiTextButton,
  ];

  static void paintGrid({
    required Canvas canvas,
    required SnapPoints snapPoints,
  }) {
    if (snapPoints.snapSelection[SnapOn.grid] == true) {
      final gridPaint = Paint();
      gridPaint.color = appConfig.screen.content.gridDot;
      gridPaint.strokeWidth = 1;

      for (final yFound in appData.gridScreen.gridPoints.keys) {
        for (final point in appData.gridScreen.gridPoints[yFound] ?? []) {
          PointBoolean pointn = MoveScreen.getTransformedPoint(
            moveScreen: appData.moveScreen,
            originalPoint: point,
          );

          canvas.drawCircle(
            Offset(pointn.x, pointn.y),
            appConfig.screen.content.gridDotWidth,
            gridPaint,
          );
        }
      }
    }
  }

  static void paintSnapPoint({required Canvas canvas}) {
    final snapPaint = Paint();
    snapPaint.color = appConfig.screen.content.snapDot;
    snapPaint.strokeWidth = appConfig.screen.content.snapDotWidth;
    canvas.drawCircle(
      Offset(
        appData.snapPoints.snapPointOnScreen
            .getTransformedPoint(appData.moveScreen)
            .x,
        appData.snapPoints.snapPointOnScreen
            .getTransformedPoint(appData.moveScreen)
            .y,
      ),
      appConfig.screen.content.snapDotWidth / 2,
      snapPaint,
    );
  }

  static void selectRectangle({required Canvas canvas}) {
    if (appData.selectParameters.isSelectionRectangleStillChanging) {
      final selectionBoxPaint = Paint();
      selectionBoxPaint.color = appConfig.screen.content.selectionBoxBoundary;
      selectionBoxPaint.style = PaintingStyle.stroke;
      Rect selectionBoxRectangle = Rect.fromPoints(
        Offset(
            appData.selectParameters.selectionRectangle.point1
                .getTransformedPoint(appData.moveScreen)
                .x,
            appData.selectParameters.selectionRectangle.point1
                .getTransformedPoint(appData.moveScreen)
                .y),
        Offset(
          appData.selectParameters.selectionRectangle.point2
              .getTransformedPoint(appData.moveScreen)
              .x,
          appData.selectParameters.selectionRectangle.point2
              .getTransformedPoint(appData.moveScreen)
              .y,
        ),
      );
      canvas.drawRect(
        selectionBoxRectangle,
        selectionBoxPaint,
      );
      final selectionBoxPaintFill = Paint();
      selectionBoxPaintFill.color = appConfig.screen.content.selectionBoxFill;
      selectionBoxPaintFill.style = PaintingStyle.fill;
      canvas.drawRect(
        selectionBoxRectangle,
        selectionBoxPaintFill,
      );
    }
  }

  static void paintExistingElements({
    required Map<dynamic, dynamic> allElementsMap,
    required Canvas canvas,
    required MoveScreen moveScreen,
    required SelectParameters selectParameters,
    required ItemsBeingMoved itemsBeingMoved,
    required ItemsBeingCopied itemsBeingCopied,
    required ItemsBeingRotated itemsBeingRotated,
    required AppConfiguration appConfiguration,
  }) {
    for (var elementType in elementTypeList) {
      if (whatToPaint[elementType]["existing"] == true) {
        var singleElementMap = allElementsMap[elementType];
        if (singleElementMap.length == 0) continue;
        for (final itemKey in singleElementMap.keys) {
          if (!((selectParameters.keyOfAllSelectedElements[elementType] ?? [])
              .contains(itemKey))) {
            singleElementMap[itemKey].paint(
              canvas: canvas,
              moveScreen: moveScreen,
            );
          } else if (itemsBeingMoved.itemsMovementInProgressFlag ||
              itemsBeingRotated.itemsRotationInProgressFlag ||
              itemsBeingCopied.itemsCopyInProgressFlag) {
            singleElementMap[itemKey].paint(
              canvas: canvas,
              moveScreen: moveScreen,
              percentageOpacity: appConfiguration
                  .screen.content.alphaWhenParentItemMovedOrRotated,
            );
          }
        }
      }
    }
  }

  static paintItemBeingCreated({
    required ItemBeingCreated itemBeingCreated,
    required CreateParameters createParameters,
    required Canvas canvas,
    required MoveScreen moveScreen,
  }) {
    if (createParameters.arePointsAvailableForCreationStarting) {
      itemBeingCreated.item.paint(canvas: canvas, moveScreen: moveScreen);
    }
  }

  static paintItemBeingMoved({
    required ItemsBeingMoved itemsBeingMoved,
    required Canvas canvas,
    required MoveScreen moveScreen,
  }) {
    if (itemsBeingMoved.itemsMovementInProgressFlag) {
      for (final elementType in elementTypeList) {
        var sameElementMap = itemsBeingMoved.itemsBeingMovedMap[elementType];
        for (final element in (sameElementMap ?? {}).values) {
          element.paint(canvas: canvas, moveScreen: moveScreen);
        }
      }
    }
  }

  static paintItemBeingSelected({
    required SelectParameters selectParameters,
    required Canvas canvas,
    required MoveScreen moveScreen,
    required AppConfiguration appConfiguration,
    required ItemsBeingMoved itemsBeingMoved,
    required ItemsBeingRotated itemsBeingRotated,
    required ItemsBeingCopied itemsBeingCopied,
    required ItemBeingEdited itemBeingEdited,
  }) {
    if (!(itemsBeingMoved.itemsMovementInProgressFlag ||
        itemsBeingRotated.itemsRotationInProgressFlag ||
        itemsBeingCopied.itemsCopyInProgressFlag ||
        itemBeingEdited.editingUnderProgress)) {
      for (var elementType in elementTypeList) {
        for (var element
            in (selectParameters.allSelectedElements[elementType] ?? {})
                .values) {
          element.paint(
            canvas: canvas,
            moveScreen: moveScreen,
            overrideColor: appConfiguration.screen.content.selectedItem,
          );
        }
      }
    }
  }

  static paintItemBeingRotated({
    required ItemsBeingRotated itemsBeingRotated,
    required Canvas canvas,
    required MoveScreen moveScreen,
  }) {
    if (itemsBeingRotated.itemsRotationInProgressFlag) {
      for (final elementType in elementTypeList) {
        for (final element
            in (itemsBeingRotated.itemsBeingRotatedMap[elementType]).values) {
          element.paint(canvas: canvas, moveScreen: moveScreen);
        }
      }
    }
  }

  //copied
  static paintItemBeingCopied({
    required ItemsBeingCopied itemsBeingCopied,
    required Canvas canvas,
    required MoveScreen moveScreen,
  }) {
    if (itemsBeingCopied.itemsCopyInProgressFlag) {
      for (final elementType in itemsBeingCopied.itemMapTypeKeyElement.keys) {
        for (final item
            in itemsBeingCopied.itemMapTypeKeyElement[elementType].values) {
          item.paint(canvas: canvas, moveScreen: moveScreen);
        }
      }
    }
  }

  //edited
  static paintItemBeingEdited({
    required ItemBeingEdited itemBeingEdited,
    required Canvas canvas,
    required MoveScreen moveScreen,
  }) {
    if (itemBeingEdited.editingUnderProgress) {
      itemBeingEdited.elementModified
          .paint(canvas: canvas, moveScreen: moveScreen);
    }
  }

  static void paintRotated({
    required Canvas canvas,
    required Function functionToPaint,
    required Paint paint,
    required dataToBePainted,
    required PointBoolean PIVOT,
    required double ANGLE_RADIANS,
  }) {
    canvas.save();

    canvas.translate(PIVOT.x, PIVOT.y);

    canvas.rotate(ANGLE_RADIANS);

    functionToPaint(dataToBePainted, paint);

    canvas.restore();
  }

  static void rotationPreOperations({
    required Canvas canvas,
    required PointBoolean PIVOT,
    required double ANGLE_RADIANS,
  }) {
    canvas.save();

    canvas.translate(PIVOT.x, PIVOT.y);

    canvas.rotate(ANGLE_RADIANS);
  }

  static void rotationPostOperations({required Canvas canvas}) {
    canvas.restore();
  }

  static void nonRotationPreOperations({
    required Canvas canvas,
    required PointBoolean PIVOT,
  }) {
    canvas.save();
    canvas.translate(PIVOT.x, PIVOT.y);
  }

  static void nonRotationPostOperations({required Canvas canvas}) =>
      PaintElements.rotationPostOperations(canvas: canvas);
}

/*
  Stuff to write while making new elements

  - Make new element class, and write all necessary methods
  - 
*/
