// import 'package:simple_hmi/data/app_data.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/classes/input_elements.dart';
import 'package:simple_hmi/data/user_interface_data.dart';
// import '/classes/class_extensions.dart';
import '/classes/enumerations.dart';
import '/classes/logic_blocks.dart';

///When an element is created, moved, copied or rotated, edited, or
///clickable element is updated
///- map containing coordinates and elementType and key is updated
class ClickableCoordinates {
  Map<double, Map<double, ({ElementType elementType, String key})>>
      coordinates = {};

  static Set<ElementType> ELEMENTS_HAVING_USER_INPUT = {
    ElementType.multiTextButton,
  };
}

class ClickableCoordinatesOperations {
  static void update({
    required ClickableCoordinates data,
    required Map<dynamic, dynamic> ALL_SCREEN_ELEMENTS,
    required ElementType ELEMENT_TYPE,
    required String KEY,
    required double GRID_GAP,
  }) {
    //which clickable item is entered
    //  all points with gridGap is added to coordinates
    Map<double, Map<double, bool>> m = ALL_SCREEN_ELEMENTS[ELEMENT_TYPE][KEY]
        .getClickableCoordinates(GRID_GAP);

    for (double x in m.keys) {
      for (double y in m[x]!.keys) {
        data.coordinates[x] = {};
        data.coordinates[x]![y] = (elementType: ELEMENT_TYPE, key: KEY);
      }
    }
  }

  static ({ElementType elementType, dynamic key})?
      GET_ELEMENT_DETAILS_ON_CLICK({
    required ClickableCoordinates CLICKABLE_COORDINATES,
    required CreateParameters CREATE_PARAMETERS,
    required ItemBeingEdited EDITED,
    required ItemsBeingMoved MOVED,
    required ItemsBeingCopied COPIED,
    required ItemsBeingRotated ROTATED,
    required SelectParameters SELECT_PARAMETERS,
    required Map<dynamic, dynamic> ALL_ELEMENTS,
    required PointBoolean CURRENT_MOUSE_POSITION,
    required double GRID_GAP,
  }) {
    bool CONDITION_WHEN_CLICK_WILL_NOT_TRIGGER_USER_INPUT =
        CREATE_PARAMETERS.waitingForFirstPoint ||
            CREATE_PARAMETERS.waitingForFirstPoint ||
            CREATE_PARAMETERS.arePointsAvailableForCreationStarting ||
            CREATE_PARAMETERS.arePointsReadyForCompletion ||
            EDITED.editingUnderProgress ||
            MOVED.itemsMovementInProgressFlag ||
            MOVED.waitingForFirstPoint ||
            MOVED.waitingForSecondPoint ||
            COPIED.multipleCopyInProgress ||
            COPIED.waitingForFirstPoint ||
            COPIED.waitingForSecondPoint ||
            ROTATED.waitingForCentre ||
            ROTATED.waitingForFrom ||
            ROTATED.waitingForTo ||
            SELECT_PARAMETERS.isSelectionRectangleStillChanging;

    if (CONDITION_WHEN_CLICK_WILL_NOT_TRIGGER_USER_INPUT) {
      return null;
    } else {
      double X = (CURRENT_MOUSE_POSITION.x ~/ GRID_GAP) * GRID_GAP;
      double Y = (CURRENT_MOUSE_POSITION.y ~/ GRID_GAP) * GRID_GAP;

      return CLICKABLE_COORDINATES.coordinates[X]?[Y];
      // final ELEMENT_TYPE = record!.elementType;
      // final KEY = record.key.copy;
      // return (elementType: ELEMENT_TYPE, key: KEY);
    }
  }

  static Map<double, Map<double, bool>>
      GET_CLICKABLE_COORDINATES_FROM_RECTANGLE({
    required double WIDTH,
    required double HEIGHT,
    required PointBoolean PIVOT_POINT,
    required double GRID_GAP,
    required double ANGLE_RADIANS,
  }) {
    Map<double, Map<double, bool>> m = {};

    for (double x = 0; x < WIDTH; x += GRID_GAP) {
      for (double y = 0; y < HEIGHT; y += GRID_GAP) {
        PointBoolean p =
            PointBoolean(x, y).rotated(ANGLE_RADIANS) + PIVOT_POINT;
        m[GET_FLOOR_VALUE(p.x, GRID_GAP)] = {};
        m[GET_FLOOR_VALUE(p.x, GRID_GAP)]![GET_FLOOR_VALUE(p.y, GRID_GAP)] =
            true;
      }
    }

    return m;
  }

