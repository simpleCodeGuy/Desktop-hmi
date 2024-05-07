import 'package:flutter/material.dart';
import 'package:simple_hmi/classes/logic_part.dart';
import 'package:simple_hmi/data/app_data.dart';
import 'package:simple_hmi/data/configuration.dart';
import 'dart:math';
import 'package:simple_hmi/data/user_interface_data.dart';
import 'package:simple_hmi/methods/input_methods.dart';
import 'package:simple_hmi/methods/user_interface_methods.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen2.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen_canvas_methods.dart';
import '/classes/enumerations.dart';

class LineBoolean {
/*  
         ---------------------------------------------
      point1                                       point2
*/
  static const double lineThicknessLowerConstraint = 0.5;
  static const double lineThicknessUpperConstraint = 20;
  bool val = false;
  PointBoolean point1 = const PointBoolean(0, 0);
  PointBoolean point2 = const PointBoolean(0, 0);
  double lineThickness = 3;
  double borderThickness = 0.5;
  Color fillColorWhenValIsFalse = const Color.fromARGB(255, 100, 100, 100);
  Color fillColorWhenValIsTrue = const Color.fromARGB(255, 255, 255, 0);

  // Color borderColorWhenValIsFalse = const Color.fromARGB(255, 255, 255, 255);
  // Color borderColorWhenValIsTrue = const Color.fromARGB(255, 255, 255, 255);
  // static double stepSizeForIteration = 1;
  // ParametersForRotatedElements? parametersForRotatedElements;

  LineBoolean({
    bool? val,
    PointBoolean? point1,
    PointBoolean? point2,
    double? lineThickness,
    double? borderThickness,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
    // Color? borderColorWhenValIsFalse,
    // Color? borderColorWhenValIsTrue,
  }) {
    this.val = val ?? this.val;
    this.point1 = point1 ?? this.point1;
    this.point2 = point2 ?? this.point2;
    this.lineThickness = lineThickness ?? this.lineThickness;
    this.borderThickness = borderThickness ?? this.borderThickness;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
    // this.borderColorWhenValIsFalse =
    //     borderColorWhenValIsFalse ?? this.borderColorWhenValIsFalse;
    // this.borderColorWhenValIsTrue =
    //     borderColorWhenValIsTrue ?? this.borderColorWhenValIsTrue;
  }

  void updateProperties({
    bool? val,
    PointBoolean? point1,
    PointBoolean? point2,
    double? lineThickness,
    double? borderThickness,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
    // Color? borderColorWhenValIsFalse,
    // Color? borderColorWhenValIsTrue,
  }) {
    this.val = val ?? this.val;
    this.point1 = point1 ?? this.point1;
    this.point2 = point2 ?? this.point2;
    this.lineThickness = lineThickness ?? this.lineThickness;
    this.borderThickness = borderThickness ?? this.borderThickness;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
    // this.borderColorWhenValIsFalse =
    //     borderColorWhenValIsFalse ?? this.borderColorWhenValIsFalse;
    // this.borderColorWhenValIsTrue =
    //     borderColorWhenValIsTrue ?? this.borderColorWhenValIsTrue;
  }

  static LineBoolean clone(LineBoolean lineBooleanOld) {
    return LineBoolean(
      val: lineBooleanOld.val,
      point1: lineBooleanOld.point1,
      point2: lineBooleanOld.point2,
      lineThickness: lineBooleanOld.lineThickness,
      borderThickness: lineBooleanOld.borderThickness,
      fillColorWhenValIsFalse: lineBooleanOld.fillColorWhenValIsFalse,
      fillColorWhenValIsTrue: lineBooleanOld.fillColorWhenValIsTrue,
      // borderColorWhenValIsFalse: lineBooleanOld.borderColorWhenValIsFalse,
      // borderColorWhenValIsTrue: lineBooleanOld.borderColorWhenValIsTrue,
    );
  }

  LineBoolean get copy => LineBoolean.clone(this);

  // Color get showColor => val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse;

  ({Color showColor}) get paintData {
    return (showColor: val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse);
  }

  PointBoolean get topLeft {
    //top left of screen means bottom left of coordinate system
    return PointBoolean.getMostTopLeft([point1, point2]) ??
        const PointBoolean.zero();
  }

  void updateFrom(LineBoolean lineBooleanOld) {
    val = lineBooleanOld.val;
    point1 = lineBooleanOld.point1;
    point2 = lineBooleanOld.point2;
    lineThickness = lineBooleanOld.lineThickness;
    borderThickness = lineBooleanOld.borderThickness;
    fillColorWhenValIsFalse = lineBooleanOld.fillColorWhenValIsFalse;
    fillColorWhenValIsTrue = lineBooleanOld.fillColorWhenValIsTrue;
    // borderColorWhenValIsFalse = lineBooleanOld.borderColorWhenValIsFalse;
    // borderColorWhenValIsTrue = lineBooleanOld.borderColorWhenValIsTrue;
  }

  void move(MoveParameters moveParameters) {
    updateProperties(
      point1: point1 + moveParameters.offsetAsAPoint,
      point2: point2 + moveParameters.offsetAsAPoint,
    );
  }

  void rotate(RotateParameters rotateParameters) {
    updateProperties(
      point1: point1.rotatedPoint(rotateParameters),
      point2: point2.rotatedPoint(rotateParameters),
    );
  }

  bool isInsideSelectRectangle(
    RectangularBoundary selectRectangle,
    double spaceBetweenPoints,
  ) {
    List<PointBoolean> linePoints = [point1];
    linePoints.addAll(LineBoolean.getBoundaryPointsOfLine(
      point1: point1,
      point2: point2,
      gap: spaceBetweenPoints,
    ));
    linePoints.add(point2);
    bool isAnyPointFoundInside = false;

    for (PointBoolean point in linePoints) {
      isAnyPointFoundInside = point.isInsideBoundary(selectRectangle);
      if (isAnyPointFoundInside) {
        break;
      }
    }

    return isAnyPointFoundInside;
  }

  bool get isDummy => point1.isEqualTo(point2);

  static List<PointBoolean> getBoundaryPointsOfLine({
    required PointBoolean point1,
    required PointBoolean point2,
    required double gap,
  }) {
    List<PointBoolean> listOfBoundaryPoints = [];

    var previousPoint = point1.copy;
    double currentGapfromThisToEnd = previousPoint.distanceFrom(point2);

    int countOfLoopIteration = 0;
    while (currentGapfromThisToEnd > gap && countOfLoopIteration++ <= 10000) {
      var newPoint = previousPoint.getNewPointInDirectionOfGivenPoint(
        other: point2,
        gap: gap,
      );
      listOfBoundaryPoints.add(newPoint.copy);
      previousPoint = newPoint.copy;
      currentGapfromThisToEnd = newPoint.distanceFrom(point2);
    }
    return listOfBoundaryPoints;
  }

  List<PointBoolean> get endPoints {
    return [point1, point2];
  }

  List<PointBoolean> get centrePoints {
    return [point1.getCentreWith(point2)];
  }

  List<PointBoolean> boundaryPoints({required double gap}) {
    return LineBoolean.getBoundaryPointsOfLine(
      point1: point1,
      point2: point2,
      gap: gap,
    );
  }

