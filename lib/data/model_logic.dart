import 'dart:isolate';
import 'package:simple_hmi/classes/modbus_master_isolate.dart';
import 'package:simple_hmi/data/user_interface_data.dart';
import 'dart:convert';
import 'package:simple_hmi/classes/logic_blocks.dart';
import '/classes/logic_part.dart';
import 'dart:collection';
import '/classes/elements.dart';
import '/classes/input_elements.dart';
import 'package:flutter/material.dart';

var config = LogicPageConfig();

class LogicPageConfig {
  var _backgroundUnselectedTopBarII = const Color.fromARGB(255, 70, 70, 70);
  var _backgroundSelectedTopBarII = const Color.fromARGB(255, 40, 40, 40);
  var _fontColorUnselectedTopBarII = const Color.fromARGB(255, 230, 230, 230);
  var _fontColorSelectedTopBarII = const Color.fromARGB(255, 255, 255, 0);
  var _fontColorDisabledTopBarII = const Color.fromARGB(100, 150, 150, 150);
  var _separatorTopBarII = const Color.fromARGB(100, 150, 150, 150);
  var _scrollBarColorTopBarII = const Color.fromARGB(150, 115, 115, 130);
  double _scrollBarThicknessTopBarII = 4;
  double _heightTopBarII = 50;
  double _heightIconTopBarII = 50;
  double _widthIconTopBarII = 50;
  Duration _toolTipWaitDuration = const Duration(seconds: 1);
  double _widthOfSideBar = 300;

  Color TOPBAR_II_BACKGROUND_UNSELECTED() => _backgroundUnselectedTopBarII;
  Color TOBBAR_II_BACKGROUND_SELECTED() => _backgroundSelectedTopBarII;
  Color TOPBAR_II_FONT_COLOR_UNSELECTED() => _fontColorUnselectedTopBarII;
  Color TOPBAR_II_FONT_COLOR_SELECTED() => _fontColorSelectedTopBarII;
  Color TOPBAR_II_FONT_COLOR_DISABLED() => _fontColorDisabledTopBarII;
  Color TOPBAR_II_SEPARATOR_COLOR() => _separatorTopBarII;
  Color TOPBAR_II_SCROLLBAR_COLOR() => _scrollBarColorTopBarII;
  double TOPBAR_II_SCROLLBAR_THICKNESS() => _scrollBarThicknessTopBarII;
  double TOPBAR_II_HEIGHT() => _heightTopBarII;
  double TOPBAR_II_ICON_HEIGHT() => _heightIconTopBarII;
  double TOPBAR_II_ICON_WIDTH() => _widthIconTopBarII;
  Duration TOPBAR_II_TOOLTIP_WAIT_DURATION() => _toolTipWaitDuration;
  double SIDEBAR_WIDTH() => _widthOfSideBar;
  Color SIDEBAR_COLOR() => _backgroundUnselectedTopBarII;

  void toggleTheme() {}
}

class CanvasMovement {
  double _translateXstep = 2;
  double _translateYstep = 2;
  double _zoomStep = 0.125;
  double _zoomMax = 2;
  double _zoomMin = 0.5;
  PointBoolean _topLeft = const PointBoolean.zero();
  double _zoom = 1.0;
  double _translateX = 0;
  double _translateY = 0;
}

class ValueRequestFromUi {
  final bool? BOOLEAN_VALUE;
  final int? INTEGER_VALUE;
  final double? DOUBLE_VALUE;

  const ValueRequestFromUi._(
      this.BOOLEAN_VALUE, this.INTEGER_VALUE, this.DOUBLE_VALUE);

  static ValueRequestFromUi fromBoolean(bool BOOLEAN) {
    return ValueRequestFromUi._(BOOLEAN, null, null);
  }

  static ValueRequestFromUi fromInteger(int INTEGER) {
    return ValueRequestFromUi._(null, INTEGER, null);
  }

  static ValueRequestFromUi fromDouble(double DOUBLE) {
    return ValueRequestFromUi._(null, null, DOUBLE);
  }

  T GET_VALUE<T extends bool, int, double>() {
    dynamic VAL;

    if (BOOLEAN_VALUE != null) {
      VAL = BOOLEAN_VALUE;
    } else if (INTEGER_VALUE != null) {
      VAL = INTEGER_VALUE;
    } else {
      VAL = DOUBLE_VALUE;
    }

    return VAL;
  }
}

class ModelLogic {
  static const SIZE_LIMIT_QUEUE_UI = 5000;
  bool _logicIsolateIsReadyForReception = false;
  late final SendPort _sendPort;
  final _requestsQueueUi = Queue<
      ({
        Type elementDataType,
        String keyOfElement,
        int keyOfOutputPort,
        ValueRequestFromUi valueRequestFromUi
      })>();

  void enqueueRequestsFromUi(
    ({
      Type elementDataType,
      String keyOfElement,
      int keyOfOutputPort,
      ValueRequestFromUi valueRequestFromUi
    }) requestFromUi,
  ) {
    if (_requestsQueueUi.length >= ModelLogic.SIZE_LIMIT_QUEUE_UI) {
      _requestsQueueUi.removeFirst();
    }
    if (_logicIsolateIsReadyForReception) {
      _requestsQueueUi.addLast(requestFromUi);
    }
  }