  static double GET_FLOOR_VALUE(double ORDINATE, double GRID_GAP) =>
      (ORDINATE ~/ GRID_GAP) * GRID_GAP;

  static void recalculateCoordinates({
    required ClickableCoordinates clickableCoordinates,
    required Map<dynamic, dynamic> ALL_ELEMENTS,
    required double GRID_GAP,
  }) {
    clickableCoordinates.coordinates = {};

    for (var elementType in ClickableCoordinates.ELEMENTS_HAVING_USER_INPUT) {
      for (dynamic key in ALL_ELEMENTS[elementType].keys) {
        update(
          data: clickableCoordinates,
          ALL_SCREEN_ELEMENTS: ALL_ELEMENTS,
          ELEMENT_TYPE: elementType,
          KEY: key,
          GRID_GAP: GRID_GAP,
        );
      }
    }
  }
}

class OutputPort {
  static const PORT_TYPE_VS_STRING = {
    PortType.boolean: 'boolean',
    PortType.integer: 'integer',
    PortType.real: 'real',
    PortType.doubleInteger: 'doubleInteger'
  };
  String label = '';
  List<PortType> portType = [];
  dynamic value;

  OutputPort({String? label, List<PortType>? portType, dynamic value}) {
    this.label = label ?? this.label;
    // this.portType = portType ?? this.portType;
    this.value = value ?? this.value;

    if (portType != null) {
      List<PortType> newPortType = [];
      for (var portTypeElem in portType) {
        newPortType.add(portTypeElem);
      }
      this.portType = newPortType;
    }
  }

  OutputPort get copy {
    return OutputPort(label: label, portType: portType, value: value.copy);
  }

  void updateValue(dynamic value) {
    this.value = value.copy;
  }

  Map GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING() {
    List<String> li = [];

    for (var port in portType) {
      String? PORT_AS_STRING = PORT_TYPE_VS_STRING[port];
      if (PORT_AS_STRING != null) {
        li.add(PORT_AS_STRING);
      }
    }

    return {
      'label': label.toString(),
      'portType': li,
      'value': value.toString(),
    };
  }

  static OutputPort BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
      Map m) {
    String label = m['label'];

    List<PortType> portTypes = [];
    for (String portTypeAsString in m['portType']) {
      switch (portTypeAsString) {
        case 'boolean':
          portTypes.add(PortType.boolean);
          break;
        case 'integer':
          portTypes.add(PortType.integer);
          break;
        case 'doubleInteger':
          portTypes.add(PortType.doubleInteger);
          break;
        case 'real':
          portTypes.add(PortType.real);
          break;
        default:
      }
    }

    dynamic value;
    switch (m['value']) {
      case 'true':
        value = true;
        break;
      case 'false':
        value = false;
        break;
      default:
        value = m['value'];
        if (value.contains('.')) {
          value = double.parse(value);
        } else {
          value = int.parse(value);
        }
    }

    return OutputPort(label: label, portType: portTypes, value: value);
  }
}

class InputPort {
  static const Map<PortType, String> portTypeVsString = {
    PortType.boolean: 'boolean',
    PortType.integer: 'integer',
    PortType.real: 'real',
    PortType.doubleInteger: 'doubleInteger',
  };
  String label = '';
  List<PortType> portType = [];
  dynamic value;

  InputPort({String? label, List<PortType>? portType, dynamic value}) {
    this.label = label ?? this.label;
    this.value = value ?? this.value;

    if (portType != null) {
      List<PortType> newPortType = [];

      for (var portTypeElem in portType) {
        newPortType.add(portTypeElem);
      }

      this.portType = newPortType;
    }
  }

  InputPort get copy {
    return InputPort(label: label, portType: portType, value: value.copy);
  }

  Map GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING() {
    List listOfPortTypeString = [];
    for (var port in portType) {
      String? portTypeString = portTypeVsString[port];
      if (portTypeString != null) {
        listOfPortTypeString.add(portTypeString);
      }
    }
    return {
      'label': label,
      'portType': listOfPortTypeString,
      'value': value.toString(),
    };
  }

