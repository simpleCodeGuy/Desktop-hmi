import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/methods/input_methods.dart';
import 'package:simple_hmi/methods/user_interface_methods.dart';
import 'package:simple_hmi/widgets/editor_mode_1_screen_canvas_methods.dart';
import '/widgets/editor_mode_1_screen2.dart';
import '/data/app_data.dart';
import '/data/configuration.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '/classes/logic_part.dart';
import '/classes/enumerations.dart';

BuildContext contextForWindowSizeProvider = contextForWindowSizeProvider;

extension SignOf on double {
  double get sign => this >= 0 ? 1 : -1;
}

class PointBoolean {
  final double x;
  final double y;
  const PointBoolean(this.x, this.y);

  const PointBoolean.zero()
      : x = 0,
        y = 0;

  @override
  String toString() => '($x,$y)';

  PointBoolean get copy => PointBoolean(x, y);

  PointBoolean operator +(PointBoolean other) =>
      PointBoolean(x + other.x, y + other.y);

  PointBoolean operator -(PointBoolean other) =>
      PointBoolean(x - other.x, y - other.y);

  PointBoolean operator /(double number) =>
      PointBoolean(x / number, y / number);

  PointBoolean operator *(double number) =>
      PointBoolean(x * number, y * number);

  bool isEqualTo(PointBoolean other) => (x == other.x) && (y == other.y);

  bool isNotEqualTo(PointBoolean other) => !isEqualTo(other);

  static bool arePointsEqual(List<PointBoolean> pointList) {
    bool arePointsEqual = true;
    for (int i = 1; i < pointList.length; ++i) {
      if (pointList[i - 1].isNotEqualTo(pointList[i])) {
        arePointsEqual = false;
        break;
      }
    }
    return arePointsEqual;
  }

  double distanceFrom(PointBoolean other) =>
      sqrt(pow(other.x - x, 2) + pow(other.y - y, 2));

  PointBoolean rotatedPoint(RotateParameters rotateParameters) {
    if (rotateParameters.radians == 0) {
      return PointBoolean(x, y);
    } else {
      // print(rotateParameters.degrees);
      double xOld = x, yOld = y;
      double xCentre = rotateParameters.centre.x,
          yCentre = rotateParameters.centre.y;

      double xNew;
      double yNew;

      double theta = -rotateParameters.radians;

      //P <- P - Pcentre
      xOld = xOld - xCentre;
      yOld = yOld - yCentre;

      //rotating Point around origin
      xNew = xOld * cos(theta) + yOld * sin(theta);
      yNew = -xOld * sin(theta) + yOld * cos(theta);

      //Pnew <- Pnew + Pcentre
      xNew = xNew + xCentre;
      yNew = yNew + yCentre;

      return PointBoolean(xNew, yNew);
    }
  }

  bool isInsideBoundary(RectangularBoundary rectangularBoundary) =>
      x >= rectangularBoundary.xMinimum &&
      x <= rectangularBoundary.xMaximum &&
      y >= rectangularBoundary.yMinimum &&
      y <= rectangularBoundary.yMaximum;

  bool isOutsideBoundary(RectangularBoundary rectangularBoundary) =>
      !isInsideBoundary(rectangularBoundary);

  PointBoolean getNewPointInDirectionOfGivenPoint(
      {required PointBoolean other, required double gap}) {
    final slopeXY = other - this;
    double theta = atan(slopeXY.y / slopeXY.x);

    if ((other.y > y && other.x < x) || (other.y <= y && other.x < x)) {
      theta += pi;
    }

    final offsetPoint = PointBoolean(gap * cos(theta), gap * sin(theta));

    return this + offsetPoint;
  }

  static List<PointBoolean> getPointsBetween(
      {required PointBoolean POINT1,
      required PointBoolean POINT2,
      required double GAP}) {
    List<PointBoolean> points = [];
    final STEPS = POINT1.distanceFrom(POINT2) ~/ GAP;
    for (int i = 1; i <= STEPS; ++i) {
      points.add(
        POINT1.getNewPointInDirectionOfGivenPoint(other: POINT2, gap: GAP * i),
      );
    }
    return points;
  }

  static List<PointBoolean> boundariesFromCorners(
      List<PointBoolean> CORNERS, double GAP) {
    List<PointBoolean> boundaries = [];

    for (int i = 1; i < CORNERS.length; ++i) {
      boundaries.addAll(getPointsBetween(
          POINT1: CORNERS[i - 1], POINT2: CORNERS[i], GAP: GAP));
    }

    if (CORNERS.length > 2) {
      boundaries.addAll(getPointsBetween(
          POINT1: CORNERS[CORNERS.length - 1], POINT2: CORNERS[0], GAP: GAP));
    }

    return boundaries;
  }

  static List<PointBoolean> locusFromCorners({
    required List<PointBoolean> ANTICLOCKWISE_CORNERS,
    required double GAP,
  }) {
    List<PointBoolean> locus = [];

    for (int i = 1; i < ANTICLOCKWISE_CORNERS.length; ++i) {
      locus.addAll(getPointsBetween(
        POINT1: ANTICLOCKWISE_CORNERS[i - 1],
        POINT2: ANTICLOCKWISE_CORNERS[i],
        GAP: GAP,
      ));
      locus.add(ANTICLOCKWISE_CORNERS[i]);
    }

    if (ANTICLOCKWISE_CORNERS.length > 2) {
      locus.addAll(getPointsBetween(
        POINT1: ANTICLOCKWISE_CORNERS[ANTICLOCKWISE_CORNERS.length - 1],
        POINT2: ANTICLOCKWISE_CORNERS[0],
        GAP: GAP,
      ));
      locus.add(ANTICLOCKWISE_CORNERS[0]);
    }

    return locus;
  }

  PointBoolean getCentreWith(PointBoolean other) {
    return PointBoolean((x + other.x) / 2, (y + other.y) / 2);
  }

  double getClosestFloorValueAsPerSnapPrecision(double snapPrecision) {
    return (x ~/ snapPrecision).toDouble() * snapPrecision;
  }

  PointBoolean getTransformedPoint(MoveScreen moveScreen) {
    return MoveScreen.getTransformedPoint(
      moveScreen: moveScreen,
      originalPoint: this,
    );
  }

  PointBoolean getTransformedBoundaryPoint(MoveScreen moveScreen) {
    return MoveScreen.getMousePosition(
      moveScreen: moveScreen,
      localMousePosition: this,
    );
  }

  static PointBoolean? getMostTopLeft(List<PointBoolean> points) {
    if (points.length == 0) {
      return null;
    } else if (points.length == 1) {
      return points[0];
    } else {
      var topLeft = points[0];
      for (int i = 1; i < points.length; ++i) {
        topLeft = PointBoolean(
          min(topLeft.x, points[i].x),
          min(topLeft.y, points[i].y),
        );
      }
      return topLeft;
    }
  }

  double get getAngleWithX {
    final ANGLE_WITHIN_PLUS_MINUS_PI_BY_TWO = atan(y / x);

    if (x < 0) {
      return pi + ANGLE_WITHIN_PLUS_MINUS_PI_BY_TWO;
    } else {
      return ANGLE_WITHIN_PLUS_MINUS_PI_BY_TWO;
    }

    /*
  if x < 0, 
    angle mag = 180 - angle
    angle sign = -ve
    hence shows in 4th quadrant
    but it should be in second quadrant

    by adding 180, it is fixed

  for angle in 4th quadrant
  x < 0 && y < 0
    angle mag = angle
    angle sign = +ve
    hence shows in 1st quadrant
    but it should be in 4th quadrant

    by adding 180 it is fixed


  */
  }

  double get distanceFromOrigin => sqrt(x * x + y * y);

  static PointBoolean rotatePointByAngle(
      PointBoolean POINT, double ANGLE_RADIANS) {
    final DISTANCE_FROM_ORIGIN = POINT.distanceFromOrigin;
    if (DISTANCE_FROM_ORIGIN == 0.0) {
      return POINT;
    }
    final ANGLE_WITH_X = POINT.getAngleWithX;
    final ANGLE_AFTER_ROTATION = ANGLE_WITH_X + ANGLE_RADIANS;
    return PointBoolean(
      DISTANCE_FROM_ORIGIN * cos(ANGLE_AFTER_ROTATION),
      DISTANCE_FROM_ORIGIN * sin(ANGLE_AFTER_ROTATION),
    );
  }

  PointBoolean rotated(double ANGLE_RADIANS) {
    return rotatePointByAngle(this, ANGLE_RADIANS);
  }

  Map GET_MAP_CONTAINING_STRING() {
    return {'x': x.toString(), 'y': y.toString()};
  }

  static PointBoolean BUILD_FROM(Map m) {
    return PointBoolean(double.parse(m['x']), double.parse(m['y']));
  }
}

class ScreenSize {
  RectangularBoundary canvasPresentSize =
      const RectangularBoundary.allCornersZero();