  void _processRequestsFromUi() {
    for (var request in _requestsQueueUi) {
      Type TYPE = request.valueRequestFromUi.GET_VALUE().runtimeType;
      switch (TYPE) {
        case bool:
          _sendPort.send(
            RequestFromUi.CREATE_FROM_BOOL(
              TYPE_OF_UI_ELEMENT: request.elementDataType,
              KEY_OF_UI_ELEMENT: request.keyOfElement,
              OUTPUT_PORT_INDEX: request.keyOfOutputPort,
              BOOLEAN_VALUE: request.valueRequestFromUi.GET_VALUE(),
            ),
          );
          break;
        case int:
          _sendPort.send(
            RequestFromUi.CREATE_FROM_INT(
              TYPE_OF_UI_ELEMENT: request.elementDataType,
              KEY_OF_UI_ELEMENT: request.keyOfElement,
              OUTPUT_PORT_INDEX: request.keyOfOutputPort,
              INT_VALUE: request.valueRequestFromUi.GET_VALUE(),
            ),
          );
          break;
        default:
          throw Exception(
              '${request.valueRequestFromUi.GET_VALUE().runtimeType} type could'
              ' not be send via sendport of main isolate');
      }
    }
    _requestsQueueUi.clear();
  }
}

class Blocks {
  final Map<Type, Map<int, dynamic>> _typeKeyBlock = {};

  final Map<(Type, String), BlockIdentifier> _tableOfuiLocationVsBlockLocation =
      {};

  final Map<String, dynamic> _modbusStringVsObject = {};

  Map<Type, Map<int, dynamic>> getReferenceTypeVsKeyVsBlock() {
    return _typeKeyBlock;
  }

  void insertBlock({
    required dynamic SINGLE_BLOCK,
  }) {
    final List<int>? ALL_KEYS =
        _typeKeyBlock[SINGLE_BLOCK.runtimeType]?.keys.toList();
    int newKey;
    //finding new key
    if (ALL_KEYS == null) {
      _typeKeyBlock[SINGLE_BLOCK.runtimeType] = {};
      newKey = 0;
    } else {
      newKey = ALL_KEYS[0];
      for (var i in ALL_KEYS) {
        if (i > newKey) {
          newKey = i;
        }
      }
      ++newKey;
    }
    _typeKeyBlock[SINGLE_BLOCK.runtimeType]![newKey] = SINGLE_BLOCK.copy;
  }

  void deleteBlock({
    required Type OF_TYPE,
    required int AT_KEY,
  }) {
    _typeKeyBlock[OF_TYPE]?.remove(AT_KEY);
  }

  /// [ {'type':'And', 'key':'1','json':'alsalmsals' }   ]
  List<String> GET_LIST_OF_JSON() {
    List<String> listOfJson = [];
    for (Type type in _typeKeyBlock.keys) {
      for (int key in _typeKeyBlock[type]!.keys) {
        Map typeKeyjson = {
          'type': _typeKeyBlock[type]![key].runtimeType.toString(),
          'key': key.toString(),
          'json': _typeKeyBlock[type]![key].JSON(),
        };
        String jsonFile = jsonEncode(typeKeyjson);
        listOfJson.add(jsonFile);
      }
    }
    return listOfJson;
  }