  static InputPort BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
      Map m) {
    dynamic value;
    switch (m['value']) {
      case 'true':
        value = true;
        break;
      case 'false':
        value = false;
        break;
      default:
        value = m['value'];
        if (value.contains('.')) {
          value = double.parse(value);
        } else {
          value = int.parse(value);
        }
    }

    List<PortType> portTypes = [];
    for (String portTypeAsString in m['portType']) {
      switch (portTypeAsString) {
        case 'boolean':
          portTypes.add(PortType.boolean);
          break;
        case 'integer':
          portTypes.add(PortType.integer);
          break;
        case 'doubleInteger':
          portTypes.add(PortType.doubleInteger);
          break;
        case 'real':
          portTypes.add(PortType.real);
          break;
        default:
      }
    }

    return InputPort(
      label: m['label'],
      portType: portTypes,
      value: value,
    );
  }
}

class PortMethods {
  static Type DATA_TYPE_OF(PortType portType) {
    switch (portType) {
      case PortType.boolean:
        return bool;
      default:
        return Null;
    }
  }
}

class Link {}

class RequestFromUi {
  // final BlockIdentifier _BLOCK_IDENTIFIER;
  final Type _TYPE_OF_UI_ELEMENT;
  final String _KEY_OF_UI_ELEMENT;
  final int _OUTPUT_PORT_INDEX;

  /// bool or int or double
  final dynamic _VALUE;

  const RequestFromUi._(
    this._TYPE_OF_UI_ELEMENT,
    this._KEY_OF_UI_ELEMENT,
    this._OUTPUT_PORT_INDEX,
    this._VALUE,
  );

  static RequestFromUi CREATE_FROM_BOOL({
    required Type TYPE_OF_UI_ELEMENT,
    required String KEY_OF_UI_ELEMENT,
    required int OUTPUT_PORT_INDEX,
    required bool BOOLEAN_VALUE,
  }) =>
      RequestFromUi._(TYPE_OF_UI_ELEMENT, KEY_OF_UI_ELEMENT, OUTPUT_PORT_INDEX,
          BOOLEAN_VALUE);

  static RequestFromUi CREATE_FROM_INT({
    required Type TYPE_OF_UI_ELEMENT,
    required String KEY_OF_UI_ELEMENT,
    required int OUTPUT_PORT_INDEX,
    required int INT_VALUE,
  }) =>
      RequestFromUi._(TYPE_OF_UI_ELEMENT, KEY_OF_UI_ELEMENT, OUTPUT_PORT_INDEX,
          Integer.FROM_INT(INT_VALUE));

  Type get TYPE_OF_UI_ELEMENT => _TYPE_OF_UI_ELEMENT;
  String get KEY_OF_UI_ELEMENT => _KEY_OF_UI_ELEMENT;
  int get OUTPUT_PORT_INDEX => _OUTPUT_PORT_INDEX;

  /// VALUE is having either one of these types:
  /// - bool
  /// - int
  /// - double
  dynamic get VALUE => _VALUE;
}

class ResponseToUi {
  final Type TYPE_OF_UI_ELEMENT;
  final String KEY_OF_UI_ELEMENT;
  final int INPUT_PORT_INDEX;

  ///bool or int or double
  final dynamic VALUE;

  const ResponseToUi._(
    this.TYPE_OF_UI_ELEMENT,
    this.KEY_OF_UI_ELEMENT,
    this.INPUT_PORT_INDEX,
    this.VALUE,
  );

  static ResponseToUi CREATE_FROM_BOOL({
    required Type TYPE_OF_UI_ELEMENT,
    required String KEY_OF_UI_ELEMENT,
    required int INPUT_PORT_INDEX,
    required bool VALUE,
  }) {
    return ResponseToUi._(
      TYPE_OF_UI_ELEMENT,
      KEY_OF_UI_ELEMENT,
      INPUT_PORT_INDEX,
      VALUE,
    );
  }

  static ResponseToUi CREATE_FROM_INT({
    required Type TYPE_OF_UI_ELEMENT,
    required String KEY_OF_UI_ELEMENT,
    required int INPUT_PORT_INDEX,
    required int VALUE,
  }) {
    return ResponseToUi._(
      TYPE_OF_UI_ELEMENT,
      KEY_OF_UI_ELEMENT,
      INPUT_PORT_INDEX,
      VALUE,
    );
  }
}