  static void update(
    ScreenSize screenSize, {
    RectangularBoundary? canvasSize,
  }) {
    screenSize.canvasPresentSize =
        canvasSize?.copy ?? screenSize.canvasPresentSize;
  }
}

class RectangularBoundary {
  final PointBoolean corner1;
  final PointBoolean corner2;
  final PointBoolean corner3;
  final PointBoolean corner4;
  const RectangularBoundary(
      this.corner1, this.corner2, this.corner3, this.corner4);

  const RectangularBoundary.allCornersZero()
      : corner1 = const PointBoolean(0, 0),
        corner2 = const PointBoolean(0, 0),
        corner3 = const PointBoolean(0, 0),
        corner4 = const PointBoolean(0, 0);

  RectangularBoundary.fromXYminMaxValues({
    required double xMinimum,
    required double yMinimum,
    required double xMaximum,
    required double yMaximum,
  })  : corner1 = PointBoolean(xMinimum, yMinimum),
        corner2 = PointBoolean(xMinimum, yMaximum),
        corner3 = PointBoolean(xMaximum, yMaximum),
        corner4 = PointBoolean(xMaximum, yMinimum);

  RectangularBoundary.fromOppositeCorners(
      {required PointBoolean point1, required PointBoolean point2})
      : corner1 = point1,
        corner2 = PointBoolean(point1.x, point2.y),
        corner3 = point2,
        corner4 = PointBoolean(point2.x, point1.y);

  PointBoolean get point1 => corner1;
  PointBoolean get point2 => corner3;

  static RectangularBoundary? getBoundaryFromPoints(
      List<PointBoolean> listOfPoints) {
    var rectangularBoundary = const RectangularBoundary.allCornersZero();
    if (listOfPoints.isEmpty) {
      return null;
    } else if (listOfPoints.length == 1) {
      return RectangularBoundary(
        listOfPoints[0],
        listOfPoints[0],
        listOfPoints[0],
        listOfPoints[0],
      );
    } else if (listOfPoints.length > 1) {
      rectangularBoundary = RectangularBoundary(
        listOfPoints[0],
        listOfPoints[0],
        listOfPoints[0],
        listOfPoints[0],
      );
      for (int i = 1; i < listOfPoints.length; ++i) {
        rectangularBoundary =
            rectangularBoundary.getBoundaryIncludingPoint(listOfPoints[i]);
      }
    }
    return rectangularBoundary;
  }

  RectangularBoundary getBoundaryIncludingPoint(PointBoolean pointBoolean) =>
      RectangularBoundary.fromXYminMaxValues(
        xMinimum: min(xMinimum, pointBoolean.x),
        yMinimum: min(yMinimum, pointBoolean.y),
        xMaximum: max(xMaximum, pointBoolean.x),
        yMaximum: max(yMaximum, pointBoolean.y),
      );

  double get xMinimum => [corner1.x, corner2.x, corner3.x, corner4.x]
      .reduce((value, element) => min(value, element));

  double get xMaximum => [corner1.x, corner2.x, corner3.x, corner4.x]
      .reduce((value, element) => max(value, element));

  double get yMinimum => [corner1.y, corner2.y, corner3.y, corner4.y]
      .reduce((value, element) => min(value, element));

  double get yMaximum => [corner1.y, corner2.y, corner3.y, corner4.y]
      .reduce((value, element) => max(value, element));

  bool isInsideGivenBoundary(RectangularBoundary outerBoundary) =>
      outerBoundary.xMaximum > xMaximum &&
      outerBoundary.xMinimum < xMinimum &&
      outerBoundary.yMaximum > yMaximum &&
      outerBoundary.yMinimum < yMinimum;

  RectangularBoundary operator +(PointBoolean offsetXYvalues) {
    return RectangularBoundary(
      PointBoolean(
        corner1.x + offsetXYvalues.x,
        corner1.y + offsetXYvalues.y,
      ),
      PointBoolean(
        corner2.x + offsetXYvalues.x,
        corner2.y + offsetXYvalues.y,
      ),
      PointBoolean(
        corner3.x + offsetXYvalues.x,
        corner3.y + offsetXYvalues.y,
      ),
      PointBoolean(
        corner4.x + offsetXYvalues.x,
        corner4.y + offsetXYvalues.y,
      ),
    );
  }

  RectangularBoundary move(MoveParameters moveParameters) =>
      this + PointBoolean(moveParameters.xOffset, moveParameters.yOffset);

  bool isAfterRotationRemainInsideGivenBoundary({
    required RotateParameters rotateParameters,
    required RectangularBoundary rectangularBoundary,
  }) {
    final p1 = corner1.rotatedPoint(rotateParameters);
    final p2 = corner2.rotatedPoint(rotateParameters);
    final p3 = corner3.rotatedPoint(rotateParameters);
    final p4 = corner4.rotatedPoint(rotateParameters);
    return p1.isInsideBoundary(rectangularBoundary) &&
        p2.isInsideBoundary(rectangularBoundary) &&
        p3.isInsideBoundary(rectangularBoundary) &&
        p4.isInsideBoundary(rectangularBoundary);
  }

  static RectangularBoundary? getOuterBoundaryOfAllBoundaries(
      List<RectangularBoundary?> listOfBoundaries) {
    RectangularBoundary? outerBoundary;

    if (listOfBoundaries.length == 1) {
      return listOfBoundaries[0];
    } else if (listOfBoundaries.length > 1) {
      for (int i = 1; i < listOfBoundaries.length; ++i) {
        outerBoundary = getOuterBoundaryOfTwoBoundaries(
          listOfBoundaries[i - 1],
          listOfBoundaries[i],
        );
      }
    }
    return outerBoundary;
  }

  static RectangularBoundary? getOuterBoundaryOfTwoBoundaries(
    RectangularBoundary? first,
    RectangularBoundary? second,
  ) {
    // if (first == null && second != null) {
    //   return second;
    // } else
    if (first == null || second == null) {
      return first ?? second;
    } else {
      return RectangularBoundary.fromXYminMaxValues(
        xMinimum: min(first?.xMinimum ?? 0, second?.xMinimum ?? 0),
        yMinimum: min(first?.yMinimum ?? 0, second?.yMinimum ?? 0),
        xMaximum: max(first?.xMaximum ?? 0, second?.xMaximum ?? 0),
        yMaximum: max(first?.yMaximum ?? 0, second?.yMaximum ?? 0),
      );
    }
  }

  RectangularBoundary get copy =>
      RectangularBoundary(corner1, corner2, corner3, corner4);

  RectangularBoundary dueToMoveScreen({
    required MoveScreen moveScreen,
  }) {
    return RectangularBoundary(
      corner1.getTransformedBoundaryPoint(moveScreen),
      corner2.getTransformedBoundaryPoint(moveScreen),
      corner3.getTransformedBoundaryPoint(moveScreen),
      corner4.getTransformedBoundaryPoint(moveScreen),
    );
  }

  List<PointBoolean> asList() {
    return [corner1, corner2, corner3, corner4];
  }

  @override
  String toString() =>
      'Rectangular Boundary X:${xMinimum.toString()} to ${xMaximum.toString()}, Y:${yMinimum.toString()} to ${yMaximum.toString()}';
}

class RotateParameters {
  late final PointBoolean centre;
  late final PointBoolean from;
  late final PointBoolean to;

  RotateParameters({
    required this.centre,
    required this.from,
    required this.to,
  });

  RotateParameters.allZero() {
    centre = const PointBoolean.zero();
    from = const PointBoolean.zero();
    to = const PointBoolean.zero();
  }

  //bool get radiansRotationCentreIsAtDistance
  double get radians {
    if (centre.isEqualTo(from) || centre.isEqualTo(to)) {
      return 0;
    } else {
      double theta0 = atan((from.y - centre.y) / (from.x - centre.x));
      theta0 = (from.x < centre.x) ? pi + theta0 : theta0;

      double theta1 = atan((to.y - centre.y) / (to.x - centre.x));
      theta1 = (to.x < centre.x) ? pi + theta1 : theta1;

      double theta = theta1 - theta0;
      return theta;
    }
  }

  double get degrees => 180 / pi * radians;

  @override
  String toString() => 'centre $centre, from $from, to $to';
}

class ItemsBeingRotated {
  bool itemsRotationInProgressFlag = false;
  bool waitingForCentre = false;
  bool waitingForFrom = false;
  bool waitingForTo = false;
  PointBoolean centrePoint = const PointBoolean.zero();
  PointBoolean fromPoint = const PointBoolean.zero();

  RotateParameters rotateParameters = RotateParameters.allZero();

  Map<dynamic, dynamic> itemsBeingRotatedMap = {};

  static void startRotateOperation(ItemsBeingRotated itemsBeingRotated) {
    _erase(itemsBeingRotated_: itemsBeingRotated);
    itemsBeingRotated.waitingForCentre = true;
  }