  // void buildFromListOfJson(List<String> LIST_OF_JSON) {
  //   _typeKeyBlock.clear();
  //   for (final JSON_FILE in LIST_OF_JSON) {
  //     final Map TYPE_KEY_JSON = jsonDecode(JSON_FILE);
  //     final String TYPE = TYPE_KEY_JSON['type'];
  //     final int KEY = TYPE_KEY_JSON['key'];
  //     final String LOGIC_BLOCK_JSON = TYPE_KEY_JSON['json'];
  //     dynamic BLOCK_OBJECT;
  //     switch (TYPE) {
  //       case 'And':
  //         BLOCK_OBJECT = And.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Or':
  //         BLOCK_OBJECT = Or.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Xor':
  //         BLOCK_OBJECT = Xor.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Not':
  //         BLOCK_OBJECT = Not.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ResetSet':
  //         BLOCK_OBJECT = ResetSet.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SetReset':
  //         BLOCK_OBJECT = SetReset.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'FallingEdgeDetector':
  //         BLOCK_OBJECT = FallingEdgeDetector.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'RisingEdgeDetector':
  //         BLOCK_OBJECT = RisingEdgeDetector.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'PriorityEncoder':
  //         BLOCK_OBJECT = PriorityEncoder.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'BinaryMux':
  //         BLOCK_OBJECT = BinaryMux.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'AnalogMux':
  //         BLOCK_OBJECT = AnalogMux.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SetResetAnalog':
  //         BLOCK_OBJECT = SetResetAnalog.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ResetSetAnalog':
  //         BLOCK_OBJECT = ResetSetAnalog.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CompareLessThan':
  //         BLOCK_OBJECT = CompareLessThan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CompareLessThanEqualTo':
  //         BLOCK_OBJECT =
  //             CompareLessThanEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CompareGreaterThan':
  //         BLOCK_OBJECT = CompareGreaterThan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CompareGreaterThanEqualTo':
  //         BLOCK_OBJECT =
  //             CompareGreaterThanEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CompareEqualTo':
  //         BLOCK_OBJECT = CompareEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CompareNotEqualTo':
  //         BLOCK_OBJECT = CompareNotEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourceBooleanFalse':
  //         BLOCK_OBJECT = SourceBooleanFalse.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourceBooleanTrue':
  //         BLOCK_OBJECT = SourceBooleanTrue.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourceInteger':
  //         BLOCK_OBJECT = SourceInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourceDoubleInteger':
  //         BLOCK_OBJECT = SourceDoubleInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourceReal':
  //         BLOCK_OBJECT = SourceReal.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourceExponent':
  //         BLOCK_OBJECT = SourceExponent.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SourcePi':
  //         BLOCK_OBJECT = SourcePi.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ConvertToInteger':
  //         BLOCK_OBJECT = ConvertToInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ConvertToDoubleInteger':
  //         BLOCK_OBJECT =
  //             ConvertToDoubleInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ConvertToReal':
  //         BLOCK_OBJECT = ConvertToReal.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Add':
  //         BLOCK_OBJECT = Add.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Subtract':
  //         BLOCK_OBJECT = Subtract.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Multiply':
  //         BLOCK_OBJECT = Multiply.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Divide':
  //         BLOCK_OBJECT = Divide.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Remainder':
  //         BLOCK_OBJECT = Remainder.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Exponent':
  //         BLOCK_OBJECT = Exponent.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Log':
  //         BLOCK_OBJECT = Log.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'SquareRoot':
  //         BLOCK_OBJECT = SquareRoot.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Sin':
  //         BLOCK_OBJECT = Sin.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Cos':
  //         BLOCK_OBJECT = Cos.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Tan':
  //         BLOCK_OBJECT = Tan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Asin':
  //         BLOCK_OBJECT = Asin.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Acos':
  //         BLOCK_OBJECT = Acos.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Atan':
  //         BLOCK_OBJECT = Atan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'Counter':
  //         BLOCK_OBJECT = Counter.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'PWM':
  //         BLOCK_OBJECT = PWM.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'OnDelayTimer':
  //         BLOCK_OBJECT = OnDelayTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'OffDelayTimer':
  //         BLOCK_OBJECT = OffDelayTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'RetentiveOnDelayTimer':
  //         BLOCK_OBJECT =
  //             RetentiveOnDelayTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'PulseTimer':
  //         BLOCK_OBJECT = PulseTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ExtendedPulseTimer':
  //         BLOCK_OBJECT = ExtendedPulseTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'BufferInput':
  //         BLOCK_OBJECT = BufferInput.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'BufferValue':
  //         BLOCK_OBJECT = BufferValue.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'LineBooleanInputBlock':
  //         BLOCK_OBJECT =
  //             LineBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'RectangleBooleanInputBlock':
  //         BLOCK_OBJECT =
  //             RectangleBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'CircleBooleanInputBlock':
  //         BLOCK_OBJECT =
  //             CircleBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'TextBooleanInputBlock':
  //         BLOCK_OBJECT =
  //             TextBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'MultiTextBooleanInputBlock':
  //         BLOCK_OBJECT =
  //             MultiTextBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'MultiTextButtonInputBlock':
  //         BLOCK_OBJECT =
  //             MultiTextButtonInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'MultiTextButtonOutputBlock':
  //         BLOCK_OBJECT =
  //             MultiTextButtonOutputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ModbusTcpReadBooleanBlock':
  //         BLOCK_OBJECT =
  //             ModbusTcpReadBooleanBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ModbusTcpWriteBooleanBlock':
  //         BLOCK_OBJECT =
  //             ModbusTcpWriteBooleanBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       case 'ModbusTcpWriteBooleanErrorBlock':
  //         BLOCK_OBJECT =
  //             ModbusTcpWriteBooleanErrorBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
  //         break;
  //       default:
  //         throw Exception('Could not build object of type $TYPE from json');
  //     }
  //     _insertAtKey(KEY, BLOCK_OBJECT);
  //   }
  //   _updateTableOfuiLocationVsBlockLocation();
  //   assignReferenceOfAllBufferValueToBufferValueBlocks();
  //   assignReferenceOfAllModbusErrorToModbusWriteBlocks();
  // }