  List<PointBoolean> getSnapPoints({
    required Map<SnapOn, bool> snapSelection,
    required double gap,
  }) {
    List<PointBoolean> pointList = [];
    if (snapSelection[SnapOn.endPoint] == true) {
      pointList.addAll(endPoints);
    }
    if (snapSelection[SnapOn.centre] == true) {
      pointList.addAll(centrePoints);
    }
    if (snapSelection[SnapOn.boundary] == true) {
      pointList.addAll(boundaryPoints(gap: gap));
    }
    return pointList;
  }

  RectangularBoundary get getBoundary =>
      RectangularBoundary.getBoundaryFromPoints([point1, point2]) ??
      const RectangularBoundary.allCornersZero();

  Map<String, Map<Property, dynamic>> get property => {
        'boolean value': {
          Property.propertyType: PropertyTypeOfElement.boolean,
          Property.value: val,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'line thickness': {
          Property.propertyType: PropertyTypeOfElement.width,
          Property.value: lineThickness,
          Property.lowerConstraint: LineBoolean.lineThicknessLowerConstraint,
          Property.upperConstraint: LineBoolean.lineThicknessUpperConstraint,
        },
        'fill color when value is false': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsFalse,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is true': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsTrue,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
      };

  void updateProperty(Map<String, Map<Property, dynamic>> propertyInput) {
    for (final property in propertyInput.keys) {
      switch (property) {
        case 'boolean value':
          val = propertyInput[property]![Property.value];
          break;
        case 'line thickness':
          lineThickness = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is false':
          fillColorWhenValIsFalse = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is true':
          fillColorWhenValIsTrue = propertyInput[property]![Property.value];
          break;
      }
    }
  }

  LineBoolean getCopyDueToScreenMoved(MoveScreen moveScreen) {
    LineBoolean tempLine = copy;
    var p1 = MoveScreen.getTransformedPoint(
        moveScreen: moveScreen, originalPoint: point1);
    var p2 = MoveScreen.getTransformedPoint(
        moveScreen: moveScreen, originalPoint: point2);
    tempLine.updateProperties(point1: p1, point2: p2);
    return tempLine;
  }

  void paint({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {
    var line = getCopyDueToScreenMoved(moveScreen);

    var paint = Paint();
    paint.color = overrideColor ?? paintData.showColor;
    paint.color
        .withAlpha(paint.color.alpha * (percentageOpacity ?? 100) ~/ 100);
    paint.strokeWidth = lineThickness * moveScreen.scale;

    // if (percentageOpacity != null) {
    //   paint.color =
    //       paint.color.withAlpha(paint.color.alpha * percentageOpacity ~/ 100);
    // }

    canvas.drawLine(
      Offset(line.point1.x, line.point1.y),
      Offset(line.point2.x, line.point2.y),
      paint,
    );
  }

  void paintUserMode({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {}

  static void editDialog_({
    required dynamic originalElement,
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    /* 
     * edit dialog gives map to a property map to a procedure
     * This procedure already has access to items being edited
     * copy of originalItem is kept
     * as per property tags screen dialog is generated
     * in editing mode, item on screen is edited
     * when OK is said, edited item is left as is
     * when Cancel is pressed, originalItem copy is moved to screenElements
     */
    EditOperationMethods.dialogBox_(
      itemBeingEdited: itemBeingEdited,
      DIALOG_BOX_CONFIG: DIALOG_BOX_CONFIG,
      originalElement: originalElement,
      RECALCULATE_CLICKABLE_COORDINATES:
          ClickableCoordinatesOperations.recalculateCoordinates,
      kwargs_recalculate_clickable_coordinates:
          kwargs_recalculate_clickable_coordinates,
    );
  }

  late String _KEY;
  void assignKey(String KEY) {
    _KEY = KEY;
  }

  @override
  String toString() {
    return 'LineBoolean $point1 $point2';
  }
}

class RectangleBoolean {
/*
  corner2           corner3
    --------------------
    |                  |
    |                  |
    |                  |
    --------------------
  corner1           corner4
*/
  bool val = false;

  PointBoolean corner1 = const PointBoolean(0, 0);
  PointBoolean corner2 = const PointBoolean(0, 0);
  PointBoolean corner3 = const PointBoolean(0, 0);
  PointBoolean corner4 = const PointBoolean(0, 0);

  Color fillColorWhenValIsFalse = const Color.fromARGB(255, 100, 100, 100);
  Color fillColorWhenValIsTrue = const Color.fromARGB(255, 255, 255, 0);
  // ParametersForRotatedElements? parametersForRotatedElements;

  late String _KEY;
  void assignKey(String KEY) {
    _KEY = KEY;
  }

  RectangleBoolean({
    bool? val,
    PointBoolean? corner1,
    PointBoolean? corner2,
    PointBoolean? corner3,
    PointBoolean? corner4,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    this.corner1 = corner1 ?? this.corner1;
    this.corner2 = corner2 ?? this.corner2;
    this.corner3 = corner3 ?? this.corner3;
    this.corner4 = corner4 ?? this.corner4;
    this.val = val ?? this.val;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  RectangleBoolean.fromOppositeCorners({
    bool? val,
    required this.corner1,
    // PointBoolean? corner2,
    required this.corner3,
    // PointBoolean? corner4,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    corner2 = PointBoolean(corner1.x, corner3.y).copy;
    corner4 = PointBoolean(corner3.x, corner1.y).copy;
    this.val = val ?? this.val;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  void updateProperties({
    bool? val,
    PointBoolean? corner1,
    PointBoolean? corner2,
    PointBoolean? corner3,
    PointBoolean? corner4,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    this.val = val ?? this.val;
    this.corner1 = corner1 ?? this.corner1;
    this.corner2 = corner2 ?? this.corner2;
    this.corner3 = corner3 ?? this.corner3;
    this.corner4 = corner4 ?? this.corner4;

    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  void updateFrom(RectangleBoolean rectangleBooleanOld) {
    val = rectangleBooleanOld.val;
    corner1 = rectangleBooleanOld.corner1;
    corner2 = rectangleBooleanOld.corner2;
    corner3 = rectangleBooleanOld.corner3;
    corner4 = rectangleBooleanOld.corner4;
    fillColorWhenValIsFalse = rectangleBooleanOld.fillColorWhenValIsFalse;
    fillColorWhenValIsTrue = rectangleBooleanOld.fillColorWhenValIsTrue;
  }

  static RectangleBoolean clone(RectangleBoolean rectangleBooleanOld) {
    return RectangleBoolean(
      val: rectangleBooleanOld.val,
      corner1: rectangleBooleanOld.corner1,
      corner2: rectangleBooleanOld.corner2,
      corner3: rectangleBooleanOld.corner3,
      corner4: rectangleBooleanOld.corner4,
      fillColorWhenValIsFalse: rectangleBooleanOld.fillColorWhenValIsFalse,
      fillColorWhenValIsTrue: rectangleBooleanOld.fillColorWhenValIsTrue,
    );
  }

  RectangleBoolean get copy => RectangleBoolean.clone(this);

  // Color get showColor => val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse;

  ({Color showColor}) get paintData {
    return (showColor: val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse);
  }

  PointBoolean get topLeft {
    return PointBoolean.getMostTopLeft(endPoints) ?? const PointBoolean.zero();
  }

  @override
  String toString() {
    return 'RectangleBoolean $corner1 $corner2 $corner3 $corner4';
  }

  void move(MoveParameters moveParameters) {
    updateProperties(
      corner1: corner1 + moveParameters.offsetAsAPoint,
      corner2: corner2 + moveParameters.offsetAsAPoint,
      corner3: corner3 + moveParameters.offsetAsAPoint,
      corner4: corner4 + moveParameters.offsetAsAPoint,
    );
  }

  void rotate(RotateParameters rotateParameters) {
    updateProperties(
      corner1: corner1.rotatedPoint(rotateParameters),
      corner2: corner2.rotatedPoint(rotateParameters),
      corner3: corner3.rotatedPoint(rotateParameters),
      corner4: corner4.rotatedPoint(rotateParameters),
    );

    // print('rotated rectangle is ${this}');
  }

  bool isInsideSelectRectangle(
    RectangularBoundary selectRectangle,
    double spaceBetweenPoints,
  ) {
    List<PointBoolean> rectanglePoints = [corner1];
    rectanglePoints.addAll(LineBoolean.getBoundaryPointsOfLine(
      point1: corner1,
      point2: corner2,
      gap: spaceBetweenPoints,
    ));
    rectanglePoints.add(corner2);

    rectanglePoints.addAll(LineBoolean.getBoundaryPointsOfLine(
      point1: corner2,
      point2: corner3,
      gap: spaceBetweenPoints,
    ));
    rectanglePoints.add(corner3);

    rectanglePoints.addAll(LineBoolean.getBoundaryPointsOfLine(
      point1: corner3,
      point2: corner4,
      gap: spaceBetweenPoints,
    ));
    rectanglePoints.add(corner4);

    rectanglePoints.addAll(LineBoolean.getBoundaryPointsOfLine(
      point1: corner4,
      point2: corner1,
      gap: spaceBetweenPoints,
    ));

    bool isAnyPointFoundInside = false;

    for (PointBoolean point in rectanglePoints) {
      isAnyPointFoundInside = point.isInsideBoundary(selectRectangle);
      if (isAnyPointFoundInside) {
        break;
      }
    }

    if (selectRectangle.corner1.isInsideBoundary(toRectangularBoundary())) {
      isAnyPointFoundInside = true;
    } else if (selectRectangle.corner2
        .isInsideBoundary(toRectangularBoundary())) {
      isAnyPointFoundInside = true;
    } else if (selectRectangle.corner3
        .isInsideBoundary(toRectangularBoundary())) {
      isAnyPointFoundInside = true;
    } else if (selectRectangle.corner4
        .isInsideBoundary(toRectangularBoundary())) {
      isAnyPointFoundInside = true;
    }

    return isAnyPointFoundInside;
  }

  bool get isDummy => PointBoolean.arePointsEqual([
        corner1,
        corner2,
        corner3,
        corner4,
      ]);

  List<PointBoolean> get endPoints {
    return <PointBoolean>[corner1, corner2, corner3, corner4];
  }

  List<PointBoolean> boundaryPoints({required double gap}) {
    // Map<double, List<PointBoolean>> pointsMap = {};
    List<PointBoolean> pointsList = [];

    for (PointBoolean point in LineBoolean.getBoundaryPointsOfLine(
      point1: corner1,
      point2: corner2,
      gap: gap,
    )) {
      // MethodsForElements.putSinglePointinPointsMap(
      //     point: point, pointsMap: pointsMap);
      pointsList.add(point);
    }

    for (PointBoolean point in LineBoolean.getBoundaryPointsOfLine(
      point1: corner2,
      point2: corner3,
      gap: gap,
    )) {
      // MethodsForElements.putSinglePointinPointsMap(
      //     point: point, pointsMap: pointsMap);
      pointsList.add(point);
    }

    for (PointBoolean point in LineBoolean.getBoundaryPointsOfLine(
      point1: corner3,
      point2: corner4,
      gap: gap,
    )) {
      // MethodsForElements.putSinglePointinPointsMap(
      //     point: point, pointsMap: pointsMap);
      pointsList.add(point);
    }

    for (PointBoolean point in LineBoolean.getBoundaryPointsOfLine(
      point1: corner4,
      point2: corner1,
      gap: gap,
    )) {
      // MethodsForElements.putSinglePointinPointsMap(
      //     point: point, pointsMap: pointsMap);
      pointsList.add(point);
    }
    return pointsList;
  }

  List<PointBoolean> get centrePoint {
    // Map<double, List<PointBoolean>> pointsMap = {};
    // MethodsForElements.putSinglePointinPointsMap(
    //     point: corner1.getCentreWith(corner3), pointsMap: pointsMap);
    // return pointsMap;
    return <PointBoolean>[corner1.getCentreWith(corner3)];
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

    return pointsList;
  }

  RectangularBoundary get getBoundary {
    var rectangularBoundary = RectangularBoundary.getBoundaryFromPoints(
            [corner1, corner2, corner3, corner4]) ??
        const RectangularBoundary.allCornersZero();
    return rectangularBoundary;
  }

  Map<String, Map<Property, dynamic>> get property => {
        'boolean value': {
          Property.propertyType: PropertyTypeOfElement.boolean,
          Property.value: val,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is false': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsFalse,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is true': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsTrue,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
      };

  void updateProperty(Map<String, Map<Property, dynamic>> propertyInput) {
    for (final property in propertyInput.keys) {
      switch (property) {
        case 'boolean value':
          val = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is false':
          fillColorWhenValIsFalse = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is true':
          fillColorWhenValIsTrue = propertyInput[property]![Property.value];
          break;
      }
    }
  }

  RectangleBoolean getCopyDueToScreenMoved(MoveScreen moveScreen) {
    RectangleBoolean temp = copy;
    final p1 = MoveScreen.getTransformedPoint(
        moveScreen: moveScreen, originalPoint: corner1);
    final p2 = MoveScreen.getTransformedPoint(
        moveScreen: moveScreen, originalPoint: corner2);
    final p3 = MoveScreen.getTransformedPoint(
        moveScreen: moveScreen, originalPoint: corner3);
    final p4 = MoveScreen.getTransformedPoint(
        moveScreen: moveScreen, originalPoint: corner4);

    temp.updateProperties(corner1: p1, corner2: p2, corner3: p3, corner4: p4);
    return temp;
  }

  void paint({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {
    var paint = Paint();
    var rectangle = getCopyDueToScreenMoved(moveScreen);

    // ignore: non_constant_identifier_names
    final PARAMETER_FOR_ROTATION = ParametersForRotatedElements(
      corner1: rectangle.corner1,
      corner2: rectangle.corner2,
      corner3: rectangle.corner3,
      corner4: rectangle.corner4,
    );

    paint.color = overrideColor ?? paintData.showColor;
    paint.color
        .withAlpha(paint.color.alpha * (percentageOpacity ?? 100) ~/ 100);

    if (PARAMETER_FOR_ROTATION.ANGLE_RADIANS == 0 ||
        PARAMETER_FOR_ROTATION.ANGLE_RADIANS == pi) {
      //painting if non-rotated
      canvas.drawRect(
        Rect.fromPoints(
          Offset(rectangle.corner1.x, rectangle.corner1.y),
          Offset(rectangle.corner3.x, rectangle.corner3.y),
        ),
        paint,
      );
    } else {
      PARAMETER_FOR_ROTATION.paintRotated(
        canvas: canvas,
        functionToPaint: canvas.drawRect,
        paint: paint,
        dataToBePainted: Rect.fromPoints(
          const Offset(0, 0),
          Offset(PARAMETER_FOR_ROTATION.WIDTH, PARAMETER_FOR_ROTATION.HEIGHT),
        ),
      );
    }
  }

  void paintUserMode({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {}

  static void editDialog_({
    required dynamic originalElement,
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    /* 
     * edit dialog gives map to a property map to a procedure
     * This procedure already has access to items being edited
     * copy of originalItem is kept
     * as per property tags screen dialog is generated
     * in editing mode, item on screen is edited
     * when OK is said, edited item is left as is
     * when Cancel is pressed, originalItem copy is moved to screenElements
     */
    EditOperationMethods.dialogBox_(
      itemBeingEdited: itemBeingEdited,
      DIALOG_BOX_CONFIG: DIALOG_BOX_CONFIG,
      originalElement: originalElement,
      RECALCULATE_CLICKABLE_COORDINATES:
          ClickableCoordinatesOperations.recalculateCoordinates,
      kwargs_recalculate_clickable_coordinates:
          kwargs_recalculate_clickable_coordinates,
    );
  }

  //Other methods which are defined only in RectangleBoolean class
  RectangularBoundary toRectangularBoundary() {
    return RectangularBoundary(corner1, corner2, corner3, corner4);
  }
}

class CircleBoolean {
  bool val = false;
  PointBoolean centre = const PointBoolean.zero();
  double radius = 0;

  Color fillColorWhenValIsFalse = const Color.fromARGB(255, 100, 100, 100);
  Color fillColorWhenValIsTrue = const Color.fromARGB(255, 255, 255, 0);

  late String _KEY;
  void assignKey(String KEY) {
    _KEY = KEY;
  }

  CircleBoolean({
    required this.val,
    required this.centre,
    required this.radius,
    required this.fillColorWhenValIsFalse,
    required this.fillColorWhenValIsTrue,
  });

  CircleBoolean.fromCentreRadius({
    bool? val,
    PointBoolean? centre,
    double? radius,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    this.centre = centre ?? this.centre;
    this.radius = radius ?? this.radius;
    this.val = val ?? this.val;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  CircleBoolean.fromCentrePoint({
    bool? val,
    required this.centre,
    required PointBoolean point,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    radius = centre.distanceFrom(point);
    this.val = val ?? this.val;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  CircleBoolean.fromOppositeCorners({
    bool? val,
    required PointBoolean diameterOneEnd,
    required PointBoolean diameterOtherEnd,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    centre = diameterOneEnd.getCentreWith(diameterOtherEnd);
    radius = centre.distanceFrom(diameterOneEnd);
    this.val = val ?? this.val;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  void updateProperties({
    bool? val,
    PointBoolean? centre,
    double? radius,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    this.val = val ?? this.val;
    this.centre = centre ?? this.centre;
    this.radius = radius ?? this.radius;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  void updateFrom(CircleBoolean other) {
    val = other.val;
    centre = other.centre;
    radius = other.radius;

    fillColorWhenValIsFalse = other.fillColorWhenValIsFalse;
    fillColorWhenValIsTrue = other.fillColorWhenValIsTrue;
  }

  static CircleBoolean clone(CircleBoolean other) {
    return CircleBoolean(
      val: other.val,
      centre: other.centre,
      radius: other.radius,
      fillColorWhenValIsFalse: other.fillColorWhenValIsFalse,
      fillColorWhenValIsTrue: other.fillColorWhenValIsTrue,
    );
  }

  CircleBoolean get copy => CircleBoolean.clone(this);

  // Color get showColor => val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse;

  ({Color showColor}) get paintData {
    return (showColor: val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse);
  }

  PointBoolean get topLeft {
    //top left of screen means bottom left of coordinate system
    final LEFT_POINT = centre - PointBoolean(radius, 0);
    final BOTTOM_POINT = centre - PointBoolean(0, radius);

    return PointBoolean.getMostTopLeft([LEFT_POINT, BOTTOM_POINT]) ??
        const PointBoolean.zero();
  }

  @override
  String toString() {
    return 'RectangleBoolean centre $centre  radius=$radius';
  }

  void move(MoveParameters moveParameters) {
    updateProperties(
      centre: centre + moveParameters.offsetAsAPoint,
    );
  }

  void rotate(RotateParameters rotateParameters) {
    updateProperties(
      centre: centre.rotatedPoint(rotateParameters),
    );
  }

  bool isInsideSelectRectangle(
    RectangularBoundary selectRectangle,
    double spaceBetweenPoints,
  ) {
    final ANTICLOCKWISE_LOCUS = boundaryPoints(gap: spaceBetweenPoints);

    for (final BOUNDARY_POINT in ANTICLOCKWISE_LOCUS) {
      if (BOUNDARY_POINT.isInsideBoundary(selectRectangle)) {
        return true;
      }
    }

    for (final POINT_OF_SELECT_RECTANGLE in selectRectangle.asList()) {
      if (Vector.doesPointLieInsideAnticlockwiseLocusOfPoints(
        POINT: POINT_OF_SELECT_RECTANGLE,
        ANTICLOCKWISE_LOCUS: ANTICLOCKWISE_LOCUS,
      )) {
        return true;
      }
    }
    return false;
  }

  List<PointBoolean> get endPoints {
    return <PointBoolean>[
      PointBoolean(centre.x + radius, centre.y),
      PointBoolean(centre.x, centre.y + radius),
      PointBoolean(centre.x - radius, centre.y),
      PointBoolean(centre.x, centre.y - radius),
    ];
  }

  List<PointBoolean> boundaryPoints({required double gap}) {
    PointBoolean locusOfCircleFrom({
      required PointBoolean CENTRE,
      required double RADIUS,
      required double ANGLE_RADIANS,
    }) {
      final X = RADIUS * cos(ANGLE_RADIANS);
      final Y = RADIUS * sin(ANGLE_RADIANS);
      return PointBoolean(X, Y) + CENTRE;
    }

    List<PointBoolean> pointsList = [];

    final double ANGLE_STEP = gap / radius;

    for (double angle_radians = 0;
        angle_radians < 2 * pi;
        angle_radians += ANGLE_STEP) {
      pointsList.add(locusOfCircleFrom(
        CENTRE: centre,
        RADIUS: radius,
        ANGLE_RADIANS: angle_radians,
      ));
    }

    return pointsList;
  }

  List<PointBoolean> get centrePoint {
    return <PointBoolean>[centre.copy];
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

    print('snap points of circle: $pointsList');
    return pointsList;
  }

  RectangularBoundary get getBoundary {
    final BOTTOM_LEFT_POINT = centre + PointBoolean(-radius, -radius);
    final TOP_RIGHT_POINT = centre + PointBoolean(radius, radius);

    final RECTANGULAR_BOUNDARY = RectangularBoundary.getBoundaryFromPoints(
          [BOTTOM_LEFT_POINT, TOP_RIGHT_POINT],
        ) ??
        const RectangularBoundary.allCornersZero();

    return RECTANGULAR_BOUNDARY;
  }

  Map<String, Map<Property, dynamic>> get property => {
        'boolean value': {
          Property.propertyType: PropertyTypeOfElement.boolean,
          Property.value: val,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is false': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsFalse,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is true': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsTrue,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
      };

  void updateProperty(Map<String, Map<Property, dynamic>> propertyInput) {
    for (final property in propertyInput.keys) {
      switch (property) {
        case 'boolean value':
          val = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is false':
          fillColorWhenValIsFalse = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is true':
          fillColorWhenValIsTrue = propertyInput[property]![Property.value];
          break;
      }
    }
  }

  CircleBoolean getCopyDueToScreenMoved(MoveScreen moveScreen) {
    CircleBoolean temp = copy;
    final NEW_CENTRE = MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: temp.centre,
    );

    final DIAMETER_RIGHT_MOST_POINT = MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: temp.centre + PointBoolean(temp.radius, 0),
    );

    final NEW_RADIUS = DIAMETER_RIGHT_MOST_POINT.distanceFrom(NEW_CENTRE);

    temp.updateProperties(centre: NEW_CENTRE, radius: NEW_RADIUS);
    return temp;
  }

  void paint({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {
    var paint = Paint();
    final CIRCLE_AFTER_SCALING = getCopyDueToScreenMoved(moveScreen);

    paint.color = overrideColor ?? paintData.showColor;
    paint.color
        .withAlpha(paint.color.alpha * (percentageOpacity ?? 100) ~/ 100);

    canvas.drawCircle(
      Offset(
        CIRCLE_AFTER_SCALING.centre.x,
        CIRCLE_AFTER_SCALING.centre.y,
      ),
      CIRCLE_AFTER_SCALING.radius,
      paint,
    );
    // print('Circle paint color = ${paint.color}');
  }

  void paintUserMode({
    required Canvas canvas,
    required MoveScreen moveScreen,
    Color? overrideColor,
    int? percentageOpacity,
  }) {}

  static void editDialog_({
    required dynamic originalElement,
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    /* 
     * edit dialog gives map to a property map to a procedure
     * This procedure already has access to items being edited
     * copy of originalItem is kept
     * as per property tags screen dialog is generated
     * in editing mode, item on screen is edited
     * when OK is said, edited item is left as is
     * when Cancel is pressed, originalItem copy is moved to screenElements
     */
    EditOperationMethods.dialogBox_(
      itemBeingEdited: itemBeingEdited,
      DIALOG_BOX_CONFIG: DIALOG_BOX_CONFIG,
      originalElement: originalElement,
      RECALCULATE_CLICKABLE_COORDINATES:
          ClickableCoordinatesOperations.recalculateCoordinates,
      kwargs_recalculate_clickable_coordinates:
          kwargs_recalculate_clickable_coordinates,
    );
  }
  //Other methods specific to this class only
}

///Fields:
///- val (bool)
///- textFalse (bool)
///- fillColorWhenValueIsFalse (Color)
///- textTrue (String)
///- fillColorWhenValueIsTrue (Color)
///- fontSize (double)
///- pivotPoint (PointBoolean)
///- angleRadians (double)
class TextBoolean {
  static double MINIMUM_FONT_SIZE = 15.0;
  bool val = false;
  String textFalse = ' ';
  String textTrue = ' ';
  double fontSize = 20;
  PointBoolean pivotPoint = const PointBoolean.zero();
  double angleRadians = 0;
  Color fillColorWhenValIsFalse = const Color.fromARGB(255, 150, 150, 150);
  Color fillColorWhenValIsTrue = const Color.fromARGB(255, 255, 255, 0);

  late String _KEY;
  void assignKey(String KEY) {
    _KEY = KEY;
  }

  TextBoolean({
    bool? val,
    required this.pivotPoint,
    required this.textFalse,
    required this.textTrue,
    double? angleRadians,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
    double? fontSize,
  }) {
    this.val = val ?? this.val;
    this.angleRadians = angleRadians ?? this.angleRadians;
    this.fontSize = fontSize ?? this.fontSize;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  void updateProperties({
    bool? val,
    PointBoolean? pivotPoint,
    double? angleRadians,
    String? textFalse,
    String? textTrue,
    double? fontSize,
    Color? fillColorWhenValIsFalse,
    Color? fillColorWhenValIsTrue,
  }) {
    this.val = val ?? this.val;
    this.pivotPoint = pivotPoint ?? this.pivotPoint;
    this.angleRadians = angleRadians ?? this.angleRadians;
    this.textFalse = textFalse ?? this.textFalse;
    this.textTrue = textTrue ?? this.textTrue;
    this.fontSize = fontSize ?? this.fontSize;
    this.fillColorWhenValIsFalse =
        fillColorWhenValIsFalse ?? this.fillColorWhenValIsFalse;
    this.fillColorWhenValIsTrue =
        fillColorWhenValIsTrue ?? this.fillColorWhenValIsTrue;
  }

  void updateFrom(TextBoolean other) {
    val = other.val;
    pivotPoint = other.pivotPoint;
    angleRadians = other.angleRadians;
    textFalse = other.textFalse;
    textTrue = other.textTrue;
    fontSize = other.fontSize;
    fillColorWhenValIsFalse = other.fillColorWhenValIsFalse;
    fillColorWhenValIsTrue = other.fillColorWhenValIsTrue;
  }

  static TextBoolean clone(TextBoolean other) {
    return TextBoolean(
      val: other.val,
      pivotPoint: other.pivotPoint,
      angleRadians: other.angleRadians,
      textFalse: other.textFalse,
      textTrue: other.textTrue,
      fontSize: other.fontSize,
      fillColorWhenValIsFalse: other.fillColorWhenValIsFalse,
      fillColorWhenValIsTrue: other.fillColorWhenValIsTrue,
    );
  }

  TextBoolean get copy => TextBoolean.clone(this);

  // Color get showColor => val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse;

  ({Color showColor}) get paintData {
    return (showColor: val ? fillColorWhenValIsTrue : fillColorWhenValIsFalse);
  }

  @override
  String toString() {
    return 'TextBoolean{pivotPoint:$pivotPoint,textFalse:$textFalse, textTrue:$textTrue}';
  }

  void move(MoveParameters moveParameters) {
    updateProperties(
      pivotPoint: pivotPoint + moveParameters.offsetAsAPoint,
    );
  }

  void rotate(RotateParameters rotateParameters) {
    var NEW_PARAMETERS = Rotation.getRotated(
      PIVOT_POINT_EXISTING: pivotPoint,
      ANGLE_RADIAN_EXISTING: angleRadians,
      ROTATE_PARAMETERS: rotateParameters,
    );

    updateProperties(
      pivotPoint: NEW_PARAMETERS.pivotPoint,
      angleRadians: NEW_PARAMETERS.angleRadian,
    );
  }

  ///gets point which is extreme top left of this figure
  PointBoolean get topLeft {
    return PointBoolean.getMostTopLeft(corners) ?? const PointBoolean.zero();
  }

  ///tells true or false whether TextBoolean is inside selectRectangle
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

    print('snap points of text: $pointsList');
    return pointsList;
  }

  RectangularBoundary get getBoundary {
    return RectangularBoundary.getBoundaryFromPoints(corners) ??
        const RectangularBoundary.allCornersZero();
  }

  Map<String, Map<Property, dynamic>> get property => {
        'boolean value': {
          Property.propertyType: PropertyTypeOfElement.boolean,
          Property.value: val,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is false': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsFalse,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
        'fill color when value is true': {
          Property.propertyType: PropertyTypeOfElement.color,
          Property.value: fillColorWhenValIsTrue,
          Property.lowerConstraint: null,
          Property.upperConstraint: null,
        },
      };

  void updateProperty(Map<String, Map<Property, dynamic>> propertyInput) {
    for (final property in propertyInput.keys) {
      switch (property) {
        case 'boolean value':
          val = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is false':
          fillColorWhenValIsFalse = propertyInput[property]![Property.value];
          break;
        case 'fill color when value is true':
          fillColorWhenValIsTrue = propertyInput[property]![Property.value];
          break;
      }
    }
  }

  TextBoolean getCopyDueToScreenMoved(MoveScreen moveScreen) {
    TextBoolean temp = copy;

    //translation
    final NEW_PIVOT_POINT = MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: temp.pivotPoint,
    );

    //scaling
    final NEW_FONT_SIZE = fontSize * moveScreen.scale;

    temp.updateProperties(pivotPoint: NEW_PIVOT_POINT, fontSize: NEW_FONT_SIZE);
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

    if (TEXT_WHEN_SCREEN_MOVED.showText == ' ') {
      final textSpan = TextSpan(
        text: TEXT_WHEN_SCREEN_MOVED.showText,
        style: TextStyle(
          fontSize: TEXT_WHEN_SCREEN_MOVED.fontSize,
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
      var ORIGINAL_COLOR =
          overrideColor ?? TEXT_WHEN_SCREEN_MOVED.paintData.showColor;

      var color = Color.fromARGB(
        ORIGINAL_COLOR.alpha,
        ORIGINAL_COLOR.red,
        ORIGINAL_COLOR.green,
        ORIGINAL_COLOR.blue,
      );
      color = color.withAlpha(color.alpha * (percentageOpacity ?? 100) ~/ 100);

      final textSpan = TextSpan(
        text: TEXT_WHEN_SCREEN_MOVED.showText,
        style: TextStyle(
          color: color,
          fontSize: TEXT_WHEN_SCREEN_MOVED.fontSize,
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

  static void editDialog_({
    required dynamic originalElement,
    required ItemBeingEdited itemBeingEdited,
    required DialogBoxConfiguration DIALOG_BOX_CONFIG,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    /* 
     * edit dialog gives map to a property map to a procedure
     * This procedure already has access to items being edited
     * copy of originalItem is kept
     * as per property tags screen dialog is generated
     * in editing mode, item on screen is edited
     * when OK is said, edited item is left as is
     * when Cancel is pressed, originalItem copy is moved to screenElements
     */
    EditOperationMethods.dialogBox_(
      itemBeingEdited: itemBeingEdited,
      DIALOG_BOX_CONFIG: DIALOG_BOX_CONFIG,
      originalElement: originalElement,
      RECALCULATE_CLICKABLE_COORDINATES:
          ClickableCoordinatesOperations.recalculateCoordinates,
      kwargs_recalculate_clickable_coordinates:
          kwargs_recalculate_clickable_coordinates,
    );
  }

  //Other methods specific to this class only
  String get showText => val ? textTrue : textFalse;

  void increaseFontSizeBy(double size) {
    fontSize += size;
  }

  void decreaseFontSizeBy(double size) {
    fontSize -= size;
  }

  List<PointBoolean> get corners {
    final textSpan = TextSpan(
      text: showText,
      style: TextStyle(
        fontSize: fontSize,
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
}

///Fields
///-
class MultiTextBoolean {
  late PointBoolean pivotPoint;
  double angleRadians = 0;
  Map<int, RecordMultiText> records = {
    1: RecordMultiText(
      booleanValue: false,
      text: ' ',
      fontSize: 20,
      colorBackGround: const Color.fromARGB(255, 150, 150, 150),
      colorForeGround: const Color.fromARGB(255, 255, 255, 0),
    ),
    2: RecordMultiText(
      booleanValue: false,
      text: ' ',
      fontSize: 20,
      colorBackGround: const Color.fromARGB(255, 150, 150, 150),
      colorForeGround: const Color.fromARGB(255, 255, 255, 0),
    ),
  };

  // Map<int,dynamic> = {
  //   1 :(angleRadians:10),
  // };

  // Map<int, bool> valMap = {
  //   1: false,
  //   2: false,
  // };
  // Map<int, String> textMap = {
  //   1: ' ',
  //   2: ' ',
  // };
  // Map<int, double> fontSizeMap = {
  //   1: 20,
  //   2: 20,
  // };
  // Map<int, Color> fillColorWhenValIsFalseMap = {
  //   1: const Color.fromARGB(255, 150, 150, 150),
  //   2: const Color.fromARGB(255, 150, 150, 150),
  // };
  // Map<int, Color> fillColorWhenValIsTrueMap = {
  //   1: const Color.fromARGB(255, 255, 255, 0),
  //   2: const Color.fromARGB(255, 255, 255, 0),
  // };

  late String _KEY;
  void assignKey(String KEY) {
    _KEY = KEY;
  }

  MultiTextBoolean({
    required this.pivotPoint,
    // required this.textMap,
    // required this.records,
    double? angleRadians,
    Map<int, RecordMultiText>? records,
    // Map<int, bool>? valMap,
    // Map<int, Color>? fillColorWhenValIsFalseMap,
    // Map<int, Color>? fillColorWhenValIsTrueMap,
    // Map<int, double>? fontSizeMap,
  }) {
    this.angleRadians = angleRadians ?? this.angleRadians;
    this.records = records ?? this.records;
  }

  void updateProperties({
    PointBoolean? pivotPoint,
    double? angleRadians,
    Map<int, RecordMultiText>? singleRecord,
    Map<int, RecordMultiText>? completeRecord,
  }) {
    this.pivotPoint = pivotPoint ?? this.pivotPoint;
    this.angleRadians = angleRadians ?? this.angleRadians;

    if (singleRecord != null) {
      if (singleRecord.isNotEmpty) {
        final int KEY = singleRecord.keys.first;
        if (Set.from(records.keys).contains(KEY)) {
          records[KEY] = singleRecord ?? {}[KEY];
        }
      }
    }

    if (completeRecord != null) {
      records = completeRecord;
    }
  }

  void updateByIndex(int INDEX, bool VALUE) {
    try {
      RecordMultiText recordMultiText = records.values.elementAt(INDEX);
      recordMultiText.booleanValue = VALUE;
    } catch (e, f) {
      throw Exception('$e\n$f');
    }
  }

  void updateFrom(MultiTextBoolean other) {
    // valMap = other.valMap;
    pivotPoint = other.pivotPoint;
    angleRadians = other.angleRadians;

    Map<int, RecordMultiText> newRecordMap = {};

    for (int integerKey in other.records.keys) {
      newRecordMap[integerKey] = other.records[integerKey]!.copy;
    }

    records = newRecordMap;
    // textMap = other.textMap;
    // fontSizeMap = other.fontSizeMap;
    // fillColorWhenValIsFalseMap = other.fillColorWhenValIsFalseMap;
    // fillColorWhenValIsTrueMap = other.fillColorWhenValIsTrueMap;
  }

  static MultiTextBoolean clone(MultiTextBoolean other) {
    Map<int, RecordMultiText> newRecordMap = {};

    for (int integerKey in other.records.keys) {
      newRecordMap[integerKey] = other.records[integerKey]!.copy;
    }

    return MultiTextBoolean(
      // valMap: other.valMap,
      pivotPoint: other.pivotPoint,
      angleRadians: other.angleRadians,
      records: newRecordMap,
      // textMap: other.textMap,
      // fontSizeMap: other.fontSizeMap,
      // fillColorWhenValIsFalseMap: other.fillColorWhenValIsFalseMap,
      // fillColorWhenValIsTrueMap: other.fillColorWhenValIsTrueMap,
    );
  }

  void updateSingleRecordValue(dynamic key, bool value) {
    records[key]!.booleanValue = value;
  }

  MultiTextBoolean get copy => MultiTextBoolean.clone(this);

  // Color get showColor  is not defined.
  // Instead get paintData is defined, which includes showColor

  @override
  String toString() {
    return '''TextBoolean {
  pivotPoint : $pivotPoint,
  angleRadian : $angleRadians,
  records : $records,
}''';
  }

  void move(MoveParameters moveParameters) {
    updateProperties(
      pivotPoint: pivotPoint + moveParameters.offsetAsAPoint,
    );
  }

  void rotate(RotateParameters rotateParameters) {
    var NEW_PARAMETERS = Rotation.getRotated(
      PIVOT_POINT_EXISTING: pivotPoint,
      ANGLE_RADIAN_EXISTING: angleRadians,
      ROTATE_PARAMETERS: rotateParameters,
    );

    updateProperties(
      pivotPoint: NEW_PARAMETERS.pivotPoint,
      angleRadians: NEW_PARAMETERS.angleRadian,
    );
  }

  ///gets point which is extreme top left of this figure
  PointBoolean get topLeft {
    return PointBoolean.getMostTopLeft(corners) ?? const PointBoolean.zero();
  }

  ///tells true or false whether TextBoolean is inside selectRectangle
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

  // Map<String, Map<Property, dynamic>> get property {
  //   Map<String, Map<Property, dynamic>> propertyMap = {};
  //   for (int i in records.keys) {
  //     propertyMap.addAll({
  //       'text': {
  //         Property.propertyType: PropertyTypeOfElement.string,
  //         Property.value: textMap[i],
  //         Property.lowerConstraint: 0,
  //         Property.upperConstraint: null,
  //         Property.integerKey: i,
  //       },
  //       'boolean value': {
  //         Property.propertyType: PropertyTypeOfElement.boolean,
  //         Property.value: valMap[i],
  //         Property.lowerConstraint: null,
  //         Property.upperConstraint: null,
  //         Property.integerKey: i,
  //       },
  //       'fill color when value is false': {
  //         Property.propertyType: PropertyTypeOfElement.color,
  //         Property.value: fillColorWhenValIsFalseMap[i],
  //         Property.lowerConstraint: null,
  //         Property.upperConstraint: null,
  //         Property.integerKey: i,
  //       },
  //       'fill color when value is true': {
  //         Property.propertyType: PropertyTypeOfElement.color,
  //         Property.value: fillColorWhenValIsTrueMap[i],
  //         Property.lowerConstraint: null,
  //         Property.upperConstraint: null,
  //         Property.integerKey: i,
  //       },
  //       'font size': {
  //         Property.propertyType: PropertyTypeOfElement.fontSize,
  //         Property.value: fillColorWhenValIsTrueMap[i],
  //         Property.lowerConstraint: 6,
  //         Property.upperConstraint: null,
  //         Property.integerKey: i,
  //       }
  //     });
  //   }
  //   return propertyMap;
  // }

  Map<int, Map<String, Map<Property, dynamic>>> get propertyMap {
    Map<int, Map<String, Map<Property, dynamic>>> m = {};
    for (int i in records.keys) {
      m.addAll({
        i: {
          'text': {
            Property.propertyType: PropertyTypeOfElement.string,
            Property.value: records[i]!.text,
            Property.lowerConstraint: 0,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'boolean value': {
            Property.propertyType: PropertyTypeOfElement.boolean,
            Property.value: records[i]!.booleanValue,
            Property.lowerConstraint: null,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'text color': {
            Property.propertyType: PropertyTypeOfElement.color,
            Property.value: records[i]!.colorForeGround,
            Property.lowerConstraint: null,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'background color': {
            Property.propertyType: PropertyTypeOfElement.color,
            Property.value: records[i]!.colorBackGround,
            Property.lowerConstraint: null,
            Property.upperConstraint: null,
            // Property.integerKey: i,
          },
          'font size': {
            Property.propertyType: PropertyTypeOfElement.fontSize,
            Property.value: records[i]!.fontSize,
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
      Map<int, Map<String, Map<Property, dynamic>>> propertyMap) {
    Set<int> EXISITING_KEYS = Set.from(records.keys);

    for (final keyFound in propertyMap.keys) {
      if (EXISITING_KEYS.contains(keyFound)) {
        var propertyInput = propertyMap[keyFound];
        for (final propertyString in propertyInput!.keys) {
          switch (propertyString) {
            case 'text':
              records[keyFound]!.text =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'boolean value':
              records[keyFound]!.booleanValue =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'text color':
              records[keyFound]!.colorForeGround =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'background color':
              records[keyFound]!.colorBackGround =
                  propertyInput[propertyString]![Property.value];
              break;
            case 'font size':
              records[keyFound]!.fontSize =
                  propertyInput[propertyString]![Property.value];
              break;
          }
        }
      }
    }
  }

  MultiTextBoolean getCopyDueToScreenMoved(MoveScreen moveScreen) {
    MultiTextBoolean temp = copy;

    //translation
    final NEW_PIVOT_POINT = MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: temp.pivotPoint,
    );

    final PAINT_DATA = paintData;
    //scaling
    // final NEW_FONT_SIZE = PAINT_DATA.showFontSize * moveScreen.scale;

    temp.updateProperties(pivotPoint: NEW_PIVOT_POINT);

    for (final integerKey in temp.records.keys) {
      temp.records[integerKey]!.fontSize *= moveScreen.scale;
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

  ({
    String showText,
    Color showColor,
    Color showbgColor,
    double showFontSize,
  }) get paintData {
    Color BLANK_COLOR = Colors.yellowAccent;
    Color ERROR_COLOR = Colors.red;
    Color BLANK_BG = const Color.fromARGB(50, 255, 255, 255);
    Color ERROR_BG = Colors.transparent;
    double BLANK_FONT_SIZE = 20.0;
    double ERROR_FONT_SIZE = 20.0;
    String BLANK_TEXT = ' ';
    String ERROR_TEXT = 'Error Text';

    int countTrueFound = 0;
    int keyTrueFound = -1;
    for (int i in records.keys) {
      if (records[i]!.booleanValue == true) {
        countTrueFound += 1;
        keyTrueFound = i;
      }
    }
    if (countTrueFound == 0) {
      return (
        showText: BLANK_TEXT,
        showbgColor: BLANK_BG,
        showColor: BLANK_COLOR,
        showFontSize: BLANK_FONT_SIZE,
      );
    } else if (countTrueFound == 1) {
      return (
        showText: records[keyTrueFound]!.text,
        showColor: records[keyTrueFound]!.colorForeGround,
        showFontSize: records[keyTrueFound]!.fontSize,
        showbgColor: records[keyTrueFound]!.colorBackGround
      );
    } else {
      return (
        showText: ERROR_TEXT,
        showColor: ERROR_COLOR,
        showbgColor: ERROR_BG,
        showFontSize: ERROR_FONT_SIZE,
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

  void addRecordEntry() {
    RecordMultiText newRecordEntry = RecordMultiText.withDefaultValues();
    final Set<int> EXISTING_KEYS = Set.from(records.keys);
    final int LARGEST_NUMBER = EXISTING_KEYS
        .reduce((value, element) => element > value ? element : value);
    final int NEW_KEY = LARGEST_NUMBER + 1;

    records[NEW_KEY] = newRecordEntry;
  }

  void deleteRecordEntry(int key) {
    if (records.length > 2) {
      records.remove(key);
    }
  }
}

class ParametersForRotatedElements {
  late final PointBoolean PIVOT;
  late final double ANGLE_RADIANS;
  late final double WIDTH;
  late final double HEIGHT;

  ParametersForRotatedElements({
    required PointBoolean corner1,
    required PointBoolean corner2,
    required PointBoolean corner3,
    required PointBoolean corner4,
  }) {
    PIVOT = corner1.copy;
    final ANGLE = atan((corner4.y - corner1.y) / (corner4.x - corner1.x));

    ANGLE_RADIANS = corner4.x < corner1.x ? ANGLE + pi : ANGLE;

    WIDTH = corner1.distanceFrom(corner4);
    HEIGHT = corner1.distanceFrom(corner2);
  }

  void paintRotated({
    required Canvas canvas,
    required Function functionToPaint,
    required Paint paint,
    required dataToBePainted,
  }) {
    canvas.save();

    canvas.translate(PIVOT.x, PIVOT.y);

    canvas.rotate(ANGLE_RADIANS);

    functionToPaint(dataToBePainted, paint);

    canvas.restore();
  }

  @override
  String toString() {
    return 'Parameters: pivot $PIVOT, angle $ANGLE_RADIANS, width $WIDTH, height $HEIGHT';
  }
}

class Vector {
  late final double i;
  late final double j;
  late final double k;

  Vector({this.i = 0, this.j = 0, this.k = 0});

  Vector.from({required PointBoolean from, required PointBoolean to}) {
    i = to.x - from.x;
    j = to.y - from.y;
    k = 0;
  }

  double get magnitude => sqrt(i * i + j * j + k * k);

  double dotProductWith(Vector other) =>
      i * other.i + j * other.j + k * other.k;

  static double dotProduct(Vector v1, Vector v2) =>
      v1.i * v2.i + v1.j * v2.j + v1.k * v2.k;

  double angleInRadiansWith(Vector other) =>
      acos(dotProductWith(other) / (magnitude * other.magnitude));

  static double angleInRadians(Vector v1, Vector v2) =>
      acos(Vector.dotProduct(v1, v2) / (v1.magnitude * v2.magnitude));

  double angleInDegreesWith(Vector other) =>
      180 / pi * angleInRadiansWith(other);

  static double angleInDegrees(Vector v1, Vector v2) =>
      180 / pi * angleInRadians(v1, v2);

  Vector crossProductWith(Vector other) => crossProduct(this, other);

  static Vector crossProduct(Vector v1, Vector v2) {
    return Vector(
      i: v1.j * v2.k - v2.j * v1.k,
      j: -1 * (v1.i * v2.k - v2.i * v1.k),
      k: v1.i * v2.j - v2.i * v1.j,
    );
  }

  static bool doesPointLieInsideAnticlockwiseLocusOfPoints({
    required PointBoolean POINT,
    required List<PointBoolean> ANTICLOCKWISE_LOCUS,
  }) {
    for (int i = 0; i < ANTICLOCKWISE_LOCUS.length - 1; ++i) {
      var v1 = Vector.from(
        from: ANTICLOCKWISE_LOCUS[i],
        to: ANTICLOCKWISE_LOCUS[i + 1],
      );
      var v2 = Vector.from(
        from: ANTICLOCKWISE_LOCUS[i],
        to: POINT,
      );
      if (Vector.crossProduct(v1, v2).k < 0) {
        return false;
      }
    }
    return true;
  }

  static bool doesAnticlockwiseLocusOverlapSelectRectangle({
    required List<PointBoolean> ANTICLOCKWISE_LOCUS,
    required RectangularBoundary SELECT_RECTANGLE,
  }) {
    for (final BOUNDARY_POINT in ANTICLOCKWISE_LOCUS) {
      if (BOUNDARY_POINT.isInsideBoundary(SELECT_RECTANGLE)) {
        return true;
      }
    }
    for (final POINT_OF_SELECT_RECTANGLE in SELECT_RECTANGLE.asList()) {
      if (Vector.doesPointLieInsideAnticlockwiseLocusOfPoints(
        POINT: POINT_OF_SELECT_RECTANGLE,
        ANTICLOCKWISE_LOCUS: ANTICLOCKWISE_LOCUS,
      )) {
        return true;
      }
    }
    return false;
  }
}

class Rotation {
  static ({PointBoolean pivotPoint, double angleRadian}) getRotated({
    required PointBoolean PIVOT_POINT_EXISTING,
    required double ANGLE_RADIAN_EXISTING,
    required RotateParameters ROTATE_PARAMETERS,
  }) {
    // x = r cos @
    // y = r sin @
    var BASE_LENGTH = 10.0;
    final BASE_POINT = PointBoolean(
          BASE_LENGTH * cos(ANGLE_RADIAN_EXISTING),
          BASE_LENGTH * sin(ANGLE_RADIAN_EXISTING),
        ) +
        PIVOT_POINT_EXISTING;

    final PIVOT_POINT_NEW =
        PIVOT_POINT_EXISTING.rotatedPoint(ROTATE_PARAMETERS);
    final BASE_POINT_NEW = BASE_POINT.rotatedPoint(ROTATE_PARAMETERS);
    final ANGLE_RADIANS_NEW = (BASE_POINT_NEW - PIVOT_POINT_NEW).getAngleWithX;

    return (pivotPoint: PIVOT_POINT_NEW, angleRadian: ANGLE_RADIANS_NEW);
  }
}