  static void centrePointFound(
    ItemsBeingRotated itemsBeingRotated, {
    required SnapPoints snapPoints,
  }) {
    itemsBeingRotated.centrePoint = snapPoints.snapPointOnScreen;
    itemsBeingRotated.waitingForCentre = false;
    itemsBeingRotated.waitingForFrom = true;
  }

  static void fromPointFound(
    ItemsBeingRotated itemsBeingRotated, {
    required SnapPoints snapPoints,
  }) {
    itemsBeingRotated.fromPoint = snapPoints.snapPointOnScreen;
    itemsBeingRotated.waitingForFrom = false;
    itemsBeingRotated.waitingForTo = true;
  }

  static void updateItemsBeingRotated(
    ItemsBeingRotated itemsBeingRotated, {
    required Map<dynamic, dynamic> allElementsMap,
    required SnapPoints snapPoints,
    required SelectParameters selectParameters,
    required ScreenSize screenSize,
  }) {
    itemsBeingRotated.rotateParameters = RotateParameters(
      centre: itemsBeingRotated.centrePoint,
      from: itemsBeingRotated.fromPoint,
      to: snapPoints.snapPointOnScreen,
    );

    itemsBeingRotated.itemsBeingRotatedMap = {};

    for (final elementType in selectParameters.keyOfAllSelectedElements.keys) {
      itemsBeingRotated.itemsBeingRotatedMap[elementType] =
          ElementMethods.getCopyOfRotatedElements(
        sameElementTypeMap: allElementsMap[elementType],
        keyOfItemsToBeRotated:
            selectParameters.keyOfAllSelectedElements[elementType],
        rotateParameters: itemsBeingRotated.rotateParameters,
        boundaryOfAllSelectedElements:
            selectParameters.boundaryOfAllSelectedItems ??
                const RectangularBoundary.allCornersZero(),
        screenSize: screenSize.canvasPresentSize,
      );
    }

    itemsBeingRotated.itemsRotationInProgressFlag = true;
  }

  static void rotationComplete({
    required ItemsBeingRotated itemsBeingRotated_,
    required Map<dynamic, dynamic> allElementsMap_,
    required SelectParameters selectParameters,
    required ClickableCoordinates clickableCoordinates,
    required double GRID_GAP,
  }) {
    _copyItemsBeingRotatedToOriginalData(
      allElementsMap_: allElementsMap_,
      itemsBeingRotated: itemsBeingRotated_,
      selectParameters: selectParameters,
    );

    _erase(itemsBeingRotated_: itemsBeingRotated_);

    ClickableCoordinatesOperations.recalculateCoordinates(
      clickableCoordinates: clickableCoordinates,
      ALL_ELEMENTS: allElementsMap_,
      GRID_GAP: GRID_GAP,
    );
  }

  static void rotationCancel(ItemsBeingRotated itemsBeingRotated) {
    _erase(itemsBeingRotated_: itemsBeingRotated);
  }

  static void _copyItemsBeingRotatedToOriginalData({
    required Map<dynamic, dynamic> allElementsMap_,
    required ItemsBeingRotated itemsBeingRotated,
    required SelectParameters selectParameters,
  }) {
    for (final elementType in selectParameters.allSelectedElements.keys) {
      if (selectParameters.keyOfAllSelectedElements[elementType] != []) {
        for (final keyOfItem
            in selectParameters.keyOfAllSelectedElements[elementType] ?? []) {
          allElementsMap_[elementType][keyOfItem] =
              (itemsBeingRotated.itemsBeingRotatedMap[elementType][keyOfItem])
                  .copy;
        }
      }
    }
  }

  static void _erase({required ItemsBeingRotated itemsBeingRotated_}) {
    itemsBeingRotated_.itemsBeingRotatedMap = {};

    itemsBeingRotated_
      ..itemsRotationInProgressFlag = false
      ..waitingForCentre = false
      ..waitingForFrom = false
      ..waitingForTo = false
      ..centrePoint = const PointBoolean.zero()
      ..fromPoint = const PointBoolean.zero();
  }
}

class CreateParameters {
  bool waitingForFirstPoint = false;
  bool arePointsAvailableForCreationStarting = false;
  bool arePointsReadyForCompletion = false;
  ElementType elementType = ElementType.noElement;

  List<PointBoolean> points = [];
  String text = '';

  CreateParameters();

  static void emptyAll(CreateParameters other) {
    other.waitingForFirstPoint = false;
    other.arePointsAvailableForCreationStarting = false;
    other.arePointsReadyForCompletion = false;
    other.points.clear();
    other.text = '';
    other.elementType = ElementType.noElement;
  }

  void clear() {
    CreateParameters.emptyAll(this);
  }

  static CreateParameters clone(CreateParameters other) {
    var newCreateParameter = CreateParameters();
    newCreateParameter.arePointsAvailableForCreationStarting =
        other.arePointsAvailableForCreationStarting;
    newCreateParameter.elementType = other.elementType;
    var newList = [...other.points];
    newCreateParameter.points = newList;
    newCreateParameter.text = other.text;
    newCreateParameter.arePointsReadyForCompletion =
        other.arePointsReadyForCompletion;
    return newCreateParameter;
  }

  CreateParameters get copy => clone(this);

  void itemSelectedForCreation_({
    required ElementType ELEMENT_TYPE,
  }) {
    elementType = ELEMENT_TYPE;
    waitingForFirstPoint = true;
    arePointsAvailableForCreationStarting = false;
    arePointsReadyForCompletion = false;

    if (elementType == ElementType.text ||
        elementType == ElementType.multiText ||
        elementType == ElementType.multiTextButton) {
      arePointsAvailableForCreationStarting = true;
    }

    print('Item selected for creation: $elementType');
  }

  static addAnotherPoint(
    CreateParameters other,
  ) {
    if (other.elementType != ElementType.noElement) {
      other.points.add(appData.snapPoints.snapPointOnScreen.copy);
    }
    if (other.elementType == ElementType.lineBoolean ||
        other.elementType == ElementType.rectangleBoolean ||
        other.elementType == ElementType.circleBoolean ||
        other.elementType == ElementType.circleBooleanPointPoint) {
      other.waitingForFirstPoint = other.points.isEmpty;
      other.arePointsAvailableForCreationStarting = other.points.length == 1;

      if (other.points.length == 2) {
        other.arePointsReadyForCompletion = true;
      }
    } else if (other.elementType == ElementType.text ||
        other.elementType == ElementType.multiText ||
        other.elementType == ElementType.multiTextButton) {
      other.arePointsReadyForCompletion = other.points.length == 1;
    }

    print('Points for creation ${other.points}');
  }
}

class ItemBeingCreated {
  dynamic item;

  void updateItem_(dynamic ITEM) {
    item = ITEM.copy;
  }