  static Blocks BUILD_FROM_LIST_OF_JSON(List<String> LIST_OF_JSON) {
    var blocks = Blocks();

    for (final JSON_FILE in LIST_OF_JSON) {
      final Map TYPE_KEY_JSON = jsonDecode(JSON_FILE);
      final String TYPE = TYPE_KEY_JSON['type'];
      final int KEY = TYPE_KEY_JSON['key'];
      final String LOGIC_BLOCK_JSON = TYPE_KEY_JSON['json'];

      dynamic BLOCK_OBJECT;
      switch (TYPE) {
        case 'And':
          BLOCK_OBJECT = And.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Or':
          BLOCK_OBJECT = Or.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Xor':
          BLOCK_OBJECT = Xor.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Not':
          BLOCK_OBJECT = Not.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ResetSet':
          BLOCK_OBJECT = ResetSet.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SetReset':
          BLOCK_OBJECT = SetReset.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'FallingEdgeDetector':
          BLOCK_OBJECT = FallingEdgeDetector.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'RisingEdgeDetector':
          BLOCK_OBJECT = RisingEdgeDetector.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'PriorityEncoder':
          BLOCK_OBJECT = PriorityEncoder.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'BinaryMux':
          BLOCK_OBJECT = BinaryMux.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'AnalogMux':
          BLOCK_OBJECT = AnalogMux.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SetResetAnalog':
          BLOCK_OBJECT = SetResetAnalog.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ResetSetAnalog':
          BLOCK_OBJECT = ResetSetAnalog.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CompareLessThan':
          BLOCK_OBJECT = CompareLessThan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CompareLessThanEqualTo':
          BLOCK_OBJECT =
              CompareLessThanEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CompareGreaterThan':
          BLOCK_OBJECT = CompareGreaterThan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CompareGreaterThanEqualTo':
          BLOCK_OBJECT =
              CompareGreaterThanEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CompareEqualTo':
          BLOCK_OBJECT = CompareEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CompareNotEqualTo':
          BLOCK_OBJECT = CompareNotEqualTo.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourceBooleanFalse':
          BLOCK_OBJECT = SourceBooleanFalse.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourceBooleanTrue':
          BLOCK_OBJECT = SourceBooleanTrue.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourceInteger':
          BLOCK_OBJECT = SourceInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourceDoubleInteger':
          BLOCK_OBJECT = SourceDoubleInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourceReal':
          BLOCK_OBJECT = SourceReal.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourceExponent':
          BLOCK_OBJECT = SourceExponent.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SourcePi':
          BLOCK_OBJECT = SourcePi.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ConvertToInteger':
          BLOCK_OBJECT = ConvertToInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ConvertToDoubleInteger':
          BLOCK_OBJECT =
              ConvertToDoubleInteger.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ConvertToReal':
          BLOCK_OBJECT = ConvertToReal.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Add':
          BLOCK_OBJECT = Add.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Subtract':
          BLOCK_OBJECT = Subtract.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Multiply':
          BLOCK_OBJECT = Multiply.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Divide':
          BLOCK_OBJECT = Divide.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Remainder':
          BLOCK_OBJECT = Remainder.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Exponent':
          BLOCK_OBJECT = Exponent.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Log':
          BLOCK_OBJECT = Log.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'SquareRoot':
          BLOCK_OBJECT = SquareRoot.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Sin':
          BLOCK_OBJECT = Sin.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Cos':
          BLOCK_OBJECT = Cos.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Tan':
          BLOCK_OBJECT = Tan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Asin':
          BLOCK_OBJECT = Asin.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Acos':
          BLOCK_OBJECT = Acos.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Atan':
          BLOCK_OBJECT = Atan.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'Counter':
          BLOCK_OBJECT = Counter.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'PWM':
          BLOCK_OBJECT = PWM.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'OnDelayTimer':
          BLOCK_OBJECT = OnDelayTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'OffDelayTimer':
          BLOCK_OBJECT = OffDelayTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'RetentiveOnDelayTimer':
          BLOCK_OBJECT =
              RetentiveOnDelayTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'PulseTimer':
          BLOCK_OBJECT = PulseTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ExtendedPulseTimer':
          BLOCK_OBJECT = ExtendedPulseTimer.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'BufferInput':
          BLOCK_OBJECT = BufferInput.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'BufferValue':
          BLOCK_OBJECT = BufferValue.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'LineBooleanInputBlock':
          BLOCK_OBJECT =
              LineBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'RectangleBooleanInputBlock':
          BLOCK_OBJECT =
              RectangleBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'CircleBooleanInputBlock':
          BLOCK_OBJECT =
              CircleBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'TextBooleanInputBlock':
          BLOCK_OBJECT =
              TextBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'MultiTextBooleanInputBlock':
          BLOCK_OBJECT =
              MultiTextBooleanInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'MultiTextButtonInputBlock':
          BLOCK_OBJECT =
              MultiTextButtonInputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'MultiTextButtonOutputBlock':
          BLOCK_OBJECT =
              MultiTextButtonOutputBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ModbusTcpReadBooleanBlock':
          BLOCK_OBJECT =
              ModbusTcpReadBooleanBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ModbusTcpWriteBooleanBlock':
          BLOCK_OBJECT =
              ModbusTcpWriteBooleanBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        case 'ModbusTcpWriteBooleanErrorBlock':
          BLOCK_OBJECT =
              ModbusTcpWriteBooleanErrorBlock.BUILD_FROM_JSON(LOGIC_BLOCK_JSON);
          break;
        default:
          throw Exception('Could not build object of type $TYPE from json');
      }
      blocks._insertAtKey(KEY, BLOCK_OBJECT);
    }

    blocks.buildModbusStringIdFromSelf();
    blocks.updateModbusStringVsObjectMap();

    blocks._updateTableOfuiLocationVsBlockLocation();
    blocks.assignReferenceOfAllBufferValueToBufferValueBlocks();
    blocks.assignReferenceOfAllModbusErrorToModbusWriteBlocks();
    blocks.updateModbusStringVsObjectMap();

    return blocks;
  }

  void _insertAtKey(int KEY, dynamic SINGLE_BLOCK) {
    Type TYPE = SINGLE_BLOCK.runtimeType;
    if (_typeKeyBlock[TYPE] == null) {
      _typeKeyBlock[TYPE] = <int, dynamic>{};
    }
    _typeKeyBlock[TYPE]![KEY] = SINGLE_BLOCK.COPY();
  }

  void _updateTableOfuiLocationVsBlockLocation() {
    Map<Type, Type> uiBlockInputTypes = {
      MultiTextButtonOutputBlock: MultiTextButton,
    };

    for (Type BLOCK_TYPE in uiBlockInputTypes.keys) {
      for (var BLOCK in _typeKeyBlock[BLOCK_TYPE]!.values) {
        Type? UI_TYPE = uiBlockInputTypes[BLOCK.runtimeType];

        if (UI_TYPE != null) {
          _tableOfuiLocationVsBlockLocation[(
            UI_TYPE,
            BLOCK._KEY_OF_UI_ELEMENT
          )] = BlockIdentifier(BLOCK_TYPE, BLOCK.selfKey);
        } else {
          throw Exception('ui location vs block location does not contain '
              'entry of data type $BLOCK');
        }
      }
    }
  }

  int GET_COUNT() {
    int count = 0;
    for (var TYPE in _typeKeyBlock.keys) {
      count += _typeKeyBlock[TYPE]!.length;
    }
    return count;
  }

  void processBlocksAsPerNodes(
    List<Node> sortedNodes,
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    for (Node node in sortedNodes) {
      var block = _getBlockFromBlockIdentifier(node.blockIdentifier);
      block.processBlock(enqueueResponseToUiQueue, enqueueRequestToModbusQueue);
    }
  }

  dynamic _getBlockFromBlockIdentifier(BlockIdentifier BLOCK_IDENTIFIER) {
    dynamic block =
        _typeKeyBlock[BLOCK_IDENTIFIER.DATA_TYPE]?[BLOCK_IDENTIFIER.KEY];
    if (block == null) {
      throw Exception('block does not exist at given blockIdentifier');
    } else {
      return block;
    }
  }

  void assignReferenceOfAllBufferValueToBufferValueBlocks() {
    for (BufferInput bufferInput in _typeKeyBlock[BufferInput]!.values) {
      bufferInput.bufferValue =
          _typeKeyBlock[BufferValue]![bufferInput.KEY_OF_LOGIC_VALUE_BLOCK];
    }
  }

  void assignReferenceOfAllModbusErrorToModbusWriteBlocks() {
    for (ModbusTcpWriteBooleanBlock modbusTcpWriteBooleanBlock
        in _typeKeyBlock[ModbusTcpWriteBooleanBlock]!.values) {
      modbusTcpWriteBooleanBlock.referenceOfErrorBlock =
          _typeKeyBlock[ModbusTcpWriteBooleanErrorBlock]![
              modbusTcpWriteBooleanBlock.INDEX_OF_ERROR_BLOCK];
    }
  }

  void updateDueToRequestFromUi(RequestFromUi requestFromUi) {
    BlockIdentifier? blockIdentifier = _tableOfuiLocationVsBlockLocation[(
      requestFromUi.TYPE_OF_UI_ELEMENT,
      requestFromUi.KEY_OF_UI_ELEMENT
    )];

    if (blockIdentifier != null) {
      switch (blockIdentifier.DATA_TYPE) {
        case MultiTextButtonOutputBlock:
          MultiTextButtonOutputBlock multiTextButtonOutputBlock =
              _getBlockFromBlockIdentifier(blockIdentifier);
          multiTextButtonOutputBlock.updateFromRequests(requestFromUi);
          break;
        default:
          throw Exception('Request of type ${blockIdentifier.DATA_TYPE} '
              'cannot be processed.');
      }
    } else {
      throw Exception('request can not be processed due to not in table');
    }
  }

  dynamic _getObjectAsPerModbusString(String modbusString) {
    dynamic modbusBlockObject = _modbusStringVsObject[modbusString];
    if (modbusBlockObject == null) {
      throw Exception('modbus block could not be obtained from modbusString');
    }
    return modbusBlockObject;
  }

  void updateFromModbusResponse(ResponseFromModbus response) {
    String modbusString = response.modbusBlockId.asString();
    var block = _getObjectAsPerModbusString(modbusString);
    block.enqueueResponseFromModbus(response);
  }

  void buildModbusStringIdFromSelf() {
    List<Type> MODBUS_TYPE_BLOCKS = [
      ModbusTcpReadBooleanBlock,
      ModbusTcpWriteBooleanBlock,
    ];
    for (var TYPE in MODBUS_TYPE_BLOCKS) {
      for (var block in _typeKeyBlock[TYPE]!.values) {
        block.buildModbusBlockIdStringFromSelf();
      }
    }
  }