  static ({bool itemCreationComplete}) updateItemBeingCreated(
    ItemBeingCreated itemBeingCreated, {
    required SnapPoints snapPoints,
    required CreateParameters createParameters,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    if (createParameters.arePointsReadyForCompletion) {
      print('update item , are points ready for completion executed');
      getNewElement(
        createParameters: createParameters,
        itemBeingCreated_: itemBeingCreated,
      );

      appendNewItem(
        createParameters: createParameters,
        itemBeingCreated: itemBeingCreated,
      );

      createParameters.clear();
      itemBeingCreated.clear();

      Function.apply(
        RECALCULATE_CLICKABLE_COORDINATES,
        [],
        kwargs_recalculate_clickable_coordinates,
      );

      return (itemCreationComplete: true);
    } else if (createParameters.arePointsAvailableForCreationStarting) {
      // is point avail for creation starting then update
      var tempCreateParameters = createParameters.copy;
      tempCreateParameters.points.add(snapPoints.snapPointOnScreen.copy);

      if (createParameters.elementType == ElementType.text ||
          createParameters.elementType == ElementType.multiText ||
          createParameters.elementType == ElementType.multiTextButton) {
        itemBeingCreated.item
            .updateProperties(pivotPoint: snapPoints.snapPointOnScreen);
      } else {
        ItemBeingCreated.getNewElement(
          createParameters: tempCreateParameters,
          itemBeingCreated_: itemBeingCreated,
        );
      }
    }
    return (itemCreationComplete: false);
  }

  void clear() {
    item = null;
  }

  static void getNewElement({
    required ItemBeingCreated itemBeingCreated_,
    required CreateParameters createParameters,
  }) {
    if (createParameters.elementType == ElementType.text ||
        createParameters.elementType == ElementType.multiText ||
        createParameters.elementType == ElementType.multiTextButton) {
      itemBeingCreated_.item
          .updateProperties(pivotPoint: createParameters.points[0]);
    } else {
      itemBeingCreated_.item =
          ElementMethods.createNewElement(createParameters).copy;
    }
  }

  static void appendNewItem({
    required CreateParameters createParameters,
    required ItemBeingCreated itemBeingCreated,
  }) {
    ElementMethods.appendCopyOfItemToElementMap(
      allScreenElements: appData.allScreenElements,
      newElement: itemBeingCreated.item,
      elementType: createParameters.elementType,
    );
  }

  //text create methods
  void increaseTextFontSize() {
    if (item.runtimeType == TextBoolean) {
      item.increaseFontSizeBy(0.5);
    }
  }

  void decreaseTextFontSize() {
    if (item.runtimeType == TextBoolean) {
      item.decreaseFontSizeBy(0.5);
    }
  }

  void updateTrueTextTo(String text) {
    if (item.runtimeType == TextBoolean) {
      item.updateProperties(textTrue: text);
    }
  }

  void updateFalseTextTo(String text) {
    if (item.runtimeType == TextBoolean) {
      item.updateProperties(textFalse: text);
    }
  }

  void textCreateDialog(DialogBoxConfiguration config) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: config.backGround,
        surfaceTintColor: config.backGround,
        child: SizedBox(
          width: config.width,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(
                    width: config.textLabelWidth,
                    child: Text(
                      'Enter false text',
                      style: TextStyle(color: config.fontColorContent),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: config.textFieldWidth,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RobotoMono',
                        fontSize: 15,
                      ),
                      onChanged: (typedText) {
                        if (typedText == '') {
                          NewElementOnScreenCallback.textUpdated(' ',
                              isTrueText: false);
                        } else {
                          NewElementOnScreenCallback.textUpdated(typedText,
                              isTrueText: false);
                        }
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
              Row(
                children: [
                  SizedBox(
                    width: config.textLabelWidth,
                    child: Text(
                      'Enter text when value is true',
                      style: TextStyle(color: config.fontColorContent),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: config.textFieldWidth,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RobotoMono',
                        fontSize: 15,
                      ),
                      onChanged: (typedText) {
                        if (typedText == '') {
                          NewElementOnScreenCallback.textUpdated(' ',
                              isTrueText: true);
                        } else {
                          NewElementOnScreenCallback.textUpdated(typedText,
                              isTrueText: true);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'enter true text here',
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
              const TextSize(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: config.backGroundCancelButton,
                    ),
                    onPressed: () {
                      NewElementOnScreenCallback
                          .cancelTextCreateButtonPressed();
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: config.buttonWidth,
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: config.fontColorButton,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: config.buttonWidth * 2,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: config.backGroundUpdateButton,
                    ),
                    onPressed: () {
                      NewElementOnScreenCallback
                          .updateTextCreateButtonPressed();
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: config.buttonWidth,
                      child: Text(
                        'Update',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: config.fontColorButton,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MoveParameters {
  final PointBoolean from;
  final PointBoolean to;
  const MoveParameters({required this.from, required this.to});

  double get xOffset => to.x - from.x;
  double get yOffset => to.y - from.y;

  PointBoolean get offsetAsAPoint => PointBoolean(xOffset, yOffset);

  @override
  String toString() => '$from -> $to';
}

class ItemsBeingMoved {
  bool itemsMovementInProgressFlag = false;
  bool waitingForFirstPoint = false;
  bool waitingForSecondPoint = false;
  PointBoolean fromPoint = const PointBoolean.zero();

  Map<dynamic, dynamic> itemsBeingMovedMap = {};

  static void startMoveOperation(ItemsBeingMoved itemsBeingMoved) {
    ItemsBeingMoved._eraseItemBeingMoved(itemsBeingMoved);
    itemsBeingMoved.waitingForFirstPoint = true;
  }

  static void fromPointUpdated(
    ItemsBeingMoved itemsBeingMoved, {
    required SnapPoints snapPoints,
  }) {
    itemsBeingMoved.fromPoint = snapPoints.snapPointOnScreen.copy;
    itemsBeingMoved.waitingForFirstPoint = false;
    itemsBeingMoved.waitingForSecondPoint = true;
  }

  static void updateDueToMouseMovement(
    ItemsBeingMoved itemsBeingMoved, {
    required SnapPoints snapPoints,
    required SelectParameters selectParameters,
    required Map<dynamic, dynamic> allElements,
    required ScreenSize screenSize,
    required MoveScreen moveScreen,
  }) {
    _updateItemsBeingMoved(
      itemsBeingMoved,
      allElementsMap: allElements,
      moveParameters: MoveParameters(
        from: itemsBeingMoved.fromPoint,
        to: snapPoints.snapPointOnScreen,
      ),
      selectParameters: selectParameters,
      presentCanvasSize: screenSize.canvasPresentSize,
      moveScreen: moveScreen,
    );
    print(itemsBeingMoved.itemsBeingMovedMap);
  }

  static void movementComplete({
    required ItemsBeingMoved itemsBeingMoved_,
    required Map<dynamic, dynamic> allElementsMap_,
    required SelectParameters selectParameters,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    // copy items being moved to original data
    ItemsBeingMoved._copyItemsBeingMovedToOriginalData(
      itemsBeingMoved_: itemsBeingMoved_,
      allElementsMap_: allElementsMap_,
      selectParameters: selectParameters,
    );

    // erase items being moved
    ItemsBeingMoved._eraseItemBeingMoved(itemsBeingMoved_);

    //recalculate clickable coordinates
    Function.apply(
      RECALCULATE_CLICKABLE_COORDINATES,
      [],
      kwargs_recalculate_clickable_coordinates,
    );
  }

  static void movementCancel(ItemsBeingMoved itemsBeingMoved) =>
      ItemsBeingMoved._eraseItemBeingMoved(itemsBeingMoved);

  static void _updateItemsBeingMoved(
    ItemsBeingMoved itemsBeingMoved, {
    required Map<dynamic, dynamic> allElementsMap,
    required MoveParameters moveParameters,
    required SelectParameters selectParameters,
    required RectangularBoundary presentCanvasSize,
    required MoveScreen moveScreen,
  }) {
    itemsBeingMoved.itemsBeingMovedMap.clear();

    for (final elementType in selectParameters.allSelectedElements.keys) {
      itemsBeingMoved.itemsBeingMovedMap[elementType] =
          ElementMethods.getCopyOfMovedElements(
        originalElementMap: allElementsMap[elementType],
        keyOfItemsToBeMoved:
            selectParameters.keyOfAllSelectedElements[elementType],
        moveParameters: moveParameters,
        boundaryOfAllSelectedElements:
            selectParameters.boundaryOfAllSelectedItems ??
                const RectangularBoundary.allCornersZero(),
        screenSize: presentCanvasSize.dueToMoveScreen(moveScreen: moveScreen),
      );
    }

    itemsBeingMoved.itemsMovementInProgressFlag = true;
  }

  static void _copyItemsBeingMovedToOriginalData({
    required ItemsBeingMoved itemsBeingMoved_,
    required Map<dynamic, dynamic> allElementsMap_,
    required SelectParameters selectParameters,
  }) {
    for (final elementType in ElementType.values) {
      if (selectParameters.keyOfAllSelectedElements[elementType] != []) {
        for (final keyOfItem
            in selectParameters.keyOfAllSelectedElements[elementType] ?? []) {
          allElementsMap_[elementType][keyOfItem] =
              (itemsBeingMoved_.itemsBeingMovedMap[elementType][keyOfItem])
                  ?.copy;
        }
      }
    }
  }

  static void _eraseItemBeingMoved(ItemsBeingMoved itemsBeingMoved) {
    // itemsBeingMoved.itemsBeingMovedMap[ElementType.lineBoolean] = {};
    // itemsBeingMoved.itemsBeingMovedMap[ElementType.rectangleBoolean] = {};
    itemsBeingMoved.itemsBeingMovedMap = {};
    itemsBeingMoved.itemsMovementInProgressFlag = false;
    itemsBeingMoved.waitingForFirstPoint = false;
    itemsBeingMoved.waitingForSecondPoint = false;
  }
}

class ItemBeingEdited {
  // dynamic elementBeingEdited = LineBoolean();
  dynamic elementOriginalCopy;
  dynamic elementModified;
  bool editingUnderProgress = false;
  ElementType elementType = ElementType.noElement;
  String keyOfItem = '';
  int noOfLayersOfDialogOpen = 0;

  ///this is the first method to be called when any element editing is started.
  ///
  ///It initializes everything related to item being edited
  void editStarted({
    required dynamic ORIGINAL_ELEMENT,
    required ElementType ELEMENT_TYPE,
    required String KEY_OF_ITEM,
  }) {
    elementModified = ORIGINAL_ELEMENT.copy;
    elementOriginalCopy = ORIGINAL_ELEMENT.copy;
    editingUnderProgress = true;
    elementType = ELEMENT_TYPE;
    keyOfItem = KEY_OF_ITEM;
  }

  // void copyToOriginal_() {
  //   //do nothing as orginal element is
  // }

  ///original element is kept as it is. Modification done on element is deleted
  void scrapModifiedAndKeepOriginal_() {
    //do nothing as original element is not modified at all
  }

  ///modified element is written to original screen element
  void keepModified_({
    required dynamic originalElement,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    originalElement.updateFrom(elementModified);

    Function.apply(
      RECALCULATE_CLICKABLE_COORDINATES,
      [],
      kwargs_recalculate_clickable_coordinates,
    );
  }

  ///this method ends item editing in progress. All data related to item editing
  ///is deleted and this object is now ready for next item to be edited.
  void cancel_() {
    // POP_ALL_OPEN_DIALOG(itemBeingEdited);
    editingUnderProgress = false;
    elementType = ElementType.noElement;
    keyOfItem = '';
    noOfLayersOfDialogOpen = 0;
    elementOriginalCopy = null;
    elementModified = null;
  }

  //private methods
  // static _popAllOpenDialog(ItemBeingEdited itemBeingEdited) {
  //   if (itemBeingEdited.noOfLayersOfDialogOpen == 1) {
  //     Navigator.pop(buildContext);
  //   } else if (itemBeingEdited.noOfLayersOfDialogOpen == 2) {
  //     Navigator.pop(buildContext);
  //     Navigator.pop(buildContext);
  //   }
  // }
  @override
  String toString() {
    return '''ItemBeingEdited {
  elementType : $elementType,
  keyOfItem : $keyOfItem,
  elementOriginalCopy : $elementOriginalCopy,
  elementModified : $elementModified,
  editingUnderProgress : $editingUnderProgress,
}''';
  }
}

class ItemsBeingCopied {
  bool multipleCopyInProgress = false;
  bool waitingForFirstPoint = false;
  bool waitingForSecondPoint = false;
  bool itemsCopyInProgressFlag = false;

  PointBoolean fromPoint = const PointBoolean.zero();

  Map<dynamic, dynamic> itemMapTypeKeyElement = {};

  void startSingle() {
    _eraseItemBeingCopied();
    waitingForFirstPoint = true;
  }

  void startMultiple() {
    _eraseItemBeingCopied();
    multipleCopyInProgress = true;
    waitingForFirstPoint = true;
  }

  void fromPointUpdated({
    required SnapPoints snapPoints,
  }) {
    fromPoint = snapPoints.snapPointOnScreen.copy;
    waitingForFirstPoint = false;
    waitingForSecondPoint = true;
  }

  void updateDueToMouseMovement({
    required SnapPoints snapPoints,
    required SelectParameters selectParameters,
    required Map<dynamic, dynamic> allElements,
    required ScreenSize screenSize,
    required MoveScreen moveScreen,
  }) {
    _updateItemsBeingCopied(
      allElementsMap: allElements,
      moveParameters:
          MoveParameters(from: fromPoint, to: snapPoints.snapPointOnScreen),
      selectParameters: selectParameters,
      presentCanvasSize:
          screenSize.canvasPresentSize.dueToMoveScreen(moveScreen: moveScreen),
    );
    print('Item being copied updated: ${itemMapTypeKeyElement}');
  }

  void completeOneCopy({
    required Map<dynamic, dynamic> allElementsMap_,
    required SelectParameters selectParameters,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    for (final elementType in selectParameters.keyOfAllSelectedElements.keys) {
      for (final elementKey
          in selectParameters.keyOfAllSelectedElements[elementType]) {
        ElementMethods.appendCopyOfItemToElementMap(
          allScreenElements: allElementsMap_,
          newElement: itemMapTypeKeyElement[elementType][elementKey].copy,
          elementType: elementType,
        );
      }
    }

    Function.apply(
      RECALCULATE_CLICKABLE_COORDINATES,
      [],
      kwargs_recalculate_clickable_coordinates,
    );

    // print('item copy one complete ${itemMapTypeKeyElement}');
  }

  void complete({
    required Map<dynamic, dynamic> allElementsMap_,
    required SelectParameters selectParameters,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    for (final elementType in selectParameters.keyOfAllSelectedElements.keys) {
      for (final elementKey
          in selectParameters.keyOfAllSelectedElements[elementType]) {
        ElementMethods.appendCopyOfItemToElementMap(
          allScreenElements: allElementsMap_,
          newElement: itemMapTypeKeyElement[elementType][elementKey].copy,
          elementType: elementType,
        );
      }
    }

    // erase items being moved
    _eraseItemBeingCopied();

    Function.apply(
      RECALCULATE_CLICKABLE_COORDINATES,
      [],
      kwargs_recalculate_clickable_coordinates,
    );
  }

  void cancel() => _eraseItemBeingCopied();

  void _updateItemsBeingCopied({
    required Map<dynamic, dynamic> allElementsMap,
    required MoveParameters moveParameters,
    required SelectParameters selectParameters,
    required RectangularBoundary presentCanvasSize,
  }) {
    itemMapTypeKeyElement.clear();

    for (final elementType in selectParameters.allSelectedElements.keys) {
      itemMapTypeKeyElement[elementType] =
          ElementMethods.getCopyOfMovedElements(
        originalElementMap: allElementsMap[elementType],
        keyOfItemsToBeMoved:
            selectParameters.keyOfAllSelectedElements[elementType],
        moveParameters: moveParameters,
        boundaryOfAllSelectedElements:
            selectParameters.boundaryOfAllSelectedItems ??
                const RectangularBoundary.allCornersZero(),
        screenSize: presentCanvasSize,
      );
    }

    itemsCopyInProgressFlag = true;
  }

  void _eraseItemBeingCopied() {
    itemMapTypeKeyElement = {};
    itemsCopyInProgressFlag = false;
    waitingForFirstPoint = false;
    waitingForSecondPoint = false;
    multipleCopyInProgress = false;
  }
}

class SnapPoints {
  bool mouseFirstTimeMovedOnScreen = false;
  bool mouseInsideScreen = false;
  PointBoolean snapPointOnScreen = const PointBoolean(0, 0);
  PointBoolean currentMousePosition = const PointBoolean.zero();
  PointBoolean virtualMousePosition = const PointBoolean.zero();
  List<List<bool>> isSnapAvailable = [];
  Map<int, Map<int, List<PointBoolean>>> snapPoints = {};
  // Map<double, List<PointBoolean>> allSnapPoints = {};
  Map<SnapOn, bool> snapSelection = {
    SnapOn.grid: true,
    SnapOn.boundary: false,
    SnapOn.centre: false,
    SnapOn.endPoint: false,
  };

  void mouseIsInsideScreen() {
    mouseInsideScreen = true;
  }

  void mouseIsOutsideScreen() {
    mouseInsideScreen = false;
  }

  void recalculateAllSnapPointsDueToSelectionChangeOrElementsChange({
    required Map<SnapOn, bool> snapSelection,
    required Map<dynamic, dynamic> allElements,
    required double gapBetweenBoundarySnapPoints,
    required MoveScreen moveScreen,
  }) {
    this.snapSelection = snapSelection;
    double gap = gapBetweenBoundarySnapPoints / moveScreen.scale;

    final pointList = ElementMethods.getAllSnapPoints(
      allElements: allElements,
      gap: gap,
      snapSelection: snapSelection,
      elementTypeList: PaintElements.elementTypeList,
    );

    snapPoints = {};

    for (final point in pointList) {
      appendSnapPoint(point);
    }
    // print(snapPoints);
  }

  bool calculateSnapPointOnScreenDueToMouseMovement({
    required double snapPrecision,
    required MoveScreen moveScreen,
    required GridScreen gridScreen,
  }) {
    if (snapSelection[SnapOn.grid] == false &&
        snapSelection[SnapOn.boundary] == false &&
        snapSelection[SnapOn.centre] == false &&
        snapSelection[SnapOn.endPoint] == false) {
      snapPointOnScreen = currentMousePosition;
      return true;
    } else {
      PointBoolean? gridSnapPoint;

      if (snapSelection[SnapOn.grid] == true) {
        double precision = snapPrecision / moveScreen.scale;
        double gridGap = gridScreen.gapGridActual;

        int indexMatchedX;
        int indexMatchedY;

        double remainderX = virtualMousePosition.x % gridGap;
        double remainderY = virtualMousePosition.y % gridGap;
        double xMatched;

        if (virtualMousePosition.x < 0) {
          indexMatchedX = 0;
        } else {
          indexMatchedX = virtualMousePosition.x ~/ gridGap;
          indexMatchedX =
              remainderX > precision ? indexMatchedX + 1 : indexMatchedX;
          indexMatchedX = indexMatchedX >= gridScreen.gridPoints.length
              ? gridScreen.gridPoints.length - 1
              : indexMatchedX;
        }
        xMatched = gridScreen.gridPoints.keys.elementAt(indexMatchedX);

        if (virtualMousePosition.y < 0) {
          indexMatchedY = 0;
        } else {
          indexMatchedY = virtualMousePosition.y ~/ gridGap;
          indexMatchedY =
              remainderY > precision ? indexMatchedY + 1 : indexMatchedY;
          indexMatchedY =
              indexMatchedY >= gridScreen.gridPoints[xMatched]!.length
                  ? gridScreen.gridPoints[xMatched]!.length - 1
                  : indexMatchedY;
        }

        gridSnapPoint = (gridScreen.gridPoints[xMatched] ?? [])[indexMatchedY];
      }

      RectangularBoundary snapMarginBoundary = GET_SNAP_MARGIN_BOUNDARY(
        moveScreen: moveScreen,
        snapPrecision: snapPrecision,
      );

      PointBoolean? newSnapPoint = CALCULATE_SNAP_POINT_AS_PER_CURRENT_POS(
        gridSnapPoint: gridSnapPoint,
        snapMarginBoundary: snapMarginBoundary,
      );

      if (newSnapPoint == null || newSnapPoint == snapPointOnScreen) {
        return false;
      } else {
        snapPointOnScreen = newSnapPoint;
        return true;
      }
    }
  }

  static Map<SnapOn, bool> getSnapSelectionWithToggledGrid(
      Map<SnapOn, bool> snapSelectionInput) {
    Map<SnapOn, bool> tempSnapSelection = {
      SnapOn.grid: snapSelectionInput[SnapOn.grid] == true ? false : true,
      SnapOn.boundary:
          snapSelectionInput[SnapOn.boundary] == true ? true : false,
      SnapOn.centre: snapSelectionInput[SnapOn.centre] == true ? true : false,
      SnapOn.endPoint:
          snapSelectionInput[SnapOn.endPoint] == true ? true : false,
    };
    return tempSnapSelection;
  }

  static Map<SnapOn, bool> getSnapSelectionWithToggledBoundary(
      Map<SnapOn, bool> snapSelectionInput) {
    Map<SnapOn, bool> tempSnapSelection = {
      SnapOn.grid: snapSelectionInput[SnapOn.grid] == true ? true : false,
      SnapOn.boundary:
          snapSelectionInput[SnapOn.boundary] == true ? false : true,
      SnapOn.centre: snapSelectionInput[SnapOn.centre] == true ? true : false,
      SnapOn.endPoint:
          snapSelectionInput[SnapOn.endPoint] == true ? true : false,
    };
    return tempSnapSelection;
  }

  static Map<SnapOn, bool> getSnapSelectionWithToggledCentre(
      Map<SnapOn, bool> snapSelectionInput) {
    Map<SnapOn, bool> tempSnapSelection = {
      SnapOn.grid: snapSelectionInput[SnapOn.grid] == true ? true : false,
      SnapOn.boundary:
          snapSelectionInput[SnapOn.boundary] == true ? true : false,
      SnapOn.centre: snapSelectionInput[SnapOn.centre] == true ? false : true,
      SnapOn.endPoint:
          snapSelectionInput[SnapOn.endPoint] == true ? true : false,
    };
    return tempSnapSelection;
  }

  static Map<SnapOn, bool> getSnapSelectionWithToggledEndPoint(
      Map<SnapOn, bool> snapSelectionInput) {
    Map<SnapOn, bool> tempSnapSelection = {
      SnapOn.grid: snapSelectionInput[SnapOn.grid] == true ? true : false,
      SnapOn.boundary:
          snapSelectionInput[SnapOn.boundary] == true ? true : false,
      SnapOn.centre: snapSelectionInput[SnapOn.centre] == true ? true : false,
      SnapOn.endPoint:
          snapSelectionInput[SnapOn.endPoint] == true ? false : true,
    };
    return tempSnapSelection;
  }

  static updateCurrentMousePosition(
    SnapPoints snapPoints, {
    required PointBoolean currentMousePosition,
    required MoveScreen moveScreen,
    required GridScreen gridScreen,
  }) {
    snapPoints.currentMousePosition = MoveScreen.getMousePosition(
      moveScreen: appData.moveScreen,
      localMousePosition: currentMousePosition,
    );

    snapPoints.virtualMousePosition = PointBoolean(
      snapPoints.currentMousePosition.x - gridScreen.gridPoints.keys.first,
      snapPoints.currentMousePosition.y -
          (gridScreen.gridPoints[gridScreen.gridPoints.keys.first]?[0] ??
                  const PointBoolean.zero())
              .y,
    );
  }

  RectangularBoundary GET_SNAP_MARGIN_BOUNDARY({
    required MoveScreen moveScreen,
    required double snapPrecision,
  }) {
    double precisionAfterScaling = snapPrecision / moveScreen.scale;
    return RectangularBoundary.fromXYminMaxValues(
      xMinimum: currentMousePosition.x - precisionAfterScaling / 2,
      xMaximum: currentMousePosition.x + precisionAfterScaling / 2,
      yMinimum: currentMousePosition.y - precisionAfterScaling / 2,
      yMaximum: currentMousePosition.y + precisionAfterScaling / 2,
    );
  }

  PointBoolean? CALCULATE_SNAP_POINT_AS_PER_CURRENT_POS({
    required PointBoolean? gridSnapPoint,
    required RectangularBoundary snapMarginBoundary,
  }) {
    int xMin = snapMarginBoundary.xMinimum.toInt();
    int xMax = snapMarginBoundary.xMaximum.toInt();
    int yMin = snapMarginBoundary.yMinimum.toInt();
    int yMax = snapMarginBoundary.yMaximum.toInt();

    double? closestDistance;
    PointBoolean? closestPoint;

    if (gridSnapPoint != null) {
      closestDistance = gridSnapPoint.distanceFrom(currentMousePosition);
      closestPoint = gridSnapPoint;
    }

    for (int x = xMin; x <= xMax; ++x) {
      for (int y = yMin; y <= yMax; ++y) {
        final pointList = snapPoints[x]?[y];
        if (pointList != null) {
          for (final point in pointList) {
            if (closestDistance == null) {
              closestPoint = point;
              closestDistance = point.distanceFrom(currentMousePosition);
            } else {
              final newDistance = point.distanceFrom(currentMousePosition);
              if (newDistance < closestDistance) {
                closestDistance = newDistance;
                closestPoint = point;
              }
            }
          }
        }
      }
    }

    return closestPoint;
  }

  void appendSnapPoint(PointBoolean point) {
    List<PointBoolean> pointList = [point];
    if (snapPoints[point.x.toInt()] == null) {
      snapPoints[point.x.toInt()] = {point.y.toInt(): pointList};
    } else {
      if (snapPoints[point.x.toInt()]?[point.y.toInt()] == null) {
        snapPoints[point.x.toInt()]![point.y.toInt()] = pointList;
      } else {
        snapPoints[point.x.toInt()]?[point.y.toInt()]?.addAll(pointList);
      }
    }
  }

  /// Snap point contains map<double, map<double,List<PointBoolean>>

  /// For same x.toInt() , put all y point in that list
  /// for every mouse movement, generates Select Rectangle
  /// get snap point inside that select rectangle, including gridSnapPoint
  /// whichever of snap point is closer to current mouse position, that is final snap point
  ///
  ///
  ///
  ///
  ///
  ///
}

class SelectParameters {
  RectangularBoundary? boundaryOfAllSelectedItems;
  num numberOfItemsSelected = 0;

  //Map<ElementType, List<String> >
  Map<ElementType, dynamic> keyOfAllSelectedElements = {};

  Map<ElementType, dynamic> allSelectedElements = {};

  bool firstPointOfSelectRectangleReceived = false;
  bool isSelectionRectangleStillChanging = false;
  var selectionRectangle = const RectangularBoundary.allCornersZero();

  void selectItemsDueToSelectRectangleComplete({
    required Map<dynamic, dynamic> allElements,
  }) {
    Map<dynamic, dynamic>? selectedItemsMAPstringElement;

    for (final elementType in PaintElements.elementTypeList) {
      selectedItemsMAPstringElement =
          ElementMethods.getSelectedElementsCopyFromSelectRectangle(
        sameElementTypeMap: allElements[elementType],
        selectRectangle: selectionRectangle,
      );
      if (selectedItemsMAPstringElement != null) {
        if (allSelectedElements[elementType] == null) {
          allSelectedElements[elementType] = selectedItemsMAPstringElement;
        } else {
          allSelectedElements[elementType]
              .addAll(selectedItemsMAPstringElement);
        }
      }
    }
    print(allSelectedElements);

    selectionRectangle = const RectangularBoundary.allCornersZero();

    _updateKeysOfSelectedItemsFromAllSelectedItems();
    _calculateBoundaryOfAllSelectedItems();
    _updateNumberOfItemsSelected();
    _resetBooleanForSelectRectangle();
  }

  void _resetBooleanForSelectRectangle() {
    firstPointOfSelectRectangleReceived = false;
    isSelectionRectangleStillChanging = false;
  }

  void _updateKeysOfSelectedItemsFromAllSelectedItems() {
    for (final elementType in allSelectedElements.keys) {
      keyOfAllSelectedElements[elementType] =
          allSelectedElements[elementType]?.keys.toList();
    }
    print(keyOfAllSelectedElements);
  }

  void _calculateBoundaryOfAllSelectedItems() {
    boundaryOfAllSelectedItems = null;

    // boundaryOfAllSelectedItems =
    //     RectangularBoundary.getOuterBoundaryOfAllBoundaries([
    //   GenericMethods.getBoundaryFromMapStringElement(
    //     allSelectedElements[ElementType.lineBoolean],
    //   ),
    //   GenericMethods.getBoundaryFromMapStringElement(
    //     allSelectedElements[ElementType.rectangleBoolean],
    //   ),
    // ]);
    // for (final elementType in allSelectedElements.keys) {
    //   boundaryOfAllSelectedItems =
    //       RectangularBoundary.getOuterBoundaryOfAllBoundaries([
    //     boundaryOfAllSelectedItems,
    //     GenericMethods.getBoundaryFromMapStringElement(
    //       allSelectedElements[elementType],
    //     )
    //   ]);
    // }

    for (final elementType in allSelectedElements.keys) {
      for (final item in allSelectedElements[elementType].values) {
        boundaryOfAllSelectedItems =
            RectangularBoundary.getOuterBoundaryOfTwoBoundaries(
          boundaryOfAllSelectedItems,
          item.getBoundary,
        );
      }
    }
  }

  void _updateNumberOfItemsSelected() {
    numberOfItemsSelected = 0;
    for (final elementType in allSelectedElements.keys) {
      numberOfItemsSelected += allSelectedElements[elementType].length;
    }

    StateCallback.numberOfSelectedItemsChanged();
  }

  void cancelSelectedItems() {
    _resetBooleanForSelectRectangle();
    keyOfAllSelectedElements = {};

    allSelectedElements = {};
    selectionRectangle = const RectangularBoundary.allCornersZero();
    boundaryOfAllSelectedItems = null;
    _updateNumberOfItemsSelected();
  }

  void updateFirstPointFromMousePosition() {
    selectionRectangle = RectangularBoundary.fromOppositeCorners(
      point1: appData.snapPoints.currentMousePosition,
      point2: selectionRectangle.corner3,
    );
    firstPointOfSelectRectangleReceived = true;
  }

  void updateSecondPointFromMousePosition() {
    selectionRectangle = RectangularBoundary.fromOppositeCorners(
        point1: selectionRectangle.point1,
        point2: appData.snapPoints.currentMousePosition);
    isSelectionRectangleStillChanging = true;
  }

  void selectionComplete() {
    selectionRectangle = RectangularBoundary.fromOppositeCorners(
        point1: selectionRectangle.point1,
        point2: appData.snapPoints.currentMousePosition);
    selectItemsDueToSelectRectangleComplete(
        allElements: appData.allScreenElements);
  }

  static void updateSelectedElementsKeepingSameKeys(
    SelectParameters selectParameters, {
    required Map<dynamic, dynamic> allElements,
  }) {
    for (final elementType in selectParameters.allSelectedElements.keys) {
      selectParameters.allSelectedElements[elementType] = {};
      for (final itemKey
          in selectParameters.keyOfAllSelectedElements[elementType]) {
        selectParameters.allSelectedElements[elementType]
            .addAll({itemKey: allElements[elementType][itemKey]});
      }
    }
  }
}

class DeleteItems {
  static void deleteItemsWhichAreSelected({
    required Map<ElementType, dynamic> selectedItemsKeyMAPelementTypeListString,
    required Map<dynamic, dynamic> allElementsMAPelementTypeStringElement,
    required Function RECALCULATE_CLICKABLE_COORDINATES,
    required Map<Symbol, dynamic> kwargs_recalculate_clickable_coordinates,
  }) {
    for (final elementType in selectedItemsKeyMAPelementTypeListString.keys) {
      if (selectedItemsKeyMAPelementTypeListString[elementType] != null) {
        ElementMethods.deleteElements(
          sameElementMap: allElementsMAPelementTypeStringElement[elementType],
          keyOfItemListString:
              selectedItemsKeyMAPelementTypeListString[elementType],
        );
      }
    }

    Function.apply(
      RECALCULATE_CLICKABLE_COORDINATES,
      [],
      kwargs_recalculate_clickable_coordinates,
    );
  }
}

class GridScreen {
  double gapBetweenGridPoints = 20;
  Map<double, List<PointBoolean>> gridPoints = {};
  RectangularBoundary currentScreenSize =
      RectangularBoundary.fromXYminMaxValues(
    xMinimum: 0,
    yMinimum: 0,
    xMaximum: MediaQuery.of(contextForWindowSizeProvider).size.width,
    yMaximum: MediaQuery.of(contextForWindowSizeProvider).size.height -
        appConfig.statusBar.height -
        appConfig.topBar.height -
        appConfig.topBarII.height,
  );

  GridScreen() {
    generateGridPoints(
      currentScreenSize: currentScreenSize,
      moveScreen: MoveScreen(),
    );
  }

  String get lengthOfGrid {
    int tot = 0;
    for (double keyFound in gridPoints.keys) {
      tot += gridPoints[keyFound]?.length ?? tot;
    }
    return tot.toString();
  }

  double get gapGridActual =>
      gridPoints.keys.elementAt(1) - gridPoints.keys.first;
  // void generateGridPoints({required RectangularBoundary currentScreenSize}) {
  //   this.currentScreenSize = currentScreenSize.copy;
  //   gridPoints = {};
  //   //Map of gridPoints
  //   for (double x = currentScreenSize.xMinimum + gapBetweenGridPoints / 2;
  //       x <= currentScreenSize.xMaximum - gapBetweenGridPoints / 2;
  //       x += gapBetweenGridPoints) {
  //     gridPoints[x] = [];
  //     List<PointBoolean> yPoints = [];
  //     for (double y = currentScreenSize.yMinimum + gapBetweenGridPoints / 2;
  //         y <= currentScreenSize.yMaximum - gapBetweenGridPoints / 2;
  //         y += gapBetweenGridPoints) {
  //       yPoints.add(PointBoolean(x, y));
  //     }
  //     gridPoints[x]?.addAll(yPoints);
  //   }
  //   print('GENERATED NEW GRID POINTS');
  // }

  void generateGridPoints({
    required RectangularBoundary currentScreenSize,
    required MoveScreen moveScreen,
  }) {
    this.currentScreenSize = currentScreenSize.copy;
    gridPoints = {};
    //Map of gridPoints
    for (double x = currentScreenSize.xMinimum + gapBetweenGridPoints / 2;
        x <= currentScreenSize.xMaximum - gapBetweenGridPoints / 2;
        x += gapBetweenGridPoints) {
      final keyX = MoveScreen.getGridX(x: x, moveScreen: moveScreen);
      // print('$x => $keyX ');
      gridPoints[keyX] = [];
      List<PointBoolean> yPoints = [];
      for (double y = currentScreenSize.yMinimum + gapBetweenGridPoints / 2;
          y <= currentScreenSize.yMaximum - gapBetweenGridPoints / 2;
          y += gapBetweenGridPoints) {
        yPoints.add(
          MoveScreen.getGridPoint(
              gridPoint: PointBoolean(x, y), moveScreen: moveScreen),
        );
      }
      gridPoints[keyX]?.addAll(yPoints);
    }
    // print(toString());
    print('GENERATED NEW GRID POINTS');
  }

  @override
  String toString() {
    String str = '';

    //  when grid points are a map
    for (final xFound in gridPoints.keys) {
      for (final point in gridPoints[xFound] ?? []) {
        str = '$str ${point.toString()}';
      }
      str = '$str ';
    }

    return str;
  }
}

class PropertiesSettings {
  // bool properties = false;
}

class StatusBarMessage {
  String text = 'dummy text';
}

class MoveScreen {
  PointBoolean translate = const PointBoolean.zero();
  double scale = 1;

  static rightShift(MoveScreen moveScreen) {
    moveScreen.translate = PointBoolean(
      moveScreen.translate.x + 20,
      moveScreen.translate.y,
    );
  }

  static leftShift(MoveScreen moveScreen) {
    // leftShift until x=0, cannot be shifted to x value less than 0
    // if (moveScreen.translate.x - 20 >= 0) {
    //   moveScreen.translate = PointBoolean(
    //     moveScreen.translate.x - 20,
    //     moveScreen.translate.y,
    //   );
    // }

    moveScreen.translate = PointBoolean(
      moveScreen.translate.x - 20,
      moveScreen.translate.y,
    );
  }

  static upShift(MoveScreen moveScreen) {
    //upshift has limitation that it cannot shift to y value less than 0
    // if (moveScreen.translate.y - 20 >= 0) {
    //   moveScreen.translate = PointBoolean(
    //     moveScreen.translate.x,
    //     moveScreen.translate.y - 20,
    //   );
    // }

    moveScreen.translate = PointBoolean(
      moveScreen.translate.x,
      moveScreen.translate.y - 20,
    );
  }

  static downShift(MoveScreen moveScreen) {
    moveScreen.translate = PointBoolean(
      moveScreen.translate.x,
      moveScreen.translate.y + 20,
    );
  }

  static topLeftShift(
      MoveScreen moveScreen, Map<dynamic, dynamic> allElements) {
    moveScreen.translate = ElementMethods.getTopLeft(allElements: allElements);
  }

  static zoomIn(MoveScreen moveScreen) {
    if (moveScreen.scale + 0.125 <= 2.0) {
      moveScreen.scale += 0.125;
    }
    print(moveScreen.scale);
  }

  static zoomOut(MoveScreen moveScreen) {
    if (moveScreen.scale - 0.125 >= 0.5) {
      moveScreen.scale -= 0.125;
    }
    print(moveScreen.scale);
  }

  static zoomOriginal(MoveScreen moveScreen) {
    moveScreen.scale = 1;
    print(moveScreen.scale);
  }

  static PointBoolean getTransformedPoint({
    required MoveScreen moveScreen,
    required PointBoolean originalPoint,
  }) {
    return (originalPoint - moveScreen.translate) * moveScreen.scale;
    // return (originalPoint * moveScreen.scale) - moveScreen.translate;
  }

  static PointBoolean getMousePosition({
    required MoveScreen moveScreen,
    required PointBoolean localMousePosition,
  }) {
    return localMousePosition / moveScreen.scale + moveScreen.translate;
    // return (localMousePosition - moveScreen.translate) * moveScreen.scale;
    // return (localMousePosition + moveScreen.translate) / moveScreen.scale;
  }

  static PointBoolean getGridPoint(
      {required PointBoolean gridPoint, required MoveScreen moveScreen}) {
    return moveScreen.translate + gridPoint / moveScreen.scale;
    // return (gridPoint + moveScreen.translate) / moveScreen.scale;
  }

  static double getGridX({required double x, required MoveScreen moveScreen}) {
    return moveScreen.translate.x + x / moveScreen.scale;
    // return (x + moveScreen.translate.x) / moveScreen.scale;
  }
}

class ButtonConstantPress {
  bool moveScreenRightConstantlyPressed = false;
  bool moveScreenLeftConstantlyPressed = false;
  bool moveScreenUpConstantlyPressed = false;
  bool moveScreenDownConstantlyPressed = false;
  bool zoomInConstantlyPressed = false;
  bool zoomOutConstantlyPressed = false;
  bool shiftPressedScreen = false;
  bool ctrlPressedScreen = false;

  /// makes shiftPressedScreen to true
  void shiftPressedScreenPointerDown_() {
    shiftPressedScreen = true;
  }

  /// makes shiftPressedScreen to false
  void shiftPressedScreenPointerUp_() {
    shiftPressedScreen = false;
  }

  /// makes ctrlPressedScreen to true
  void ctrlPressedScreenPointerDown_() {
    ctrlPressedScreen = true;
  }

  /// makes ctrlPressedScreen to false
  void ctrlPressedScreenPointerUp_() {
    ctrlPressedScreen = false;
  }

  //move screen right
  void moveScreenRightButtonPointerDown_() {
    moveScreenRightConstantlyPressed = true;
  }

  void moveScreenRightButtonConstantPressOperation_(
      MoveScreen moveScreen) async {
    while (moveScreenRightConstantlyPressed) {
      MoveScreen.rightShift(moveScreen);
      CanvasMovementCallback.update_after_each_canvas_movement_click();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void moveScreenRightButtonPointerUp_() {
    moveScreenRightConstantlyPressed = false;
  }

  //move screen left
  void moveScreenLeftButtonPointerDown_() {
    moveScreenLeftConstantlyPressed = true;
  }

  void moveScreenLeftButtonConstantPressOperation_(
      MoveScreen moveScreen) async {
    while (moveScreenLeftConstantlyPressed) {
      MoveScreen.leftShift(moveScreen);
      CanvasMovementCallback.update_after_each_canvas_movement_click();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void moveScreenLeftButtonPointerUp_() {
    moveScreenLeftConstantlyPressed = false;
  }

  //move screen up
  void moveScreenUpButtonPointerDown_() {
    moveScreenUpConstantlyPressed = true;
  }

  void moveScreenUpButtonConstantPressOperation_(MoveScreen moveScreen) async {
    while (moveScreenUpConstantlyPressed) {
      MoveScreen.upShift(moveScreen);
      CanvasMovementCallback.update_after_each_canvas_movement_click();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void moveScreenUpButtonPointerUp_() {
    moveScreenUpConstantlyPressed = false;
  }

  //move screen down
  void moveScreenDownButtonPointerDown_() {
    moveScreenDownConstantlyPressed = true;
  }

  void moveScreenDownButtonConstantPressOperation_(
      MoveScreen moveScreen) async {
    while (moveScreenDownConstantlyPressed) {
      MoveScreen.downShift(moveScreen);
      CanvasMovementCallback.update_after_each_canvas_movement_click();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void moveScreenDownButtonPointerUp_() {
    moveScreenDownConstantlyPressed = false;
  }

  //zoom in
  void zoomInScreenButtonPointerDown_() {
    zoomInConstantlyPressed = true;
  }

  void zoomInScreenButtonConstantPressOperation_(MoveScreen moveScreen) async {
    while (zoomInConstantlyPressed) {
      MoveScreen.zoomIn(moveScreen);
      CanvasMovementCallback.update_after_each_canvas_movement_click();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void zoomInButtonPointerUp_() {
    zoomInConstantlyPressed = false;
  }

  //zoom out
  void zoomOutScreenButtonPointerDown_() {
    zoomOutConstantlyPressed = true;
  }

  void zoomOutScreenButtonConstantPressOperation_(MoveScreen moveScreen) async {
    while (zoomOutConstantlyPressed) {
      MoveScreen.zoomOut(moveScreen);
      CanvasMovementCallback.update_after_each_canvas_movement_click();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void zoomOutButtonPointerUp_() {
    zoomOutConstantlyPressed = false;
  }
}

class ColorPickerData {
  // Color existingColor = Colors.yellow;
  // Color newColor = Colors.orange;

  // void colorTapped(Color color) {
  //   newColor = color;
  //   CallbackScreenEditing.colorPickerHasUpdated();
  // }

  static void genericColorPickerDialog_({
    required dynamic element,
    required ElementType ELEMENT_TYPE,
    required DialogBoxConfiguration CONFIG,
    required String PROPERTY_STRING,
    int RECORD_KEY = 0,
  }) {
    Color EXISTING_COLOR = getExistingColor(
      ELEMENT_TYPE: ELEMENT_TYPE,
      element: element,
      PROPERTY_STRING: PROPERTY_STRING,
      RECORD_KEY: RECORD_KEY,
    );

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
                    updateColor_(
                      element: element,
                      NEW_COLOR: color,
                      ELEMENT_TYPE: ELEMENT_TYPE,
                      PROPERTY_STRING: PROPERTY_STRING,
                      RECORD_KEY: RECORD_KEY,
                    );
                    // colorPickerData.colorTapped(color);

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

  static Color getExistingColor({
    required ElementType ELEMENT_TYPE,
    required dynamic element,
    required String PROPERTY_STRING,
    int RECORD_KEY = 0,
  }) {
    if (ELEMENT_TYPE == ElementType.multiText) {
      if (PROPERTY_STRING == 'text color') {
        return element.records[RECORD_KEY].colorForeGround;
      }
      if (PROPERTY_STRING == 'background color') {
        return element.records[RECORD_KEY].colorBackGround;
      }
    }
    return Colors.yellow;
  }

  static void updateColor_({
    required dynamic element,
    required Color NEW_COLOR,
    required ElementType ELEMENT_TYPE,
    required String PROPERTY_STRING,
    int RECORD_KEY = 0,
  }) {
    if (ELEMENT_TYPE == ElementType.multiText) {
      updateMultiTextBoolean_(
        multiTextBoolean: element,
        RECORD_KEY: RECORD_KEY,
        PROPERTY_STRING: PROPERTY_STRING,
        NEW_COLOR: NEW_COLOR,
      );
    }

    CallbackScreenEditing.colorPickerHasUpdated();
  }

  static void updateMultiTextBoolean_({
    required MultiTextBoolean multiTextBoolean,
    required int RECORD_KEY,
    required String PROPERTY_STRING,
    required Color NEW_COLOR,
  }) {
    if (PROPERTY_STRING == 'text color' ||
        PROPERTY_STRING == 'background color') {
      Map<int, Map<String, Map<Property, dynamic>>> PROPERTY_MAP = {
        RECORD_KEY: {
          PROPERTY_STRING: {Property.value: NEW_COLOR}
        }
      };
      multiTextBoolean.updateProperty(PROPERTY_MAP);
    }
  }
}