  void updateModbusStringVsObjectMap() {
    List<Type> MODBUS_TYPE_BLOCKS = [
      ModbusTcpReadBooleanBlock,
      ModbusTcpWriteBooleanBlock,
    ];
    for (var TYPE in MODBUS_TYPE_BLOCKS) {
      for (var block in _typeKeyBlock[TYPE]!.values) {
        _modbusStringVsObject[block.GET_MODBUS_BLOCK_ID_STRING()] = block;
      }
    }
  }
}

class LogicIsolate {
  static const SIZE_LIMIT_QUEUE_UI = 5000;
  static const SIZE_LIMIT_QUEUE_MODBUS = 5000;
  bool _commandReceivedToEndIsolate = false;
  bool _areBlocksReceived = false;
  late final Blocks _blocks;
  List<Node> _nodes = [];
  final Queue<RequestFromUi> _requestsQueueUi = Queue<RequestFromUi>();
  final Queue<ResponseToUi> _responsesQueueUi = Queue<ResponseToUi>();
  final Queue<RequestToModbus> _requestsQueueModbus = Queue<RequestToModbus>();
  final Queue<ResponseFromModbus> _responsesQueueModbus =
      Queue<ResponseFromModbus>();

  late ModbusMaster _modbusMaster;
  late ReceivePort _receivePort;
  late SendPort _sendPort;

  static Future<void> run(SendPort sendPort) async {
    LogicIsolate logicIsolate = LogicIsolate();
    logicIsolate._sendPort = sendPort;
    logicIsolate._receivePort = ReceivePort();
    sendPort.send(logicIsolate._receivePort.sendPort);
    logicIsolate._commandReceivedToEndIsolate = false;
    logicIsolate._modbusMaster = await ModbusMaster.start();

    logicIsolate._receivePort.listen(
      (data) {
        if (data == null) {
          logicIsolate._commandReceivedToEndIsolate = true;
        } else if (data.runtimeType == String) {
          logicIsolate.createAllBlocksFromJsonOfAllBlocks(data);
          logicIsolate.generateSortedNodesFromBlocks();
          logicIsolate._areBlocksReceived = true;
        } else if (data.runtimeType == RequestFromUi) {
          logicIsolate.enqueueRequestsFromUi(data);
        }
      },
      onDone: () {},
      onError: () {},
    );
    while (true) {
      if (logicIsolate._areBlocksReceived) {
        break;
      }
      await Future.delayed(Duration.zero);
    }
    logicIsolate._infiniteLoop();
  }

  void _infiniteLoop() async {
    while (!_commandReceivedToEndIsolate) {
      //process data incoming to logic isolate
      _processModbusResponseQueue();
      _processUiRequestQueue();

      //process all blocks
      _blocks.processBlocksAsPerNodes(
        _nodes,
        enqueueResponsesToUi,
        enqueueRequestsToModbus,
      );

      //process data outgoing from logic isolate
      _processModbusRequestQueue();
      _processUiResponseQueue();

      //switch to other task in this isolate
      await Future.delayed(Duration.zero);
    }
    // send close to modbus master
    _modbusMaster.close();

    // close receive port
    _receivePort.close();

    // send null to ui isolate indicating that logic isolate has properly
    _sendPort.send(null);

    // clear requests and responses queue of ui
    // clear requests and responses queue of modbus
    // closed
  }

  void createAllBlocksFromJsonOfAllBlocks(String ALL_BLOCKS_JSON) {
    List<String> LIST_OF_JSON = jsonDecode(ALL_BLOCKS_JSON);
    _blocks = Blocks.BUILD_FROM_LIST_OF_JSON(LIST_OF_JSON);
  }

  void generateSortedNodesFromBlocks() {
    _nodes = Node.getNodesFrom(_blocks.getReferenceTypeVsKeyVsBlock());
    Node.sortAsPerIncreasingOrderOfUniqueNumber(_nodes);
  }

  int GET_COUNT_OF_BLOCKS() => _blocks.GET_COUNT();

  void clearNodes() => _nodes.clear();

  void enqueueRequestsFromUi(RequestFromUi requestFromUi) {
    if (_requestsQueueUi.length >= LogicIsolate.SIZE_LIMIT_QUEUE_UI) {
      _requestsQueueUi.removeFirst();
    }
    _requestsQueueUi.addLast(requestFromUi);
  }

  void enqueueRequestsToModbus(RequestToModbus requestToModbus) {
    if (_requestsQueueModbus.length >= LogicIsolate.SIZE_LIMIT_QUEUE_MODBUS) {
      _requestsQueueModbus.removeFirst();
    }
    _requestsQueueModbus.addLast(requestToModbus);
  }

  void enqueueResponsesToUi(ResponseToUi responseToUi) {
    if (_responsesQueueUi.length >= LogicIsolate.SIZE_LIMIT_QUEUE_UI) {
      _responsesQueueUi.removeFirst();
    }
    _responsesQueueUi.addLast(responseToUi);
  }

  void enqueueResponsesFromModbus(ResponseFromModbus responseFromModbus) {
    if (_responsesQueueModbus.length >= LogicIsolate.SIZE_LIMIT_QUEUE_MODBUS) {
      _responsesQueueModbus.removeFirst();
    }
    _responsesQueueModbus.addLast(responseFromModbus);
  }

  void _processUiRequestQueue() {
    //when request arrive, it should act as a rising pulse
    for (var request in _requestsQueueUi) {
      _blocks.updateDueToRequestFromUi(request);
    }
    _requestsQueueUi.clear();
  }

  void _processUiResponseQueue() {
    for (var response in _responsesQueueUi) {
      _sendPort.send(response);
    }
    _responsesQueueUi.clear();
  }

  void _processModbusRequestQueue() {
    for (var request in _requestsQueueModbus) {
      _modbusMaster.sendRequest(request);
    }
    _requestsQueueModbus.clear();
  }

  void _processModbusResponseQueue() {
    for (var response in _responsesQueueModbus) {
      _blocks.updateFromModbusResponse(response);
    }
    _responsesQueueModbus.clear();
  }

  void sendModbusRequest(Request request) {
    _modbusMaster.sendRequest(request);
  }
}

class Node {
  static Set<Type> OUTPUT_BLOCK_DATA_TYPE = {
    MultiTextButtonOutputBlock,
    BufferValue,
  };

  late final BlockIdentifier blockIdentifier;
  late final List<InputAddress> inputAddresses;
  int uniqueNumber = 1;

  Node(
    BlockIdentifier BLOCK_IDENTIFIER,
    List<InputAddress> INPUT_ADDRESS, [
    int? uniqueNumber,
  ]) {
    if (uniqueNumber != null) {
      this.uniqueNumber = uniqueNumber;
    }

    List<InputAddress> copyOfInputAddresses = [];
    for (InputAddress inputAddress in INPUT_ADDRESS) {
      copyOfInputAddresses.add(inputAddress.COPY);
    }

    blockIdentifier = BLOCK_IDENTIFIER.COPY;
    inputAddresses = copyOfInputAddresses;
  }

  void updateFields(int uniqueNumber) {
    this.uniqueNumber = uniqueNumber;
  }

  Node get COPY {
    return Node(blockIdentifier, inputAddresses, uniqueNumber);
  }

  static void assignUniqueNumberToNode(Node node, List<Node> ALL_NODE) {
    int newUniqueNumber = 1;
    for (Node nodeOfList in ALL_NODE) {
      if (newUniqueNumber == nodeOfList.uniqueNumber) {
        newUniqueNumber += 1;
      }
    }
    node.uniqueNumber = newUniqueNumber;
  }

  static bool DOES_MY_CHILDREN_ALREADY_EXIST(Node NODE, List<Node> ALL_NODE) {
    for (Node nodeOfList in ALL_NODE) {
      for (InputAddress inputAddress in NODE.inputAddresses) {
        if (BlockIdentifier.match(
          nodeOfList.blockIdentifier,
          inputAddress.BLOCK_IDENTIFIER,
        )) {
          return true;
        }
      }
    }
    return false;
  }

  ///returns true if children found
  static bool assignUniqueNumberGreaterThanChildren(
      Node node, List<Node> ALL_NODE) {
    bool childrenFound = false;
    int newUniqueNumber = 1;
    for (Node nodeOfList in ALL_NODE) {
      if (newUniqueNumber == nodeOfList.uniqueNumber) {
        newUniqueNumber += 1;
      }

      for (InputAddress inputAddress in node.inputAddresses) {
        childrenFound = BlockIdentifier.match(
            nodeOfList.blockIdentifier, inputAddress.BLOCK_IDENTIFIER);

        if (childrenFound) {
          if (!(newUniqueNumber > nodeOfList.uniqueNumber)) {
            newUniqueNumber = nodeOfList.uniqueNumber + 1;
          }
        }
      }
    }
    node.uniqueNumber = newUniqueNumber;

    return childrenFound;
  }

  static int getUniqueNumberGreaterThan(Node NODE, List<Node> ALL_NODE) {
    int newUniqueNumber = NODE.uniqueNumber + 1;

    for (Node nodeOfList in ALL_NODE) {
      if (newUniqueNumber == nodeOfList.uniqueNumber) {
        newUniqueNumber += 1;
      }
    }

    return newUniqueNumber;
  }

  static List<Node> FIND_MY_PARENT(Node THIS_NODE, List<Node> ALL_NODE) {
    List<Node> parentNode = [];

    for (Node node in ALL_NODE) {
      for (InputAddress inputAddress in node.inputAddresses) {
        if (BlockIdentifier.match(
            THIS_NODE.blockIdentifier, inputAddress.BLOCK_IDENTIFIER)) {
          parentNode.add(node.COPY);
          break;
        }
      }
    }

    return parentNode;
  }

  static List<Node> GET_NODES_FROM(Map<Type, Map<int, dynamic>> ALL_BLOCK) {
    List<Node> allNode = [];

    // Set<Type> OTHER_BLOCK_DATA_TYPE = {};

    for (var dataType in OUTPUT_BLOCK_DATA_TYPE) {
      for (int key in ALL_BLOCK[dataType]!.keys) {
        allNode.add(
          NODE_FROM(
            ALL_BLOCK[dataType]![key],
            BlockIdentifier(dataType, key),
          ),
        );
      }
    }

    for (var dataType in ALL_BLOCK.keys) {
      bool dataTypeIsOfOutputType = false;

      for (var typ in OUTPUT_BLOCK_DATA_TYPE) {
        if (dataType == typ) {
          dataTypeIsOfOutputType = true;
          break;
        }
      }

      if (!dataTypeIsOfOutputType) {
        for (var integerKey in ALL_BLOCK[dataType]!.keys) {
          allNode.add(
            NODE_FROM(
              ALL_BLOCK[dataType]![integerKey],
              BlockIdentifier(dataType, integerKey),
            ),
          );
        }
      }
    }

    return allNode;
  }

  static Node NODE_FROM(dynamic BLOCK, BlockIdentifier BLOCK_IDENTIFIER) {
    List<InputAddress> mainAndSecondaryInputAddress = [];

    for (var mainAddress in BLOCK.inputAddress) {
      mainAndSecondaryInputAddress.add(mainAddress.COPY);
    }
    for (var secondaryAddress in BLOCK.secondaryInputAddress) {
      mainAndSecondaryInputAddress.add(secondaryAddress.COPY);
    }

    return Node(BLOCK_IDENTIFIER, mainAndSecondaryInputAddress);
  }

  static List<Node> getNodesFrom(Map<Type, Map<int, dynamic>> ALL_BLOCK) {
    List<Node> allNode = [];
    allNode = GET_NODES_FROM(ALL_BLOCK);
    int numberOfOutputBlocks = 0;

    for (var dataType in OUTPUT_BLOCK_DATA_TYPE) {
      numberOfOutputBlocks += (ALL_BLOCK[dataType] ?? {}).length.toInt();
    }

    for (int i = 0; i < numberOfOutputBlocks; ++i) {
      assignUniqueNumberToNode(allNode[i], REMOVE_AT_INDEX(i, allNode));
    }

    for (int i = numberOfOutputBlocks; i < allNode.length; ++i) {
      List<Node> nodesOtherThanMe = REMOVE_AT_INDEX(i, allNode);

      bool childrenExist = false;
      bool parentExist = false;

      childrenExist =
          assignUniqueNumberGreaterThanChildren(allNode[i], nodesOtherThanMe);

      List<Node> parents = FIND_MY_PARENT(allNode[i], nodesOtherThanMe);
      parentExist = parents.isNotEmpty;

      if (!childrenExist && !parentExist) {
        assignUniqueNumberToNode(allNode[i], nodesOtherThanMe);
      } else {
        if (parentExist) {
          for (var parent in parents) {
            if (parent.uniqueNumber > allNode[i].uniqueNumber) {
            } else {
              int newUniqueNumber =
                  getUniqueNumberGreaterThan(parent, nodesOtherThanMe);
              Node? parentNodeReference =
                  GET_REFERENCE_OF_NODE_FROM_LIST(parent, allNode);
              if (parentNodeReference != null) {
                parentNodeReference.updateFields(newUniqueNumber);
              }
            }
          }
        }
      }
    }
    return allNode;
  }

  static List<Node> REMOVE_AT_INDEX(int INDEX, List<Node> ALL_NODE) {
    List<Node> newNodeList = [];

    for (int i = 0; i < ALL_NODE.length; ++i) {
      if (i != INDEX) {
        newNodeList.add(ALL_NODE[i].COPY);
      }
    }

    return newNodeList;
  }

  static Node? GET_REFERENCE_OF_NODE_FROM_LIST(Node NODE, List<Node> ALL_NODE) {
    for (var node in ALL_NODE) {
      if (match(node, NODE)) {
        return node;
      }
    }
    return null;
  }

  static bool match(Node first, Node second) {
    bool inputAddressMatch = false;
    if (first.inputAddresses.length != second.inputAddresses.length) {
    } else {
      inputAddressMatch = true;

      for (int i = 0; i < first.inputAddresses.length; ++i) {
        bool blockIdentifierMatch = BlockIdentifier.match(
            first.inputAddresses[i].BLOCK_IDENTIFIER,
            second.inputAddresses[i].BLOCK_IDENTIFIER);
        bool keyMatch = first.inputAddresses[i].OUTPUT_PORT_KEY ==
            second.inputAddresses[i].OUTPUT_PORT_KEY;
        if (!blockIdentifierMatch || !keyMatch) {
          inputAddressMatch = false;
          break;
        }
      }
    }

    return (first.uniqueNumber == second.uniqueNumber) &&
        (BlockIdentifier.match(
            first.blockIdentifier, second.blockIdentifier)) &&
        (inputAddressMatch);
  }

  static void sortAsPerIncreasingOrderOfUniqueNumber(List<Node> allNode) {
    allNode.sort((element1, element2) =>
        element1.uniqueNumber > element2.uniqueNumber ? 1 : -1);
  }
}
