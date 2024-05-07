import 'dart:convert';
import 'dart:math';
import 'dart:collection';
import 'package:simple_hmi/classes/class_extensions.dart';
import 'package:simple_hmi/classes/elements.dart';
import 'package:simple_hmi/classes/input_elements.dart';
import '/classes/modbus_master_isolate.dart' as modbus_master_isolate;
import '/classes/logic_part.dart';
import '/classes/enumerations.dart';
import '/data/user_interface_data.dart';
import '/classes/modbus_master_isolate.dart';

extension boolString on bool {
  static bool FROM_STRING(string) {
    if (string == 'true') {
      return true;
    } else {
      return false;
    }
  }

  String GET_STRING() => toString();
}

class BlockIdentifier {
  static const STRING_VS_BLOCK_TYPE = {
    'And': And,
    'Or': Or,
    'Xor': Xor,
    'Not': Not,
    'ResetSet': ResetSet,
    'SetReset': SetReset,
    'FallingEdgeDetector': FallingEdgeDetector,
    'RisingEdgeDetector': RisingEdgeDetector,
    'PriorityEncoder': PriorityEncoder,
    'BinaryMux': BinaryMux,
    'AnalogMux': AnalogMux,
    'SetResetAnalog': SetResetAnalog,
    'ResetSetAnalog': ResetSetAnalog,
    'CompareLessThan': CompareLessThan,
    'CompareLessThanEqualTo': CompareLessThanEqualTo,
    'CompareGreaterThan': CompareGreaterThan,
    'CompareGreaterThanEqualTo': CompareGreaterThanEqualTo,
    'CompareEqualTo': CompareEqualTo,
    'CompareNotEqualTo': CompareNotEqualTo,
    'SourceBooleanFalse': SourceBooleanFalse,
    'SourceBooleanTrue': SourceBooleanTrue,
    'SourceInteger': SourceInteger,
    'SourceDoubleInteger': SourceDoubleInteger,
    'SourceReal': SourceReal,
    'SourceExponent': SourceExponent,
    'SourcePi': SourcePi,
    'ConvertToInteger': ConvertToInteger,
    'ConvertToDoubleInteger': ConvertToDoubleInteger,
    'ConvertToReal': ConvertToReal,
    'Add': Add,
    'Subtract': Subtract,
    'Multiply': Multiply,
    'Divide': Divide,
    'Remainder': Remainder,
    'Exponent': Exponent,
    'Log': Log,
    'SquareRoot': SquareRoot,
    'Sin': Sin,
    'Cos': Cos,
    'Tan': Tan,
    'Asin': Asin,
    'Acos': Acos,
    'Atan': Atan,
    'Counter': Counter,
    'PWM': PWM,
    'OnDelayTimer': OnDelayTimer,
    'OffDelayTimer': OffDelayTimer,
    'RetentiveOnDelayTimer': RetentiveOnDelayTimer,
    'PulseTimer': PulseTimer,
    'ExtendedPulseTimer': ExtendedPulseTimer,
    'BufferInput': BufferInput,
    'BufferValue': BufferValue,
    'LineBooleanInputBlock': LineBooleanInputBlock,
    'RectangleBooleanInputBlock': RectangleBooleanInputBlock,
    'MultiTextBooleanInputBlock': MultiTextBooleanInputBlock,
    'MultiTextButtonInputBlock': MultiTextButtonInputBlock,
    'MultiTextButtonOutputBlock': MultiTextButtonOutputBlock,
    'ModbusTcpReadBooleanBlock': ModbusTcpReadBooleanBlock,
  };

  final Type DATA_TYPE;
  final int KEY;
  const BlockIdentifier(this.DATA_TYPE, this.KEY);

  BlockIdentifier get COPY => BlockIdentifier(DATA_TYPE, KEY);

  @override
  bool operator ==(other) {
    if (other is BlockIdentifier) {
      return other.DATA_TYPE == DATA_TYPE && other.KEY == KEY;
    } else {
      throw Exception(
          'equality operator is used to check equality between BlockIdentifier and ${other.runtimeType}');
    }
  }

  static const DATA_TYPE_VS_HASH = {
    And: 1,
    Or: 2,
    Xor: 3,
    Not: 4,
    ResetSet: 5,
    SetReset: 6,
    FallingEdgeDetector: 7,
    RisingEdgeDetector: 8,
    PriorityEncoder: 9,
    BinaryMux: 10,
    AnalogMux: 11,
    SetResetAnalog: 12,
    ResetSetAnalog: 13,
    CompareLessThan: 14,
    CompareLessThanEqualTo: 15,
    CompareGreaterThan: 16,
    CompareGreaterThanEqualTo: 17,
    CompareEqualTo: 18,
    CompareNotEqualTo: 19,
    SourceBooleanFalse: 20,
    SourceBooleanTrue: 21,
    SourceInteger: 22,
    SourceDoubleInteger: 23,
    SourceReal: 24,
    SourceExponent: 25,
    SourcePi: 26,
    ConvertToInteger: 27,
    ConvertToDoubleInteger: 28,
    ConvertToReal: 29,
    Add: 30,
    Subtract: 31,
    Multiply: 32,
    Divide: 33,
    Remainder: 34,
    Exponent: 35,
    Log: 36,
    SquareRoot: 37,
    Sin: 38,
    Cos: 39,
    Tan: 40,
    Asin: 41,
    Acos: 42,
    Atan: 43,
    Counter: 44,
    PWM: 45,
    OnDelayTimer: 46,
    OffDelayTimer: 47,
    RetentiveOnDelayTimer: 48,
    PulseTimer: 49,
    ExtendedPulseTimer: 50,
    BufferInput: 51,
    BufferValue: 52,
    LineBooleanInputBlock: 53,
    RectangleBooleanInputBlock: 54,
    MultiTextBooleanInputBlock: 55,
    MultiTextButtonInputBlock: 56,
    MultiTextButtonOutputBlock: 57,
    ModbusTcpReadBooleanBlock: 58,
  };

  @override
  int get hashCode {
    int? INTEGER_FROM_TYPE = DATA_TYPE_VS_HASH[DATA_TYPE];

    if (INTEGER_FROM_TYPE == null) {
      throw Exception(
          'BlockIdentifier does not contain entry of ${DATA_TYPE.runtimeType}'
          ' in  static Map<Type,int> DATA_TYPE_VS_HASH ');
    } else {
      return INTEGER_FROM_TYPE * 1000000 + KEY;
    }
  }

  static bool match(BlockIdentifier first, BlockIdentifier second) {
    return (first.DATA_TYPE == second.DATA_TYPE) && (first.KEY == second.KEY);
  }

  Map GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING() {
    return {
      'DATA_TYPE': DATA_TYPE.toString(),
      'KEY': KEY.toString(),
    };
  }

  static BlockIdentifier BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
    Map m,
  ) {
    String KEY_STRING = m['KEY'];
    int KEY = int.parse(KEY_STRING);
    String DATA_TYPE_STRING = m['DATA_TYPE'];
    Type? DATA_TYPE = STRING_VS_BLOCK_TYPE[DATA_TYPE_STRING];
    if (DATA_TYPE != null) {
      return BlockIdentifier(DATA_TYPE, KEY);
    } else {
      throw Exception(
          'BlockIdentifier.STRING_VS_BLOCK_TYPE does not contain entry of $DATA_TYPE');
      // return BlockIdentifier(int, KEY);
    }
  }
}

class InputAddress {
  final BlockIdentifier BLOCK_IDENTIFIER;
  final int OUTPUT_PORT_KEY;

  const InputAddress(this.BLOCK_IDENTIFIER, this.OUTPUT_PORT_KEY);

  InputAddress get COPY {
    return InputAddress(BLOCK_IDENTIFIER.COPY, OUTPUT_PORT_KEY);
  }

  InputAddress GET_UPDATED(
    BlockIdentifier? BLOCK_IDENTIFIER,
    int? OUTPUT_PORT_KEY,
  ) =>
      InputAddress(
        BLOCK_IDENTIFIER?.COPY ?? this.BLOCK_IDENTIFIER,
        OUTPUT_PORT_KEY ?? this.OUTPUT_PORT_KEY,
      );

  Map GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING() {
    return {
      'BLOCK_IDENTIFIER':
          BLOCK_IDENTIFIER.GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(),
      'OUTPUT_PORT_KEY': OUTPUT_PORT_KEY.toString(),
    };
  }

  static InputAddress BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
      Map m) {
    BlockIdentifier BLOCK_IDENTIFIER =
        BlockIdentifier.BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
            m['BLOCK_IDENTIFIER']);
    int OUTPUT_PORT_KEY = int.parse(m['OUTPUT_PORT_KEY']);
    return InputAddress(BLOCK_IDENTIFIER, OUTPUT_PORT_KEY);
  }
}

class Integer {
  //16 bit signed integer
  static int MIN_VALUE = -32768;
  static int MAX_VALUE = 32767;
  final int VALUE;

  const Integer._(this.VALUE);

  static Integer FROM_INT(int VAL) {
    if (VAL > MAX_VALUE) {
      return Integer._(MAX_VALUE);
    } else if (VAL < MIN_VALUE) {
      return Integer._(MIN_VALUE);
    } else {
      return Integer._(VAL);
    }
  }

  Integer get COPY {
    return Integer._(VALUE);
  }

  // logical operation
  bool GREATER_THAN(Integer INTEGER) {
    return VALUE > INTEGER.VALUE;
  }

  bool GREATER_OR_EQUAL_TO(Integer INTEGER) {
    return VALUE >= INTEGER.VALUE;
  }

  bool LESS_THAN(Integer INTEGER) {
    return VALUE < INTEGER.VALUE;
  }

  bool LESS_OR_EQUAL_TO(Integer INTEGER) {
    return VALUE <= INTEGER.VALUE;
  }

  bool EQUAL_TO(Integer INTEGER) {
    return VALUE == INTEGER.VALUE;
  }

  bool NOT_EQUAL_TO(Integer INTEGER) {
    return VALUE != INTEGER.VALUE;
  }

  //Data type conversion
  static Integer FROM_DOUBLE_INTEGER(DoubleInteger DOUBLE_INTEGER) {
    if (DOUBLE_INTEGER.VALUE > MAX_VALUE) {
      return Integer._(MAX_VALUE);
    } else if (DOUBLE_INTEGER.VALUE < MIN_VALUE) {
      return Integer._(MIN_VALUE);
    } else {
      return Integer._(DOUBLE_INTEGER.VALUE);
    }
  }

  static Integer FROM_REAL(Real REAL) {
    if (REAL.VALUE > MAX_VALUE) {
      return Integer._(MAX_VALUE);
    } else if (REAL.VALUE < MIN_VALUE) {
      return Integer._(MIN_VALUE);
    } else {
      return Integer._(REAL.VALUE.toInt());
    }
  }

  //Math operations
  Integer ADD(Integer INTEGER) {
    return Integer.FROM_INT(VALUE + INTEGER.VALUE);
  }

  ///returns MINUEND - SUBTRAHEND
  Integer SUBTRACT(Integer INTEGER) {
    return Integer.FROM_INT(VALUE - INTEGER.VALUE);
  }

  Integer MULTIPLY(Integer INTEGER) {
    return Integer.FROM_INT(VALUE * INTEGER.VALUE);
  }

  ///returns DIVIDENT / DIVISOR
  Real DIVIDE_BY(Integer DIVISOR) {
    return Real.FROM_DOUBLE(VALUE.toDouble() / DIVISOR.VALUE.toDouble());
  }

  ///returns DIVIDENT % DIVISOR
  Integer REMAINDER(Integer DIVISOR) {
    return Integer.FROM_INT(VALUE % DIVISOR.VALUE);
  }
}

class DoubleInteger {
  //32 bit signed integer
  static int MIN_VALUE = -2147483648;
  static int MAX_VALUE = 2147483647;

  final int VALUE;

  const DoubleInteger._(this.VALUE);

  static DoubleInteger FROM_INT(int VALUE) {
    if (VALUE > MAX_VALUE) {
      return DoubleInteger._(MAX_VALUE);
    } else if (VALUE < MIN_VALUE) {
      return DoubleInteger._(MIN_VALUE);
    } else {
      return DoubleInteger._(VALUE);
    }
  }

  static DoubleInteger FROM_INTEGER(Integer INTEGER) {
    return DoubleInteger._(INTEGER.VALUE);
  }

  static DoubleInteger FROM_REAL(Real REAL) {
    if (REAL.VALUE > MAX_VALUE) {
      return DoubleInteger._(MAX_VALUE);
    } else if (REAL.VALUE < MIN_VALUE) {
      return DoubleInteger._(MIN_VALUE);
    } else {
      return DoubleInteger._(REAL.VALUE.toInt());
    }
  }

  DoubleInteger get COPY {
    return DoubleInteger._(VALUE);
  }

  bool GREATER_THAN(DoubleInteger DOUBLE_INTEGER) {
    return VALUE > DOUBLE_INTEGER.VALUE;
  }

  bool GREATER_OR_EQUAL(DoubleInteger DOUBLE_INTEGER) {
    return VALUE >= DOUBLE_INTEGER.VALUE;
  }

  bool LESS_THAN(DoubleInteger DOUBLE_INTEGER) {
    return VALUE < DOUBLE_INTEGER.VALUE;
  }

  bool LESS_OR_EQUAL_TO(DoubleInteger DOUBLE_INTEGER) {
    return VALUE <= DOUBLE_INTEGER.VALUE;
  }

  bool EQUAL_TO(DoubleInteger DOUBLE_INTEGER) {
    return VALUE == DOUBLE_INTEGER.VALUE;
  }

  bool NOT_EQUAL_TO(DoubleInteger DOUBLE_INTEGER) {
    return VALUE != DOUBLE_INTEGER.VALUE;
  }

  //Math operations
  DoubleInteger ADD(DoubleInteger DOUBLE_INTEGER_2) {
    return DoubleInteger._(VALUE + DOUBLE_INTEGER_2.VALUE);
  }

  ///returns MINUEND - SUBTRAHEND
  DoubleInteger SUBTRACT(DoubleInteger DOUBLE_INTEGER) {
    return DoubleInteger._(VALUE - DOUBLE_INTEGER.VALUE);
  }

  DoubleInteger MULTIPLY(DoubleInteger DOUBLE_INTEGER) {
    return DoubleInteger._(VALUE * DOUBLE_INTEGER.VALUE);
  }

  ///returns DIVIDENT / DIVISOR
  Real DIVIDE_BY(DoubleInteger DIVISOR) {
    return Real.FROM_DOUBLE(VALUE.toDouble() / DIVISOR.VALUE.toDouble());
  }

  ///returns DIVIDENT % DIVISOR
  DoubleInteger REMAINDER(DoubleInteger DIVISOR) {
    return DoubleInteger._(VALUE % DIVISOR.VALUE);
  }
}

class LongInteger {
  //64 bit signed integer
  final int value;
  const LongInteger(this.value);

  LongInteger get COPY {
    return LongInteger(value);
  }

  static bool greater(LongInteger first, LongInteger second) {
    return first.value > second.value;
  }

  static bool greaterOrEqual(LongInteger first, LongInteger second) {
    return first.value >= second.value;
  }

  static bool less(LongInteger first, LongInteger second) {
    return first.value < second.value;
  }

  static bool lessOrEqual(LongInteger first, LongInteger second) {
    return first.value <= second.value;
  }

  static bool equal(LongInteger first, LongInteger second) {
    return first.value == second.value;
  }

  static bool notEqual(LongInteger first, LongInteger second) {
    return first.value != second.value;
  }
}

class UnsignedInteger {
  //16 bit unsigned integer
}

class UnsignedDoubleInteger {
  //32 bit unsigned integer
}

class UnsignedLongInteger {
  //64 bit unsigned integer
}

class BooleanMethods {
  ///returns List of boolean with MSB at 0th index of List
  ///
  ///e.g. binary 10110 exist in list as [true,false,true,true,false]
  static List<bool> binaryFromDecimal(int decimal) {
    if (decimal == 0) {
      return [false];
    }
    List<bool> binary = [];
    int dec = decimal;
    bool tempBinaryValue;
    while (dec > 0) {
      tempBinaryValue = dec % 2 == 1;
      binary = [tempBinaryValue, ...binary];
      dec = dec ~/ 2;
    }
    return binary;
  }

  static int decimalFromBinary(List<bool> binary) {
    if (binary == []) {
      return 0;
    } else {
      int outputInt = 0;

      for (bool element in binary) {
        outputInt = (outputInt << 1) | (element ? 1 : 0);
      }
      return outputInt;
    }
  }
}

/// "Real" class creates a constant object.
///
/// #### "Real" object should be created by using these class methods
/// - FROM_DOUBLE - from dart double
/// - FROM_INTEGER - from "Integer"
/// - FROM_DOUBLE_INTEGER - from "DoubleInteger"
///
/// #### "Real" object has these methods which have their usual meaning
/// - COPY
/// - GREATER_THAN
/// - GREATER_THAN_OR_EQUAL_TO
/// - LESS_THAN
/// - LESS_THAN_OR_EQUAL_TO
/// - EQUAL_TO
/// - NOT_EQUAL_TO
/// - ADD
/// - SUBTRACT
/// - MULTIPLY
/// - DIVIDE_BY
/// - REMAINDER
/// - POW
/// - LOG
/// - SQUARE_ROOT
/// - SIN
/// - COS
/// - TAN
/// - ASIN
/// - ACOS
/// - ATAN
class Real {
  static double MIN_VALUE = -3.4e38;
  static double MAX_VALUE = 3.4e38;

  /// dart double data type but is limited by
  /// - minimum value = -3.4 x 10<sup>38</sup>
  /// - maximum value =  3.4 x 10<sup>38</sup>
  final double VALUE;

  const Real._(this.VALUE);

  /// returns object of "Real" from dart double
  static Real FROM_DOUBLE(double DOUBLE) {
    if (DOUBLE > MAX_VALUE) {
      return Real._(MAX_VALUE);
    } else if (DOUBLE < MIN_VALUE) {
      return Real._(MIN_VALUE);
    } else {
      return Real._(DOUBLE);
    }
  }

  /// returns object of "Real" from object of "Integer"
  static Real FROM_INTEGER(Integer INTEGER) {
    return Real._(INTEGER.VALUE.toDouble());
  }

  /// returns object of "Real" from object of "DoubleInteger"
  static Real FROM_DOUBLE_INTEGER(DoubleInteger DOUBLE_INTEGER) {
    return Real.FROM_DOUBLE(DOUBLE_INTEGER.VALUE.toDouble());
  }

  /// returns a new instance of this
  Real get COPY {
    return Real._(VALUE);
  }

  /// NUMBER should be of type INTEGER or REAL
  bool GREATER_THAN(dynamic NUMBER) {
    if (!(NUMBER.runtimeType == Integer || NUMBER.runtimeType == Real)) {
      throw Exception('Type of NUMBER should be "Integer" or "Real"');
    }
    return VALUE > NUMBER.VALUE;
  }

  /// NUMBER should be of type INTEGER or REAL
  bool GREATER_THAN_OR_EQUAL_TO(dynamic NUMBER) {
    if (!(NUMBER.runtimeType == Integer || NUMBER.runtimeType == Real)) {
      throw Exception('Type of NUMBER should be "Integer" or "Real"');
    }
    return VALUE >= NUMBER.VALUE;
  }

  /// NUMBER should be of type INTEGER or REAL
  bool LESS_THAN(dynamic NUMBER) {
    if (!(NUMBER.runtimeType == Integer || NUMBER.runtimeType == Real)) {
      throw Exception('Type of NUMBER should be "Integer" or "Real"');
    }
    return VALUE < NUMBER.VALUE;
  }

  /// NUMBER should be of type INTEGER or REAL
  bool LESS_THAN_OR_EQUAL_TO(dynamic NUMBER) {
    if (!(NUMBER.runtimeType == Integer || NUMBER.runtimeType == Real)) {
      throw Exception('Type of NUMBER should be "Integer" or "Real"');
    }
    return VALUE <= NUMBER.VALUE;
  }

  /// NUMBER should be of type INTEGER or REAL
  bool EQUAL_TO(dynamic NUMBER) {
    if (!(NUMBER.runtimeType == Integer || NUMBER.runtimeType == Real)) {
      throw Exception('Type of NUMBER should be "Integer" or "Real"');
    }
    return VALUE == NUMBER.VALUE;
  }

  /// NUMBER should be of type INTEGER or REAL
  bool NOT_EQUAL_TO(dynamic NUMBER) {
    if (!(NUMBER.runtimeType == Integer || NUMBER.runtimeType == Real)) {
      throw Exception('Type of NUMBER should be "Integer" or "Real"');
    }
    return VALUE != NUMBER.VALUE;
  }

  //Math operations
  ///returns
  ///- this + REAL
  Real ADD(Real REAL) {
    return Real.FROM_DOUBLE(VALUE + REAL.VALUE);
  }

  ///returns
  /// - this - SUBTRAHEND
  Real SUBTRACT(Real SUBTRAHEND) {
    return Real.FROM_DOUBLE(VALUE - SUBTRAHEND.VALUE);
  }

  ///returns
  ///- this * REAL
  Real MULTIPLY(Real REAL) {
    return Real.FROM_DOUBLE(VALUE * REAL.VALUE);
  }

  /// returns
  /// - this / DIVISOR
  Real DIVIDE_BY(Real DIVISOR) {
    return Real.FROM_DOUBLE(VALUE / DIVISOR.VALUE);
  }

  /// returns
  /// - this % DIVISOR
  Real REMAINDER(Real DIVISOR) {
    return Real.FROM_DOUBLE(VALUE % DIVISOR.VALUE);
  }

  /// returns
  /// - this<sup>EXPONENT</sup>
  Real POW(Real EXPONENT) {
    return Real.FROM_DOUBLE(pow(VALUE, EXPONENT.VALUE).toDouble());
  }

  /// returns
  /// - log<sub>BASE</sub>(this)
  Real LOG(Real BASE) {
    return Real.FROM_DOUBLE(log(VALUE) / log(BASE.VALUE));
  }

  /// returns
  /// - this<sup>1/2</sup>
  Real SQUARE_ROOT() {
    return Real.FROM_DOUBLE(sqrt(VALUE));
  }

  /// returns
  /// - sin(this)
  ///
  /// by default angle is in radians
  /// - ```real.SIN()```
  ///
  /// to use angle in degrees use
  /// - ```real.SIN(true)```
  Real SIN([bool IS_ANGLE_IN_DEGREES = false]) {
    if (!IS_ANGLE_IN_DEGREES) {
      return Real.FROM_DOUBLE(sin(VALUE));
    } else {
      final double RADIAN = pi / 180 * VALUE;
      return Real.FROM_DOUBLE(sin(RADIAN));
    }
  }

  /// returns
  /// - cos(this)
  ///
  /// by default angle is in radians
  /// - ```real.COS()```
  ///
  /// to use angle in degrees use
  /// - ```real.COS(true)```
  Real COS([bool IS_ANGLE_IN_DEGREES = false]) {
    if (!IS_ANGLE_IN_DEGREES) {
      return Real.FROM_DOUBLE(cos(VALUE));
    } else {
      final double RADIAN = pi / 180 * VALUE;
      return Real.FROM_DOUBLE(cos(RADIAN));
    }
  }

  /// returns
  /// - tan(this)
  ///
  /// by default angle is in radians
  /// - ```real.TAN()```
  ///
  /// to use angle in degrees use
  /// - ```real.TAN(true)```
  Real TAN([bool IS_ANGLE_IN_DEGREES = false]) {
    if (!IS_ANGLE_IN_DEGREES) {
      return Real.FROM_DOUBLE(tan(VALUE));
    } else {
      final double RADIAN = pi / 180 * VALUE;
      return Real.FROM_DOUBLE(tan(RADIAN));
    }
  }

  /// returns
  /// - asin(this)
  ///
  /// by default angle is in radians
  /// - ```real.ASIN()```
  ///
  /// to use angle in degrees use
  /// - ```real.ASIN(true)```
  Real ASIN([bool IS_ANGLE_IN_DEGREES = false]) {
    if (!IS_ANGLE_IN_DEGREES) {
      return Real.FROM_DOUBLE(asin(VALUE));
    } else {
      final double DEGREES = asin(VALUE) * 180 / pi;
      return Real.FROM_DOUBLE(DEGREES);
    }
  }

  /// returns
  /// - acos(this)
  ///
  /// by default angle is in radians
  /// - ```real.ACOS()```
  ///
  /// to use angle in degrees use
  /// - ```real.ACOS(true)```
  Real ACOS([bool IS_ANGLE_IN_DEGREES = false]) {
    if (!IS_ANGLE_IN_DEGREES) {
      return Real.FROM_DOUBLE(acos(VALUE));
    } else {
      final double DEGREES = acos(VALUE) * 180 / pi;
      return Real.FROM_DOUBLE(DEGREES);
    }
  }

  /// returns
  /// - atan(this)
  ///
  /// by default angle is in radians
  /// - ```real.ATAN()```
  ///
  /// to use angle in degrees use
  /// - ```real.ATAN(true)```
  Real ATAN([bool IS_ANGLE_IN_DEGREES = false]) {
    if (!IS_ANGLE_IN_DEGREES) {
      return Real.FROM_DOUBLE(atan(VALUE));
    } else {
      final double DEGREES = atan(VALUE) * 180 / pi;
      return Real.FROM_DOUBLE(DEGREES);
    }
  }
}

class LongReal {
  //64 bit floating point number
  final double VALUE;
  const LongReal(this.VALUE);
}

/**These variables must be implemented in every logic block
 *  * static int MINIMUM_INPUT
 *  * static int MAXUMUM_INPUT
 *  * static int MINIMUM_SECONDARY_INPUT
 *  * static int MAXIMUM_SECONDARY_INPUT
 *  * PointBoolean topLeftCorner
 *  * List<InputPort> input
 *  * List<InputAddress> inputAddress
 *  * List<SecondaryPort> secondaryInput
 *  * List<InputAddress> secondaryInputAddress
 *  * List<OutputPort> output

This object method must be implemented for every logic block
 *  * processBlock()
 *  * JSON()
 *  * COPY()

This static method must be implemented for every logic block
 *  * BUILD_FROM_JSON()
 */
abstract class LogicBlock {
  late int selfKey;
  late PointBoolean topLeftCorner;
  late List<InputPort> primaryInputs;
  late List<InputAddress> primaryInputAddresses;
  late List<InputPort> secondaryInputs;
  late List<InputAddress> secondaryInputAddresses;
  late List<OutputPort> output;
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  );
  String JSON();
  //static LogicBlock buildFromJson(String JSON_FILE);
  LogicBlock COPY();
}

const Map<
    Type,
    ({
      int MINIMUM_NUMBER_OF_PRIMARY_INPUTS,
      int MAXIMUM_NUMBER_OF_PRIMARY_INPUTS,
      int MINIMUM_NUMBER_OF_SECONDARY_INPUTS,
      int MAXIMUM_NUMBER_OF_SECONDARY_INPUTS,
    })> PORT_COUNT = {
  And: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 20,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  Or: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 20,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  Xor: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  Not: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  ResetSet: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  SetReset: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  FallingEdgeDetector: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  RisingEdgeDetector: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  PriorityEncoder: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 20,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0
  ),
  BinaryMux: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 2
  ),
  AnalogMux: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 3,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 17,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 5,
  ),
  SetResetAnalog: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 2,
  ),
  ResetSetAnalog: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 2,
  ),
  CompareLessThan: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  CompareLessThanEqualTo: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  CompareGreaterThan: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  CompareGreaterThanEqualTo: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  CompareEqualTo: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  CompareNotEqualTo: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourceBooleanFalse: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourceBooleanTrue: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourceInteger: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourceDoubleInteger: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourceReal: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourceExponent: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SourcePi: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ConvertToInteger: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ConvertToDoubleInteger: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ConvertToReal: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Add: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 20,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Subtract: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Multiply: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 20,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Divide: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Remainder: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Log: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  SquareRoot: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  Sin: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  Cos: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  Tan: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  Asin: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  Acos: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  Atan: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  Counter: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 4,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 4,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  PWM: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  OnDelayTimer: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  OffDelayTimer: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  RetentiveOnDelayTimer: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 1,
  ),
  PulseTimer: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ExtendedPulseTimer: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  BufferInput: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  BufferValue: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  LineBooleanInputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  RectangleBooleanInputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  CircleBooleanInputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  TextBooleanInputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  MultiTextBooleanInputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 20,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  MultiTextButtonInputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 1,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  MultiTextButtonOutputBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ModbusTcpReadBooleanBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ModbusTcpWriteBooleanBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 2,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
  ModbusTcpWriteBooleanErrorBlock: (
    MINIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_PRIMARY_INPUTS: 0,
    MINIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
    MAXIMUM_NUMBER_OF_SECONDARY_INPUTS: 0,
  ),
};

const Duration MODBUS_TCP_DEFAULT_TIMEOUT = Duration(seconds: 2);

const Duration MODBUS_TCP_DEFAULT_SCAN_TIME_FOR_READ =
    Duration(milliseconds: 500);

Map GET_MAP_CONTAINING_STRING_FROM(dynamic BLOCK) {
  PointBoolean topLeftCorner = BLOCK.topLeftCorner;
  List<InputPort> primaryInputs = BLOCK.primaryInputs;
  List<InputAddress> primaryInputAddresses = BLOCK.primaryInputAddresses;
  List<InputPort> secondaryInputs = BLOCK.secondaryInputs;
  List<InputAddress> secondaryInputAddresses = BLOCK.secondaryInputAddresses;
  List<OutputPort> outputs = BLOCK.output;
  List primaryInputsList = [];
  List primaryInputAddressesList = [];
  List secondaryInputsList = [];
  List secondaryInputAddressList = [];
  List outputList = [];
  for (var primaryInput in primaryInputs) {
    primaryInputsList
        .add(primaryInput.GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING());
  }
  for (var secondaryInput in secondaryInputs) {
    secondaryInputsList
        .add(secondaryInput.GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING());
  }
  for (var primaryInputAddress in primaryInputAddresses) {
    primaryInputAddressesList.add(
        primaryInputAddress.GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING());
  }
  for (var secondaryInputAddress in secondaryInputAddresses) {
    secondaryInputAddressList.add(
        secondaryInputAddress.GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING());
  }
  for (var output in outputs) {
    outputList.add(output.GET_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING());
  }

  Map m = {
    'selfKey': BLOCK.selfKey.toString(),
    'topLeftCorner': topLeftCorner.GET_MAP_CONTAINING_STRING(),
    'primaryInputs': primaryInputsList,
    'secondaryInputs': secondaryInputsList,
    'primaryInputAddresses': primaryInputAddressesList,
    'secondaryInputAddresses': secondaryInputAddressList,
    'output': outputList,
  };
  return m;
}

({
  int selfKey,
  PointBoolean topLeftCorner,
  List<InputPort> primaryInputs,
  List<InputAddress> primaryInputAddresses,
  List<InputPort> secondaryInputs,
  List<InputAddress> secondaryInputAddresses,
  List<OutputPort> output,
}) BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(Map m) {
  List<InputPort> primaryInputs = [];
  for (Map primaryInputMap in m['primaryInputs']) {
    primaryInputs.add(
        InputPort.BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
            primaryInputMap));
  }

  List<InputAddress> primaryInputAddresses = [];
  for (Map primaryInputAddressMap in m['primaryInputAddresses']) {
    primaryInputAddresses.add(
        InputAddress.BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
            primaryInputAddressMap));
  }

  List<InputPort> secondaryInputs = [];
  for (Map secondaryInputMap in m['secondaryInputs']) {
    secondaryInputs.add(
        InputPort.BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
            secondaryInputMap));
  }

  List<InputAddress> secondaryInputAddresses = [];
  for (Map secondaryInputAddressMap in m['primaryInputAddresses']) {
    secondaryInputAddresses.add(
        InputAddress.BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
            secondaryInputAddressMap));
  }

  List<OutputPort> output = [];
  for (Map outputPort in m['output']) {
    output.add(OutputPort.BUILD_FROM_MAP_CONTAINING_FIELDS_AND_VALUES_AS_STRING(
        outputPort));
  }

  return (
    selfKey: int.parse(m['selfKey']),
    topLeftCorner: PointBoolean.BUILD_FROM(m['topLeftCorner']),
    primaryInputs: primaryInputs,
    primaryInputAddresses: primaryInputAddresses,
    secondaryInputs: secondaryInputs,
    secondaryInputAddresses: secondaryInputAddresses,
    output: output,
  );
}

class And implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();

  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'and i/p 1', portType: [PortType.boolean], value: false),
    InputPort(label: 'and i/p 2', portType: [PortType.boolean], value: false),
  ];

  @override
  List<InputAddress> primaryInputAddresses = [];

  @override
  List<InputPort> secondaryInputs = [];

  @override
  List<InputAddress> secondaryInputAddresses = [];

  @override
  List<OutputPort> output = [
    OutputPort(label: 'and O/p', portType: [PortType.boolean], value: false),
  ];

  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    output.first.value = true;
    for (InputPort inputPort in primaryInputs) {
      output.first.value = output.first.value && inputPort.value;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  And COPY() {
    And andBlock = And();
    andBlock.selfKey = selfKey;
    andBlock.topLeftCorner = topLeftCorner.copy;
    andBlock.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      andBlock.primaryInputs.add(inputPort.copy);
    }
    andBlock.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      andBlock.secondaryInputs.add(inputPort.copy);
    }
    andBlock.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      andBlock.primaryInputAddresses.add(inputAddress.COPY);
    }
    andBlock.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      andBlock.secondaryInputAddresses.add(inputAddress.COPY);
    }
    andBlock.output.clear();
    for (var outputPort in output) {
      andBlock.output.add(outputPort.copy);
    }
    return andBlock;
  }

  static And BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    And andBlock = And();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    andBlock.selfKey = retVal.selfKey;
    andBlock.topLeftCorner = retVal.topLeftCorner;
    andBlock.output = retVal.output;
    andBlock.primaryInputAddresses = retVal.primaryInputAddresses;
    andBlock.primaryInputs = retVal.primaryInputs;
    andBlock.secondaryInputAddresses = retVal.secondaryInputAddresses;
    andBlock.secondaryInputs = retVal.secondaryInputs;

    return andBlock;
  }
}

class Or implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'or i/p 1', portType: [PortType.boolean], value: false),
    InputPort(label: 'or i/p 2', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(label: 'or o/p', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    output.first.value = false;
    for (InputPort inputPort in primaryInputs) {
      output.first.value = output.first.value || inputPort.value;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Or COPY() {
    var block = Or();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Or BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    Or block = Or();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;

    return block;
  }
}

class Xor implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'xor i/p 1', portType: [PortType.boolean], value: false),
    InputPort(label: 'xor i/p 2', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(label: 'xor o/p', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (primaryInputs.first.value == false && primaryInputs[1].value == false) {
      output.first.value = false;
    } else if (primaryInputs.first.value == true &&
        primaryInputs[1].value == true) {
      output.first.value = false;
    } else {
      output.first.value = true;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Xor COPY() {
    var block = Xor();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Xor BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Xor();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;

    return block;
  }
}

class Not implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'not i/p', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(label: 'not o/p', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    output.first.value = !primaryInputs.first.value;
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Not COPY() {
    var block = Not();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Not BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Not();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;

    return block;
  }
}

///If Set is true, and Reset is true,
///then output is true
class ResetSet implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'Reset', portType: [PortType.boolean], value: false),
    InputPort(label: 'Set', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'Reset_Set o/p', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (primaryInputs[0].value == true && primaryInputs[1].value == true) {
      output[0].value = true;
    } else if (primaryInputs[0].value == false &&
        primaryInputs[1].value == true) {
      output[0].value = true;
    } else if (primaryInputs[0].value == true &&
        primaryInputs[1].value == false) {
      output[0].value = false;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  ResetSet COPY() {
    var block = ResetSet();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static ResetSet BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ResetSet();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;

    return block;
  }
}

///If Set is true, and Reset is true,
///then output is false
class SetReset implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'Set', portType: [PortType.boolean], value: false),
    InputPort(label: 'Reset', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'Set_Reset o/p', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (primaryInputs[0].value == true && primaryInputs[1].value == true) {
      output[0].value = false;
    } else if (primaryInputs[0].value == false &&
        primaryInputs[1].value == true) {
      output[0].value = false;
    } else if (primaryInputs[0].value == true &&
        primaryInputs[1].value == false) {
      output[0].value = true;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SetReset COPY() {
    var block = SetReset();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SetReset BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SetReset();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;

    return block;
  }
}

class FallingEdgeDetector implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
        label: 'falling pulse detector i/p',
        portType: [PortType.boolean],
        value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'falling pulse detector o/p',
        portType: [PortType.boolean],
        value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (previousInput == true && primaryInputs.first.value == false) {
      output.first.value = true;
    } else {
      output.first.value = false;
    }
    previousInput = primaryInputs.first.value;
  }

  //Block specific fields
  bool previousInput = false;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['previousInput'] = previousInput.toString();
    return jsonEncode(m);
  }

  @override
  FallingEdgeDetector COPY() {
    var block = FallingEdgeDetector();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.previousInput = previousInput;
    return block;
  }

  static FallingEdgeDetector BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = FallingEdgeDetector();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.previousInput = boolString.FROM_STRING(m['previousInput']);
    return block;
  }
}

class RisingEdgeDetector implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
        label: 'rising pulse detector i/p',
        portType: [PortType.boolean],
        value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'rising pulse detector o/p',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (previousInput == false && primaryInputs.first.value == true) {
      output.first.value = true;
    } else {
      output.first.value = false;
    }
    previousInput = primaryInputs.first.value;
  }

  //block specific fields
  bool previousInput = false;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['previousInput'] = previousInput.toString();
    return jsonEncode(m);
  }

  @override
  RisingEdgeDetector COPY() {
    var block = RisingEdgeDetector();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.previousInput = previousInput;
    return block;
  }

  static RisingEdgeDetector BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = RisingEdgeDetector();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.previousInput = boolString.FROM_STRING(m['previousInput']);
    return block;
  }
}

/// Primary inputs
/// - Priority 4
/// - Priority 3
/// - Priority 2
/// - Priority 1
///
/// Outputs
/// 1. y<sub>1</sub>
/// 2. y<sub>0</sub>
/// 3. Invalid
///
/// ## Truth table of priority encoder
/// P<sub>4</sub>,|P<sub>3</sub>,| P<sub>2</sub>,| P<sub>1</sub>,| Y<sub>1</sub>,|Y<sub>0</sub>,|Invalid
///---|---|---|---|---|---|---
///0| 0|   0|     0|     0|     0|     1
/// X| X| X|1|0|0|0
/// X |   X |    1 |    0 |    0|     1 |    0
/// X  |  1   |  0  |   0   |  1   |  1   |  0
/// 1   | 0|     0  |   0 |    1|     1|     0
class PriorityEncoder implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Priority 2',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Priority 1',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'y0',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Invalid',
      portType: [PortType.boolean],
      value: true,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    int outputAsInteger = 0;
    bool invalidBit = true;
    for (int i = 0; i < primaryInputs.length; ++i) {
      if (primaryInputs[i].value) {
        outputAsInteger = i;
        invalidBit = false;
        break;
      }
    }

    var binaryList = BooleanMethods.binaryFromDecimal(outputAsInteger);

    for (int index = 0; index < binaryList.length; ++index) {
      output[index].value = binaryList[index];
    }

    output.last.value = invalidBit;
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  PriorityEncoder COPY() {
    var block = PriorityEncoder();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static PriorityEncoder BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = PriorityEncoder();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class BinaryMux implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
        label: 'Boolean Input: x1', portType: [PortType.boolean], value: false),
    InputPort(
        label: 'Boolean Input: x0', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
        label: 'Select bit: D0', portType: [PortType.boolean], value: false),
    InputPort(label: 'Disable bit', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(label: 'Output', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (secondaryInputs.last.value) {
      output.first.value = false;
    } else {
      if (secondaryInputs.first.value) {
        output.first.value = primaryInputs.first.value;
      } else {
        output.first.value = primaryInputs[1].value;
      }
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  BinaryMux COPY() {
    var block = BinaryMux();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static BinaryMux BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = BinaryMux();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class AnalogMux implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Disable input',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Input: x1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Input: x0',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
        label: 'Select bit : D0', portType: [PortType.boolean], value: false),
    InputPort(label: 'Disable bit', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Integer Output',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];

  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    if (secondaryInputs.last.value) {
      output.first.value = primaryInputs.first.value.COPY;
    } else {
      List<bool> binaryAsBoolean = [];
      for (int i = 0; i < secondaryInputs.length - 1; ++i) {
        binaryAsBoolean.add(secondaryInputs[i].value);
      }

      final int PRIMARY_INPUT_PORT_NUMBER =
          BooleanMethods.decimalFromBinary(binaryAsBoolean);

      final int INDEX_OF_INPUT =
          primaryInputs.length - 1 - PRIMARY_INPUT_PORT_NUMBER;

      output.first.value = primaryInputs[INDEX_OF_INPUT].value.COPY;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  AnalogMux COPY() {
    var block = AnalogMux();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static AnalogMux BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = AnalogMux();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class SetResetAnalog implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Set Value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Reset Value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(label: 'Set', portType: [PortType.boolean], value: false),
    InputPort(label: 'Reset', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Latch Value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool SET_BIT = secondaryInputs[0].value;
    final bool RESET_BIT = secondaryInputs[1].value;
    final SET_VALUE = primaryInputs[0].value.COPY;
    final RESET_VALUE = primaryInputs[1].value.COPY;

    if (SET_BIT && RESET_BIT) {
      output.first.value = RESET_VALUE;
    } else if (!SET_BIT && RESET_BIT) {
      output.first.value = RESET_VALUE;
    } else if (SET_BIT && !RESET_BIT) {
      output.first.value = SET_VALUE;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  SetResetAnalog COPY() {
    var block = SetResetAnalog();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static SetResetAnalog BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SetResetAnalog();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class ResetSetAnalog implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Reset Value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Set Value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(label: 'Reset', portType: [PortType.boolean], value: false),
    InputPort(label: 'Set', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Latch Value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool SET_BIT = secondaryInputs[1].value;
    final bool RESET_BIT = secondaryInputs[0].value;
    final SET_VALUE = primaryInputs[1].value.COPY;
    final RESET_VALUE = primaryInputs[0].value.COPY;

    if (SET_BIT && RESET_BIT) {
      output.first.value = SET_VALUE;
    } else if (!SET_BIT && RESET_BIT) {
      output.first.value = RESET_VALUE;
    } else if (SET_BIT && !RESET_BIT) {
      output.first.value = SET_VALUE;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  ResetSetAnalog COPY() {
    var block = ResetSetAnalog();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static ResetSetAnalog BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ResetSetAnalog();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class CompareLessThan implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Compare: less than : i/p 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Compare: less than : i/p 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Compare: less than : o/p',
      portType: [PortType.boolean],
      value: true,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer VALUE_1 = primaryInputs[0].value;
        Integer VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.LESS_THAN(VALUE_2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger VALUE_1 = primaryInputs[0].value;
        DoubleInteger VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.LESS_THAN(VALUE_2);
        break;
      case CompareBlockDataType.real:
        Real VALUE_1 = primaryInputs[0].value;
        Real VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.LESS_THAN(VALUE_2);
        break;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  CompareLessThan COPY() {
    var block = CompareLessThan();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static CompareLessThan BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CompareLessThan();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class CompareLessThanEqualTo implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Compare: less than or equal to : i/p 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Compare: less than or equal to : i/p 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Compare real: less than or equal to : o/p',
      portType: [PortType.boolean],
      value: true,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer VALUE_1 = primaryInputs[0].value;
        Integer VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.LESS_OR_EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger VALUE_1 = primaryInputs[0].value;
        DoubleInteger VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.LESS_OR_EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.real:
        Real VALUE_1 = primaryInputs[0].value;
        Real VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.LESS_THAN_OR_EQUAL_TO(VALUE_2);
        break;
    }
  }

  // block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  CompareLessThanEqualTo COPY() {
    var block = CompareLessThanEqualTo();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static CompareLessThanEqualTo BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CompareLessThanEqualTo();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class CompareGreaterThan implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Compare: greater than : i/p 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Compare: greater than : i/p 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Compare: greater than : o/p',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer VALUE_1 = primaryInputs[0].value;
        Integer VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.GREATER_THAN(VALUE_2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger VALUE_1 = primaryInputs[0].value;
        DoubleInteger VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.GREATER_THAN(VALUE_2);
        break;
      case CompareBlockDataType.real:
        Real VALUE_1 = primaryInputs[0].value;
        Real VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.GREATER_THAN(VALUE_2);
        break;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  CompareGreaterThan COPY() {
    var block = CompareGreaterThan();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static CompareGreaterThan BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CompareGreaterThan();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class CompareGreaterThanEqualTo implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Compare: greater than or equal to : i/p 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Compare: greater than or equal to : i/p 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Compare: greater than or equal to : o/p',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer VALUE_1 = primaryInputs[0].value;
        Integer VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.GREATER_OR_EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger VALUE_1 = primaryInputs[0].value;
        DoubleInteger VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.GREATER_OR_EQUAL(VALUE_2);
        break;
      case CompareBlockDataType.real:
        Real VALUE_1 = primaryInputs[0].value;
        Real VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.GREATER_THAN_OR_EQUAL_TO(VALUE_2);
        break;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  CompareGreaterThanEqualTo COPY() {
    var block = CompareGreaterThanEqualTo();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static CompareGreaterThanEqualTo BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CompareGreaterThanEqualTo();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class CompareEqualTo implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Compare: equal to : i/p 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Compare: equal to : i/p 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Compare: equal to : o/p',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer VALUE_1 = primaryInputs[0].value;
        Integer VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger VALUE_1 = primaryInputs[0].value;
        DoubleInteger VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.real:
        Real VALUE_1 = primaryInputs[0].value;
        Real VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.EQUAL_TO(VALUE_2);
        break;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  CompareEqualTo COPY() {
    var block = CompareEqualTo();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static CompareEqualTo BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CompareEqualTo();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class CompareNotEqualTo implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Compare: not equal to : i/p 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Compare: not equal to : i/p 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Compare: not equal to : o/p',
      portType: [PortType.boolean],
      value: true,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer VALUE_1 = primaryInputs[0].value;
        Integer VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.NOT_EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger VALUE_1 = primaryInputs[0].value;
        DoubleInteger VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.NOT_EQUAL_TO(VALUE_2);
        break;
      case CompareBlockDataType.real:
        Real VALUE_1 = primaryInputs[0].value;
        Real VALUE_2 = primaryInputs[1].value;
        output.first.value = VALUE_1.NOT_EQUAL_TO(VALUE_2);
        break;
    }
  }

  // block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  CompareNotEqualTo COPY() {
    var block = CompareNotEqualTo();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static CompareNotEqualTo BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CompareNotEqualTo();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class SourceBooleanFalse implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'Boolean False', portType: [PortType.boolean], value: false),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {}
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourceBooleanFalse COPY() {
    var block = SourceBooleanFalse();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourceBooleanFalse BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourceBooleanFalse();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SourceBooleanTrue implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'Boolean True', portType: [PortType.boolean], value: true),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {}
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourceBooleanTrue COPY() {
    var block = SourceBooleanTrue();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourceBooleanTrue BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourceBooleanTrue();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SourceInteger implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'Integer',
        portType: [PortType.integer],
        value: Integer.FROM_INT(0)),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    //empty process block
  }
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourceInteger COPY() {
    var block = SourceInteger();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourceInteger BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourceInteger();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SourceDoubleInteger implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Double Integer',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    //empty process block
  }
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourceDoubleInteger COPY() {
    var block = SourceDoubleInteger();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourceDoubleInteger BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourceDoubleInteger();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SourceReal implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Real',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    //empty block
  }
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourceReal COPY() {
    var block = SourceReal();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourceReal BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourceReal();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SourceExponent implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'e',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(e),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {}
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourceExponent COPY() {
    var block = SourceExponent();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourceExponent BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourceExponent();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SourcePi implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'e',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(pi),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {}
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SourcePi COPY() {
    var block = SourcePi();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SourcePi BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SourcePi();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class ConvertToInteger implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Integer or Double Integer or Real',
      portType: [PortType.integer, PortType.doubleInteger, PortType.real],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Integer',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (primaryInputs.first.value.runtimeType) {
      case Integer:
        output.first.value = primaryInputs.first.value.COPY;
        break;
      case DoubleInteger:
        output.first.value =
            Integer.FROM_DOUBLE_INTEGER(primaryInputs.first.value);
        break;
      case Real:
        output.first.value = Integer.FROM_REAL(primaryInputs.first.value);
        break;
      default:
        output.first.value = Integer.FROM_INT(0);
        break;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  ConvertToInteger COPY() {
    var block = ConvertToInteger();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static ConvertToInteger BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ConvertToInteger();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class ConvertToDoubleInteger implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Integer or Double Integer or Real',
      portType: [PortType.integer, PortType.doubleInteger, PortType.real],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Double Integer',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (primaryInputs.first.value.runtimeType) {
      case Integer:
        output.first.value =
            DoubleInteger.FROM_INTEGER(primaryInputs.first.value);
        break;
      case DoubleInteger:
        output.first.value = primaryInputs.first.value.COPY;
        break;
      case Real:
        output.first.value = DoubleInteger.FROM_REAL(primaryInputs.first.value);
        break;
      default:
        output.first.value = DoubleInteger.FROM_INT(0);
        break;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  ConvertToDoubleInteger COPY() {
    var block = ConvertToDoubleInteger();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static ConvertToDoubleInteger BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ConvertToDoubleInteger();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class ConvertToReal implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Integer or Double Integer or Real',
      portType: [PortType.integer, PortType.doubleInteger, PortType.real],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Real',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (primaryInputs.first.value.runtimeType) {
      case Integer:
        output.first.value = Real.FROM_INTEGER(primaryInputs.first.value);
        break;
      case DoubleInteger:
        output.first.value =
            Real.FROM_DOUBLE_INTEGER(primaryInputs.first.value);
        break;
      case Real:
        output.first.value = primaryInputs.first.value.COPY;
        break;
      default:
        output.first.value = Real.FROM_DOUBLE(0);
        break;
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  ConvertToReal COPY() {
    var block = ConvertToReal();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static ConvertToReal BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ConvertToReal();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Add implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'operand 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'operand 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Addition Result',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];

  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer addResult = Integer.FROM_INT(0);
        for (var inputElement in primaryInputs) {
          addResult = addResult.ADD(inputElement.value);
        }
        output.first.value = addResult.COPY;
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger addResult = DoubleInteger.FROM_INT(0);
        for (var inputElement in primaryInputs) {
          addResult = addResult.ADD(inputElement.value);
        }
        output.first.value = addResult.COPY;
        break;
      case CompareBlockDataType.real:
        Real addResult = Real.FROM_DOUBLE(0);
        for (var inputElement in primaryInputs) {
          addResult = addResult.ADD(inputElement.value);
        }
        output.first.value = addResult.COPY;
        break;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  Add COPY() {
    var block = Add();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static Add BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Add();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class Subtract implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Minuend',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Subtrahend',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Minuend - Subtrahend',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    dynamic result;
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer INT1 = primaryInputs[0].value;
        Integer INT2 = primaryInputs[1].value;
        result = INT1.SUBTRACT(INT2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger DINT1 = primaryInputs[0].value;
        DoubleInteger DINT2 = primaryInputs[1].value;
        result = DINT1.SUBTRACT(DINT2);
        break;
      case CompareBlockDataType.real:
        Real REAL1 = primaryInputs[0].value;
        Real REAL2 = primaryInputs[1].value;
        result = REAL1.SUBTRACT(REAL2);
        break;
    }
    output.first.value = result.COPY;
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  Subtract COPY() {
    var block = Subtract();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static Subtract BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Subtract();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class Multiply implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Operand 1',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Operand 2',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Multiplication Result',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer result = Integer.FROM_INT(0);
        for (var inputElement in primaryInputs) {
          result = result.MULTIPLY(inputElement.value);
        }
        output.first.value = result.COPY;
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger result = DoubleInteger.FROM_INT(0);
        for (var inputElement in primaryInputs) {
          result = result.MULTIPLY(inputElement.value);
        }
        output.first.value = result.COPY;
        break;
      case CompareBlockDataType.real:
        Real result = Real.FROM_DOUBLE(0);
        for (var inputElement in primaryInputs) {
          result = result.MULTIPLY(inputElement.value);
        }
        output.first.value = result.COPY;
        break;
    }
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  Multiply COPY() {
    var block = Multiply();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static Multiply BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Multiply();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class Divide implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Divident',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Divisor',
      portType: [PortType.integer],
      value: Integer.FROM_INT(1),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Divident/Divisor',
      portType: [PortType.integer],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    dynamic result;
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer INT1 = primaryInputs[0].value;
        Integer INT2 = primaryInputs[1].value;
        result = INT1.DIVIDE_BY(INT2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger DINT1 = primaryInputs[0].value;
        DoubleInteger DINT2 = primaryInputs[1].value;
        result = DINT1.DIVIDE_BY(DINT2);
        break;
      case CompareBlockDataType.real:
        Real REAL1 = primaryInputs[0].value;
        Real REAL2 = primaryInputs[1].value;
        result = REAL1.DIVIDE_BY(REAL2);
        break;
    }
    output.first.value = result.COPY;
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  Divide COPY() {
    var block = Divide();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static Divide BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Divide();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class Remainder implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Divident',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Divisor',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Divident % Divisor',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    dynamic result;
    switch (dropdown) {
      case CompareBlockDataType.integer:
        Integer INT1 = primaryInputs[0].value;
        Integer INT2 = primaryInputs[1].value;
        result = INT1.REMAINDER(INT2);
        break;
      case CompareBlockDataType.doubleInteger:
        DoubleInteger DINT1 = primaryInputs[0].value;
        DoubleInteger DINT2 = primaryInputs[1].value;
        result = DINT1.REMAINDER(DINT2);
        break;
      case CompareBlockDataType.real:
        Real REAL1 = primaryInputs[0].value;
        Real REAL2 = primaryInputs[1].value;
        result = REAL1.REMAINDER(REAL2);
        break;
    }
    output.first.value = result.COPY;
  }

  //block specific fields
  CompareBlockDataType dropdown = CompareBlockDataType.integer;
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = dropdown.toString();
    return jsonEncode(m);
  }

  @override
  Remainder COPY() {
    var block = Remainder();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    return block;
  }

  static Remainder BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Remainder();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = getCompareBlockDataTypeFromString(m['dropdown']);
    return block;
  }
}

class Exponent implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'base',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(1),
    ),
    InputPort(
      label: 'exponent',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'base ^ exponent',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(1),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    Real BASE = primaryInputs[0].value;
    Real EXP = primaryInputs[1].value;
    output.first.value = BASE.POW(EXP);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Exponent COPY() {
    var block = Exponent();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Exponent BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Exponent();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Log implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'antilogarithm',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(1),
    ),
    InputPort(
      label: 'base',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(10),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'log base (antilogarithm)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(1),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    Real ANTILOG = primaryInputs.first.value;
    Real BASE = primaryInputs[1].value;
    output.first.value = ANTILOG.LOG(BASE);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Log COPY() {
    var block = Log();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Log BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Log();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class SquareRoot implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'number',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'square root',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    Real REAL = primaryInputs.first.value;
    output.first.value = REAL.SQUARE_ROOT();
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  SquareRoot COPY() {
    var block = SquareRoot();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static SquareRoot BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = SquareRoot();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Sin implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'angle',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'input true for degrees, false for radians',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'sin(angle)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool IS_ANGLE_IN_DEGREES = secondaryInputs.first.value;
    final Real VAL = primaryInputs.first.value;
    output.first.value = VAL.SIN(IS_ANGLE_IN_DEGREES);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Sin COPY() {
    var block = Sin();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Sin BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Sin();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Cos implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'angle',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'input true for degrees, false for radians',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'cos(angle)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(1),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool IS_ANGLE_IN_DEGREES = secondaryInputs.first.value;
    final Real VAL = primaryInputs.first.value;
    output.first.value = VAL.COS(IS_ANGLE_IN_DEGREES);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Cos COPY() {
    var block = Cos();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Cos BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Cos();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Tan implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'angle',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'input true for degrees, false for radians',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'tan(angle)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool IS_ANGLE_IN_DEGREES = secondaryInputs.first.value;
    final Real VAL = primaryInputs.first.value;
    output.first.value = VAL.TAN(IS_ANGLE_IN_DEGREES);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Tan COPY() {
    var block = Tan();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Tan BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Tan();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Asin implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'value',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'true for degrees, false for radians',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'asin(value)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool IS_ANGLE_IN_DEGREES = secondaryInputs.first.value;
    final Real VAL = primaryInputs.first.value;
    output.first.value = VAL.ASIN(IS_ANGLE_IN_DEGREES);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Asin COPY() {
    var block = Asin();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Asin BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Asin();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Acos implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'value',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'true for degrees, false for radians',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'acos(value)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(pi / 2),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool IS_ANGLE_IN_DEGREES = secondaryInputs.first.value;
    final Real VAL = primaryInputs.first.value;
    output.first.value = VAL.ACOS(IS_ANGLE_IN_DEGREES);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Acos COPY() {
    var block = Acos();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Acos BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Acos();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class Atan implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'value',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'true for degrees, false for radians',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'atan(value)',
      portType: [PortType.real],
      value: Real.FROM_DOUBLE(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool IS_ANGLE_IN_DEGREES = secondaryInputs.first.value;
    final Real VAL = primaryInputs.first.value;
    output.first.value = VAL.ATAN(IS_ANGLE_IN_DEGREES);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Atan COPY() {
    var block = Atan();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Atan BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Atan();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

///if reset to initial value and reset to final value both occur at same time
///then reset to initial value is executed
///
///if UP input and DN input both occur at same time, then first UP then DN
///is executed
class Counter implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label:
          'UP input(Counts Up)\n(generally input to this port should be passed via Rising Edge detector or Falling edge detector)',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label:
          'DN input(Counts Down)\n(generally input to this port should be passed via Rising Edge detector or Falling edge detector)',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Initial value of counter (default value=0)',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
    InputPort(
      label: 'Final value of counter (default value=999)',
      portType: [PortType.integer],
      value: Integer.FROM_INT(999),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'Reset to Initial value',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Reset to Final value',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'UP Counter output (true when counter count equals final value)',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'DN Counter output (true when counter count equals initial value)',
      portType: [PortType.boolean],
      value: true,
    ),
    OutputPort(
      label: 'Count as integer value',
      portType: [PortType.integer],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final Integer INITIAL_VALUE = primaryInputs[2].value;
    final Integer FINAL_VALUE = primaryInputs[3].value;
    const int UP_INDEX = 0, DN_INDEX = 1, COUNT_INDEX = 2;
    final bool RESET_TO_INITIAL = secondaryInputs.first.value;
    final bool RESET_TO_FINAL = secondaryInputs[1].value;
    final bool UP_INPUT = primaryInputs[0].value;
    final bool DN_INPUT = primaryInputs[1].value;

    if (RESET_TO_INITIAL) {
      output[COUNT_INDEX].value = INITIAL_VALUE.COPY;
      output[UP_INDEX].value = false;
      output[DN_INDEX].value = true;
    } else if (RESET_TO_FINAL) {
      output[COUNT_INDEX].value = FINAL_VALUE.COPY;
      output[UP_INDEX].value = true;
      output[DN_INDEX].value = false;
    } else {
      if (UP_INPUT) {
        final Integer OLD_COUNT_VAL = output[COUNT_INDEX].value;
        final Integer NEW_VAL = OLD_COUNT_VAL.ADD(Integer.FROM_INT(1));
        if (NEW_VAL.EQUAL_TO(FINAL_VALUE)) {
          output[UP_INDEX].value = true;
          output[DN_INDEX].value = false;
          output[COUNT_INDEX].value = FINAL_VALUE.COPY;
        } else if (NEW_VAL.GREATER_THAN(FINAL_VALUE)) {
          output[UP_INDEX].value = false;
          output[DN_INDEX].value = true;
          output[COUNT_INDEX].value = INITIAL_VALUE.COPY;
        } else {
          output[UP_INDEX].value = false;
          output[DN_INDEX].value = false;
          output[COUNT_INDEX].value = NEW_VAL;
        }
      }

      if (DN_INPUT) {
        final Integer OLD_COUNT_VAL = output[COUNT_INDEX].value;
        final Integer NEW_VAL = OLD_COUNT_VAL.SUBTRACT(Integer.FROM_INT(1));
        if (NEW_VAL.EQUAL_TO(INITIAL_VALUE)) {
          output[UP_INDEX].value = false;
          output[DN_INDEX].value = true;
          output[COUNT_INDEX].value = INITIAL_VALUE.COPY;
        } else if (NEW_VAL.LESS_THAN(INITIAL_VALUE)) {
          output[UP_INDEX].value = true;
          output[DN_INDEX].value = false;
          output[COUNT_INDEX].value = FINAL_VALUE.COPY;
        } else {
          output[UP_INDEX].value = false;
          output[DN_INDEX].value = false;
          output[COUNT_INDEX].value = NEW_VAL;
        }
      }
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  Counter COPY() {
    var block = Counter();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static Counter BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = Counter();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class PWM implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'Time period of PWM wave (in multiple of 0.1 seconds)',
      portType: [PortType.integer],
      value: Integer.FROM_INT(10),
    ),
    InputPort(
      label: 'Duty cycle in percentage 1 to 100',
      portType: [PortType.integer],
      value: Integer.FROM_INT(100),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'Enable',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];

  List<InputPort> previousInput = [];

  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'PWM output',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final Integer TIME_PERIOD_IN_DECI_SECOND = primaryInputs[0].value;
    final Integer DUTY_CYCLE = primaryInputs[1].value;

    if (!secondaryInputs.first.value) {
      output.first.value = false;
      _cycleInProgress = false;
    } else {
      _timePeriod =
          Duration(milliseconds: TIME_PERIOD_IN_DECI_SECOND.VALUE * 100);
      _timeOn = _timePeriod * (primaryInputs[1].value.value / 100);

      if (!_cycleInProgress) {
        _cycleInProgress = true;
        _cycleStartEpoch = DateTime.now();
        if (DUTY_CYCLE.EQUAL_TO(Integer.FROM_INT(0))) {
          output.first.value = false;
        } else {
          output.first.value = true;
        }
      } else {
        _timePassedSinceCycleStart =
            DateTime.now().difference(_cycleStartEpoch);

        if (_timePassedSinceCycleStart >= _timeOn) {
          output.first.value = false;
        } else if (_timePassedSinceCycleStart >= _timePeriod) {
          _cycleInProgress = false;
        }
      }
    }
  }

  //block related fields
  Duration _timePeriod = const Duration(seconds: 0);
  Duration _timeOn = const Duration(seconds: 0);
  DateTime _cycleStartEpoch = DateTime(0);
  Duration _timePassedSinceCycleStart = const Duration(seconds: 0);
  bool _cycleInProgress = false;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_timePeriod'] = TypeConversion.STRING_FROM_DURATION(_timePeriod);
    m['_timeOn'] = TypeConversion.STRING_FROM_DURATION(_timeOn);
    m['_cycleStartEpoch'] =
        TypeConversion.STRING_FROM_DATETIME(_cycleStartEpoch);
    m['_timePassedSinceCycleStart'] =
        TypeConversion.STRING_FROM_DURATION(_timePassedSinceCycleStart);
    m['_cycleInProgress'] = TypeConversion.STRING_FROM_BOOL(_cycleInProgress);
    return jsonEncode(m);
  }

  @override
  PWM COPY() {
    var block = PWM();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._timePeriod = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_timePeriod));
    block._timeOn = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_timeOn));
    block._timePassedSinceCycleStart = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_timePassedSinceCycleStart));
    block._cycleInProgress = _cycleInProgress;
    block._cycleStartEpoch = TypeConversion.DATETIME_FROM_STRING(
        TypeConversion.STRING_FROM_DATETIME(_cycleStartEpoch));

    return block;
  }

  static PWM BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = PWM();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._timePeriod = TypeConversion.DURATION_FROM_STRING(m['_timePeriod']);
    block._timeOn = TypeConversion.DURATION_FROM_STRING(m['_timeOn']);
    block._timePassedSinceCycleStart =
        TypeConversion.DURATION_FROM_STRING(m['_timePassedSinceCycleStart']);
    block._cycleStartEpoch =
        TypeConversion.DATETIME_FROM_STRING(m['_cycleStartEpoch']);
    block._cycleInProgress =
        TypeConversion.BOOL_FROM_STRING(m['_cycleInProgress']);
    return block;
  }
}

class OnDelayTimer implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'IN',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Preset time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(20),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // @override
  // List<InputPort> previousInput = [];

  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'OUT',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting in progress',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting Complete',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Accumulated time',
      portType: [PortType.doubleInteger],
      value: Integer.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool INPUT = primaryInputs.first.value;
    final DoubleInteger PRESET_TIME = primaryInputs[1].value;
    if (!INPUT) {
      output[_OUT_INDEX].value = false;
      output[_COUNTING_IN_PROGRESS_INDEX].value = false;
      output[_COUNTING_COMPLETE_INDEX].value = false;
      output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
      _accumulated = Duration.zero;
      _countingStart = false;
    } else if (_countingStart && output[_COUNTING_COMPLETE_INDEX].value) {
    } else {
      switch (dropdown) {
        case TimerBase.zeroPointOne:
          _preset = Duration(milliseconds: PRESET_TIME.VALUE * 100);
          break;
        case TimerBase.one:
          _preset = Duration(seconds: PRESET_TIME.VALUE);
          break;
        case TimerBase.ten:
          _preset = Duration(seconds: PRESET_TIME.VALUE * 10);
          break;
        case TimerBase.minute:
          _preset = Duration(minutes: PRESET_TIME.VALUE);
          break;
        case TimerBase.hour:
          _preset = Duration(hours: PRESET_TIME.VALUE);
          break;
      }

      if (!_countingStart) {
        _countingStart = true;
        _timerStartEpoch = DateTime.now();
        if (PRESET_TIME.EQUAL_TO(DoubleInteger.FROM_INT(0))) {
          output[_OUT_INDEX].value = true;
          output[_COUNTING_IN_PROGRESS_INDEX].value = false;
          output[_COUNTING_COMPLETE_INDEX].value = true;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
        } else {
          output[_OUT_INDEX].value = false;
          output[_COUNTING_IN_PROGRESS_INDEX].value = true;
          output[_COUNTING_COMPLETE_INDEX].value = false;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
        }
      } else {
        _accumulated = DateTime.now().difference(_timerStartEpoch);

        if (_accumulated >= _preset) {
          output[_OUT_INDEX].value = true;
          output[_COUNTING_IN_PROGRESS_INDEX].value = false;
          output[_COUNTING_COMPLETE_INDEX].value = true;
          // DoubleInteger PRESET = input[1].value;
          output[_ACCUMULATED_TIME_INDEX].value = PRESET_TIME.COPY;
        } else {
          int accum;
          switch (dropdown) {
            case TimerBase.zeroPointOne:
              accum = _accumulated.inMilliseconds ~/ 100;
              break;
            case TimerBase.one:
              accum = _accumulated.inSeconds.toInt();
              break;
            case TimerBase.ten:
              accum = _accumulated.inSeconds ~/ 10;
              break;
            case TimerBase.minute:
              accum = _accumulated.inMinutes.toInt();
              break;
            case TimerBase.hour:
              accum = _accumulated.inHours.toInt();
              break;
          }

          output[_OUT_INDEX].value = false;
          output[_COUNTING_IN_PROGRESS_INDEX].value = true;
          output[_COUNTING_COMPLETE_INDEX].value = false;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(accum);
        }
      }
    }
  }

  //block related fields
  TimerBase dropdown = TimerBase.one;
  Duration _preset = const Duration(milliseconds: 0);
  DateTime _timerStartEpoch = DateTime(0);
  Duration _accumulated = const Duration(milliseconds: 0);
  bool _countingStart = false;
  static const int _OUT_INDEX = 0,
      _COUNTING_IN_PROGRESS_INDEX = 1,
      _COUNTING_COMPLETE_INDEX = 2,
      _ACCUMULATED_TIME_INDEX = 3;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = TypeConversion.STRING_FROM_TIMERBASE(dropdown);
    m['_preset'] = TypeConversion.STRING_FROM_DURATION(_preset);
    m['_timerStartEpoch'] =
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch);
    m['_accumulated'] = TypeConversion.STRING_FROM_DURATION(_accumulated);
    m['_countingStart'] = TypeConversion.STRING_FROM_BOOL(_countingStart);
    return jsonEncode(m);
  }

  @override
  OnDelayTimer COPY() {
    var block = OnDelayTimer();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(
        TypeConversion.STRING_FROM_TIMERBASE(dropdown));
    block._preset = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_preset));
    block._accumulated = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_accumulated));
    block._countingStart = _countingStart;
    block._timerStartEpoch = TypeConversion.DATETIME_FROM_STRING(
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch));

    return block;
  }

  static OnDelayTimer BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = OnDelayTimer();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(m['dropdown']);
    block._preset = TypeConversion.DURATION_FROM_STRING(m['_preset']);
    block._accumulated = TypeConversion.DURATION_FROM_STRING(m['_accumulated']);
    block._timerStartEpoch =
        TypeConversion.DATETIME_FROM_STRING(m['_timerStartEpoch']);
    block._countingStart = TypeConversion.BOOL_FROM_STRING(m['_countingStart']);
    return block;
  }
}

class OffDelayTimer implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'IN',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Preset time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(20),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'OUT',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting in progress',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting Complete',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Accumulated time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool INPUT = primaryInputs.first.value;
    final DoubleInteger PRESET = primaryInputs[1].value;

    if (INPUT) {
      if (!_previousInputHigh) {
        _previousInputHigh = true;
        _accumulated = Duration.zero;
        output[_OUT_INDEX].value = true;
        output[_COUNTING_IN_PROGRESS_INDEX].value = false;
        output[_COUNTING_COMPLETE_INDEX].value = false;
        output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
      }
    } else {
      switch (dropdown) {
        case TimerBase.zeroPointOne:
          _preset = Duration(milliseconds: PRESET.VALUE * 100);
          break;
        case TimerBase.one:
          _preset = Duration(seconds: PRESET.VALUE);
          break;
        case TimerBase.ten:
          _preset = Duration(seconds: PRESET.VALUE * 10);
          break;
        case TimerBase.minute:
          _preset = Duration(minutes: PRESET.VALUE);
          break;
        case TimerBase.hour:
          _preset = Duration(hours: PRESET.VALUE);
          break;
      }

      if (_previousInputHigh) {
        _previousInputHigh = false;
        if (_preset == Duration.zero) {
          _accumulated = Duration.zero;
          output[_OUT_INDEX].value = false;
          output[_COUNTING_IN_PROGRESS_INDEX].value = false;
          output[_COUNTING_COMPLETE_INDEX].value = true;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
        } else {
          _timerStartEpoch = DateTime.now();
          _accumulated = Duration.zero;
          output[_COUNTING_IN_PROGRESS_INDEX].value = true;
          output[_COUNTING_COMPLETE_INDEX].value = false;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
        }
      } else {
        _accumulated = DateTime.now().difference(_timerStartEpoch);

        if (_accumulated >= _preset) {
          output[_OUT_INDEX].value = false;
          output[_COUNTING_IN_PROGRESS_INDEX].value = false;
          output[_COUNTING_COMPLETE_INDEX].value = true;
          output[_ACCUMULATED_TIME_INDEX].value = PRESET.COPY;
        } else {
          int accum;
          switch (dropdown) {
            case TimerBase.zeroPointOne:
              accum = _accumulated.inMilliseconds ~/ 100;
              break;
            case TimerBase.one:
              accum = _accumulated.inSeconds.toInt();
              break;
            case TimerBase.ten:
              accum = _accumulated.inSeconds ~/ 10;
              break;
            case TimerBase.minute:
              accum = _accumulated.inMinutes.toInt();
              break;
            case TimerBase.hour:
              accum = _accumulated.inHours.toInt();
              break;
          }
          output[_OUT_INDEX].value = true;
          output[_COUNTING_IN_PROGRESS_INDEX].value = true;
          output[_COUNTING_COMPLETE_INDEX].value = false;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(accum);
        }
      }
    }
  }

  //block related fields
  TimerBase dropdown = TimerBase.one;
  Duration _preset = const Duration(milliseconds: 0);
  DateTime _timerStartEpoch = DateTime(0);
  Duration _accumulated = const Duration(milliseconds: 0);
  bool _countingStart = false;
  bool _previousInputHigh = false;
  static const _OUT_INDEX = 0,
      _COUNTING_IN_PROGRESS_INDEX = 1,
      _COUNTING_COMPLETE_INDEX = 2,
      _ACCUMULATED_TIME_INDEX = 3;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = TypeConversion.STRING_FROM_TIMERBASE(dropdown);
    m['_preset'] = TypeConversion.STRING_FROM_DURATION(_preset);
    m['_timerStartEpoch'] =
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch);
    m['_accumulated'] = TypeConversion.STRING_FROM_DURATION(_accumulated);
    m['_countingStart'] = TypeConversion.STRING_FROM_BOOL(_countingStart);
    m['_previousInputHigh'] =
        TypeConversion.STRING_FROM_BOOL(_previousInputHigh);
    return jsonEncode(m);
  }

  @override
  OffDelayTimer COPY() {
    var block = OffDelayTimer();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(
        TypeConversion.STRING_FROM_TIMERBASE(dropdown));
    block._preset = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_preset));
    block._accumulated = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_accumulated));
    block._countingStart = _countingStart;
    block._timerStartEpoch = TypeConversion.DATETIME_FROM_STRING(
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch));
    block._previousInputHigh = _previousInputHigh;
    return block;
  }

  static OffDelayTimer BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = OffDelayTimer();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(m['dropdown']);
    block._preset = TypeConversion.DURATION_FROM_STRING(m['_preset']);
    block._accumulated = TypeConversion.DURATION_FROM_STRING(m['_accumulated']);
    block._timerStartEpoch =
        TypeConversion.DATETIME_FROM_STRING(m['_timerStartEpoch']);
    block._countingStart = TypeConversion.BOOL_FROM_STRING(m['_countingStart']);
    block._previousInputHigh =
        TypeConversion.BOOL_FROM_STRING(m['_previousInputHigh']);
    return block;
  }
}

class RetentiveOnDelayTimer implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'IN',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Preset time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(20),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [
    InputPort(
      label: 'Reset',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'OUT',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting in progress',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting Complete',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Accumulated time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final DoubleInteger PRESET = primaryInputs[1].value;
    final bool INPUT = primaryInputs.first.value;

    if (secondaryInputs.first.value) {
      output[_OUT_INDEX].value = false;
      output[_COUNTING_IN_PROGRESS_INDEX].value = false;
      output[_COUNTING_COMPLETE_INDEX].value = false;
      output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
      _accumulated = Duration.zero;
      _countingStart = false;
    } else if (INPUT) {
      if (_countingStart) {
        switch (dropdown) {
          case TimerBase.zeroPointOne:
            _preset = Duration(milliseconds: PRESET.VALUE * 100);
            break;
          case TimerBase.one:
            _preset = Duration(seconds: PRESET.VALUE);
            break;
          case TimerBase.ten:
            _preset = Duration(seconds: PRESET.VALUE * 10);
            break;
          case TimerBase.minute:
            _preset = Duration(minutes: PRESET.VALUE);
            break;
          case TimerBase.hour:
            _preset = Duration(hours: PRESET.VALUE);
            break;
        }

        _accumulated += DateTime.now().difference(_timerStartEpoch);
        if (_accumulated >= _preset) {
          output[_OUT_INDEX].value = true;
          output[_COUNTING_IN_PROGRESS_INDEX].value = false;
          output[_COUNTING_COMPLETE_INDEX].value = true;
          _countingStart = false;
          // DoubleInteger PRESET = block.input[1].value;
          output[_ACCUMULATED_TIME_INDEX].value = PRESET.COPY;
        } else {
          int accum;
          switch (dropdown) {
            case TimerBase.zeroPointOne:
              accum = _accumulated.inMilliseconds ~/ 100;
              break;
            case TimerBase.one:
              accum = _accumulated.inSeconds.toInt();
              break;
            case TimerBase.ten:
              accum = _accumulated.inSeconds ~/ 10;
              break;
            case TimerBase.minute:
              accum = _accumulated.inMinutes.toInt();
              break;
            case TimerBase.hour:
              accum = _accumulated.inHours.toInt();
              break;
          }

          output[_OUT_INDEX].value = false;
          output[_COUNTING_IN_PROGRESS_INDEX].value = true;
          output[_COUNTING_COMPLETE_INDEX].value = false;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(accum);
        }
      } else {
        if (output[_COUNTING_COMPLETE_INDEX].value) {
        } else if (PRESET.EQUAL_TO(DoubleInteger.FROM_INT(0))) {
          output[_OUT_INDEX].value = true;
          output[_COUNTING_IN_PROGRESS_INDEX].value = false;
          output[_COUNTING_COMPLETE_INDEX].value = true;
          output[_ACCUMULATED_TIME_INDEX].value = DoubleInteger.FROM_INT(0);
        } else {
          _timerStartEpoch = DateTime.now();
          _countingStart = true;
          output[_OUT_INDEX].value = false;
          output[_COUNTING_IN_PROGRESS_INDEX].value = true;
          output[_COUNTING_COMPLETE_INDEX].value = false;
          // block.output[3].value = DoubleInteger(0);
        }
      }
    } else {
      output[_COUNTING_IN_PROGRESS_INDEX].value = false;
    }
  }

  //block related fields
  TimerBase dropdown = TimerBase.one;
  Duration _preset = const Duration(milliseconds: 0);
  DateTime _timerStartEpoch = DateTime(0);
  Duration _accumulated = const Duration(milliseconds: 0);
  bool _countingStart = false;
  static const _OUT_INDEX = 0,
      _COUNTING_IN_PROGRESS_INDEX = 1,
      _COUNTING_COMPLETE_INDEX = 2,
      _ACCUMULATED_TIME_INDEX = 3;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = TypeConversion.STRING_FROM_TIMERBASE(dropdown);
    m['_preset'] = TypeConversion.STRING_FROM_DURATION(_preset);
    m['_timerStartEpoch'] =
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch);
    m['_accumulated'] = TypeConversion.STRING_FROM_DURATION(_accumulated);
    m['_countingStart'] = TypeConversion.STRING_FROM_BOOL(_countingStart);

    return jsonEncode(m);
  }

  @override
  RetentiveOnDelayTimer COPY() {
    var block = RetentiveOnDelayTimer();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(
        TypeConversion.STRING_FROM_TIMERBASE(dropdown));
    block._preset = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_preset));
    block._accumulated = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_accumulated));
    block._countingStart = _countingStart;
    block._timerStartEpoch = TypeConversion.DATETIME_FROM_STRING(
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch));
    return block;
  }

  static RetentiveOnDelayTimer BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = RetentiveOnDelayTimer();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(m['dropdown']);
    block._preset = TypeConversion.DURATION_FROM_STRING(m['_preset']);
    block._accumulated = TypeConversion.DURATION_FROM_STRING(m['_accumulated']);
    block._timerStartEpoch =
        TypeConversion.DATETIME_FROM_STRING(m['_timerStartEpoch']);
    block._countingStart = TypeConversion.BOOL_FROM_STRING(m['_countingStart']);
    return block;
  }
}

///Pulse timer starts counting when it detects rising edge of input pulse
///
///It does not matter if input pulse goes low, it keeps on counting.
///
///When counting completes, then output goes low.
///
///In case when counting is still in progress and input is low, if input pulse
///rises again, this event does not have any effect on counting process
class PulseTimer implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'IN',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Preset time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(20),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];

  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'OUT',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting in progress',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting Complete',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Accumulated time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool INPUT = primaryInputs[0].value;
    final DoubleInteger PRESET_TIME = primaryInputs[1].value;

    if (_countingInProgress) {
      switch (dropdown) {
        case TimerBase.zeroPointOne:
          _presetTime = Duration(milliseconds: PRESET_TIME.VALUE * 100);
          break;
        case TimerBase.one:
          _presetTime = Duration(seconds: PRESET_TIME.VALUE);
          break;
        case TimerBase.ten:
          _presetTime = Duration(seconds: PRESET_TIME.VALUE * 10);
          break;
        case TimerBase.minute:
          _presetTime = Duration(minutes: PRESET_TIME.VALUE);
          break;
        case TimerBase.hour:
          _presetTime = Duration(hours: PRESET_TIME.VALUE);
          break;
      }

      _accumulatedTime = DateTime.now().difference(_timerStartEpoch);

      if (_accumulatedTime >= _presetTime) {
        output[_INDEX_OUT].value = false;
        output[_INDEX_COUNTING_IN_PROGRESS].value = false;
        output[_INDEX_COUNTING_COMPLETE].value = true;
        _countingInProgress = false;
        output[_INDEX_ACCUMULATED_TIME].value = PRESET_TIME.COPY;
      } else {
        int accum;
        switch (dropdown) {
          case TimerBase.zeroPointOne:
            accum = _accumulatedTime.inMilliseconds ~/ 100;
            break;
          case TimerBase.one:
            accum = _accumulatedTime.inSeconds.toInt();
            break;
          case TimerBase.ten:
            accum = _accumulatedTime.inSeconds ~/ 10;
            break;
          case TimerBase.minute:
            accum = _accumulatedTime.inMinutes.toInt();
            break;
          case TimerBase.hour:
            accum = _accumulatedTime.inHours.toInt();
            break;
        }

        output[_INDEX_OUT].value = true;
        output[_INDEX_COUNTING_IN_PROGRESS].value = true;
        output[_INDEX_COUNTING_COMPLETE].value = false;
        output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(accum);
      }
    } else if (!_previousInputHigh && INPUT) {
      if (PRESET_TIME.EQUAL_TO(DoubleInteger.FROM_INT(0))) {
        output[_INDEX_OUT].value = false;
        output[_INDEX_COUNTING_IN_PROGRESS].value = false;
        _countingInProgress = false;
        output[_INDEX_COUNTING_COMPLETE].value = true;
        output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(0);
        _accumulatedTime = Duration.zero;
      } else {
        _timerStartEpoch = DateTime.now();
        output[_INDEX_OUT].value = true;
        output[_INDEX_COUNTING_IN_PROGRESS].value = true;
        _countingInProgress = true;
        output[_INDEX_COUNTING_COMPLETE].value = false;

        output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(0);
        _accumulatedTime = Duration.zero;
      }
    } else if (!INPUT) {
      output[_INDEX_OUT].value = false;
      output[_INDEX_COUNTING_IN_PROGRESS].value = false;
      output[_INDEX_COUNTING_COMPLETE].value = false;
      output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(0);
      _accumulatedTime = Duration.zero;
    }

    _previousInputHigh = INPUT;
  }

  //block related fields
  TimerBase dropdown = TimerBase.one;
  Duration _presetTime = const Duration(milliseconds: 0);
  DateTime _timerStartEpoch = DateTime(0);
  Duration _accumulatedTime = const Duration(milliseconds: 0);
  bool _countingInProgress = false;
  bool _previousInputHigh = false;

  static const _INDEX_OUT = 0;
  static const _INDEX_COUNTING_IN_PROGRESS = 1;
  static const _INDEX_COUNTING_COMPLETE = 2;
  static const _INDEX_ACCUMULATED_TIME = 3;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = TypeConversion.STRING_FROM_TIMERBASE(dropdown);
    m['_presetTime'] = TypeConversion.STRING_FROM_DURATION(_presetTime);
    m['_timerStartEpoch'] =
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch);
    m['_accumulatedTime'] =
        TypeConversion.STRING_FROM_DURATION(_accumulatedTime);
    m['_countingInProgress'] =
        TypeConversion.STRING_FROM_BOOL(_countingInProgress);
    m['_previousInputHigh'] =
        TypeConversion.STRING_FROM_BOOL(_previousInputHigh);

    return jsonEncode(m);
  }

  @override
  PulseTimer COPY() {
    var block = PulseTimer();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(
        TypeConversion.STRING_FROM_TIMERBASE(dropdown));
    block._presetTime = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_presetTime));
    block._accumulatedTime = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_accumulatedTime));
    block._timerStartEpoch = TypeConversion.DATETIME_FROM_STRING(
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch));
    block._countingInProgress = _countingInProgress;
    block._previousInputHigh = _previousInputHigh;
    return block;
  }

  static PulseTimer BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = PulseTimer();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(m['dropdown']);
    block._presetTime = TypeConversion.DURATION_FROM_STRING(m['_presetTime']);
    block._accumulatedTime =
        TypeConversion.DURATION_FROM_STRING(m['_accumulatedTime']);
    block._timerStartEpoch =
        TypeConversion.DATETIME_FROM_STRING(m['_timerStartEpoch']);
    block._countingInProgress =
        TypeConversion.BOOL_FROM_STRING(m['_countingInProgress']);
    block._previousInputHigh =
        TypeConversion.BOOL_FROM_STRING(m['_previousInputHigh']);
    return block;
  }
}

///Extended Pulse timer starts counting whenever it detects rising edge of
///input pulse
///
///It does not matter if input pulse goes low, it keeps on counting.
///
///When counting completes, then output goes low.
class ExtendedPulseTimer implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'IN',
      portType: [PortType.boolean],
      value: false,
    ),
    InputPort(
      label: 'Preset time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(20),
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];

  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'OUT',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting in progress',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Counting Complete',
      portType: [PortType.boolean],
      value: false,
    ),
    OutputPort(
      label: 'Accumulated time',
      portType: [PortType.doubleInteger],
      value: DoubleInteger.FROM_INT(0),
    ),
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    final bool INPUT = primaryInputs.first.value;
    final DoubleInteger PRESET_TIME = primaryInputs[1].value;

    if (!_previousInputHigh && INPUT) {
      if (PRESET_TIME.EQUAL_TO(DoubleInteger.FROM_INT(0))) {
        output[_INDEX_OUT].value = false;
        output[_INDEX_COUNTING_IN_PROGRESS].value = false;
        _countingInProgress = false;
        output[_INDEX_COUNTING_COMPLETE].value = true;
        output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(0);
        _accumulatedTime = Duration.zero;
      } else {
        _timerStartEpoch = DateTime.now();
        output[_INDEX_OUT].value = true;
        output[_INDEX_COUNTING_IN_PROGRESS].value = true;
        _countingInProgress = true;
        output[_INDEX_COUNTING_COMPLETE].value = false;

        output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(0);
        _accumulatedTime = Duration.zero;
      }
    } else if (_countingInProgress) {
      switch (dropdown) {
        case TimerBase.zeroPointOne:
          _presetTime = Duration(milliseconds: PRESET_TIME.VALUE * 100);
          break;
        case TimerBase.one:
          _presetTime = Duration(seconds: PRESET_TIME.VALUE);
          break;
        case TimerBase.ten:
          _presetTime = Duration(seconds: PRESET_TIME.VALUE * 10);
          break;
        case TimerBase.minute:
          _presetTime = Duration(minutes: PRESET_TIME.VALUE);
          break;
        case TimerBase.hour:
          _presetTime = Duration(hours: PRESET_TIME.VALUE);
          break;
      }

      _accumulatedTime = DateTime.now().difference(_timerStartEpoch);

      if (_accumulatedTime >= _presetTime) {
        output[_INDEX_OUT].value = false;
        output[_INDEX_COUNTING_IN_PROGRESS].value = false;
        output[_INDEX_COUNTING_COMPLETE].value = true;
        _countingInProgress = false;
        output[_INDEX_ACCUMULATED_TIME].value = PRESET_TIME.COPY;
      } else {
        int accum;
        switch (dropdown) {
          case TimerBase.zeroPointOne:
            accum = _accumulatedTime.inMilliseconds ~/ 100;
            break;
          case TimerBase.one:
            accum = _accumulatedTime.inSeconds.toInt();
            break;
          case TimerBase.ten:
            accum = _accumulatedTime.inSeconds ~/ 10;
            break;
          case TimerBase.minute:
            accum = _accumulatedTime.inMinutes.toInt();
            break;
          case TimerBase.hour:
            accum = _accumulatedTime.inHours.toInt();
            break;
        }

        output[_INDEX_OUT].value = true;
        output[_INDEX_COUNTING_IN_PROGRESS].value = true;
        output[_INDEX_COUNTING_COMPLETE].value = false;
        output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(accum);
      }
    } else if (!INPUT) {
      output[_INDEX_OUT].value = false;
      output[_INDEX_COUNTING_IN_PROGRESS].value = false;
      output[_INDEX_COUNTING_COMPLETE].value = false;
      output[_INDEX_ACCUMULATED_TIME].value = DoubleInteger.FROM_INT(0);
      _accumulatedTime = Duration.zero;
    }

    _previousInputHigh = INPUT;
  }

  //block related fields
  TimerBase dropdown = TimerBase.one;
  Duration _presetTime = const Duration(milliseconds: 0);
  DateTime _timerStartEpoch = DateTime(0);
  Duration _accumulatedTime = const Duration(milliseconds: 0);
  bool _countingInProgress = false;
  bool _previousInputHigh = false;
  static const _INDEX_OUT = 0,
      _INDEX_COUNTING_IN_PROGRESS = 1,
      _INDEX_COUNTING_COMPLETE = 2,
      _INDEX_ACCUMULATED_TIME = 3;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = TypeConversion.STRING_FROM_TIMERBASE(dropdown);
    m['_presetTime'] = TypeConversion.STRING_FROM_DURATION(_presetTime);
    m['_timerStartEpoch'] =
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch);
    m['_accumulatedTime'] =
        TypeConversion.STRING_FROM_DURATION(_accumulatedTime);
    m['_countingInProgress'] =
        TypeConversion.STRING_FROM_BOOL(_countingInProgress);
    m['_previousInputHigh'] =
        TypeConversion.STRING_FROM_BOOL(_previousInputHigh);

    return jsonEncode(m);
  }

  @override
  ExtendedPulseTimer COPY() {
    var block = ExtendedPulseTimer();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(
        TypeConversion.STRING_FROM_TIMERBASE(dropdown));
    block._presetTime = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_presetTime));
    block._accumulatedTime = TypeConversion.DURATION_FROM_STRING(
        TypeConversion.STRING_FROM_DURATION(_accumulatedTime));
    block._timerStartEpoch = TypeConversion.DATETIME_FROM_STRING(
        TypeConversion.STRING_FROM_DATETIME(_timerStartEpoch));
    block._countingInProgress = _countingInProgress;
    block._previousInputHigh = _previousInputHigh;
    return block;
  }

  static ExtendedPulseTimer BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ExtendedPulseTimer();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = TypeConversion.TIMERBASE_FROM_STRING(m['dropdown']);
    block._presetTime = TypeConversion.DURATION_FROM_STRING(m['_presetTime']);
    block._accumulatedTime =
        TypeConversion.DURATION_FROM_STRING(m['_accumulatedTime']);
    block._timerStartEpoch =
        TypeConversion.DATETIME_FROM_STRING(m['_timerStartEpoch']);
    block._countingInProgress =
        TypeConversion.BOOL_FROM_STRING(m['_countingInProgress']);
    block._previousInputHigh =
        TypeConversion.BOOL_FROM_STRING(m['_previousInputHigh']);
    return block;
  }
}

class BufferInput implements LogicBlock {
  /// field updated during initial process
  late final BufferValue bufferValue;

  /// block specific field
  late final int KEY_OF_LOGIC_VALUE_BLOCK;
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
      label: 'IN',
      portType: [PortType.boolean],
      value: false,
    ),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    dynamic VALUE;
    switch (primaryInputs.first.value) {
      case PortType.boolean:
        VALUE = primaryInputs.first.value;
        break;
      default:
        VALUE = primaryInputs.first.value.COPY;
    }
    bufferValue.output.first.value = VALUE;
  }

  //block specific field
  PortType dropdown = PortType.boolean;
  dynamic initialValue = false;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['dropdown'] = TypeConversion.STRING_FROM_PORT_TYPE(dropdown);

    switch (dropdown) {
      case PortType.boolean:
        if (initialValue.runtimeType != bool) {
          throw Exception(
              'dropdown type and initial value type does not match');
        }
        m['initialValue'] = TypeConversion.STRING_FROM_BOOL(initialValue);
        break;
      case PortType.doubleInteger:
        throw Exception('doubleInteger data type code is not written yet');
      // break;
      case PortType.integer:
        if (initialValue.runtimeType != Integer) {
          throw Exception(
              'dropdown type and initial value type does not match');
        }
        m['initialValue'] = TypeConversion.STRING_FROM_INTEGER(initialValue);
        break;
      case PortType.real:
        if (initialValue.runtimeType != Real) {
          throw Exception(
              'dropdown type and initial value type does not match');
        }
        m['initialValue'] = TypeConversion.STRING_FROM_REAL(initialValue);
        break;
    }
    m['KEY_OF_LOGIC_VALUE_BLOCK'] = KEY_OF_LOGIC_VALUE_BLOCK;
    return jsonEncode(m);
  }

  @override
  BufferInput COPY() {
    var block = BufferInput();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block.dropdown = dropdown;
    // block.initialValue =

    switch (dropdown) {
      case PortType.boolean:
        if (initialValue.runtimeType != bool) {
          throw Exception(
              'dropdown type and initial value type does not match');
        }
        block.initialValue = initialValue;
        break;
      case PortType.doubleInteger:
        throw Exception('doubleInteger data type code is not written yet');
      // break;
      case PortType.integer:
        if (initialValue.runtimeType != Integer) {
          throw Exception(
              'dropdown type and initial value type does not match');
        }
        block.initialValue = TypeConversion.INTEGER_FROM_STRING(
            TypeConversion.STRING_FROM_INTEGER(initialValue));
        break;
      case PortType.real:
        if (initialValue.runtimeType != Real) {
          throw Exception(
              'dropdown type and initial value type does not match');
        }
        block.initialValue = TypeConversion.REAL_FROM_STRING(
            TypeConversion.STRING_FROM_REAL(initialValue));
        break;
    }
    block.KEY_OF_LOGIC_VALUE_BLOCK = KEY_OF_LOGIC_VALUE_BLOCK;
    return block;
  }

  static BufferInput BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = BufferInput();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block.dropdown = TypeConversion.PORT_TYPE_FROM_STRING(m['dropdown']);

    switch (block.dropdown) {
      case PortType.boolean:
        block.initialValue = TypeConversion.BOOL_FROM_STRING(m['initialValue']);
        break;
      case PortType.doubleInteger:
        throw Exception('doubleInteger data type code is not written yet');
      // break;
      case PortType.integer:
        block.initialValue =
            TypeConversion.INTEGER_FROM_STRING(m['initialValue']);
        break;
      case PortType.real:
        block.initialValue = TypeConversion.REAL_FROM_STRING(m['initialValue']);
        break;
    }
    block.KEY_OF_LOGIC_VALUE_BLOCK = m['KEY_OF_LOGIC_VALUE_BLOCK'];
    return block;
  }
}

class BufferValue implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(
      label: 'Out',
      portType: [
        PortType.boolean,
        PortType.integer,
        PortType.doubleInteger,
        PortType.real,
      ],
      value: false,
    )
  ];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {}

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  BufferValue COPY() {
    var block = BufferValue();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }

    return block;
  }

  static BufferValue BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = BufferValue();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

class LineBooleanInputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'IN', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    var responseToUi = ResponseToUi.CREATE_FROM_BOOL(
      TYPE_OF_UI_ELEMENT: LineBoolean,
      KEY_OF_UI_ELEMENT: _KEY_OF_UI_ELEMENT,
      INPUT_PORT_INDEX: 0,
      VALUE: primaryInputs.first.value,
    );
    enqueueResponseToUiQueue(responseToUi);
  }

  //block specific fields
  // String keyOfElement = '';
  // bool previousValue = false;

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  LineBooleanInputBlock COPY() {
    var block = LineBooleanInputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;

    return block;
  }

  static LineBooleanInputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = LineBooleanInputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];

    return block;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

class RectangleBooleanInputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'IN', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    var responseToUi = ResponseToUi.CREATE_FROM_BOOL(
      TYPE_OF_UI_ELEMENT: RectangleBoolean,
      KEY_OF_UI_ELEMENT: _KEY_OF_UI_ELEMENT,
      INPUT_PORT_INDEX: 0,
      VALUE: primaryInputs.first.value,
    );
    enqueueResponseToUiQueue(responseToUi);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  RectangleBooleanInputBlock COPY() {
    var block = RectangleBooleanInputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;
    return block;
  }

  static RectangleBooleanInputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = RectangleBooleanInputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];

    return block;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

class CircleBooleanInputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'IN', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  // List<InputPort> previousInput = [];
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    var responseToUi = ResponseToUi.CREATE_FROM_BOOL(
      TYPE_OF_UI_ELEMENT: CircleBoolean,
      KEY_OF_UI_ELEMENT: _KEY_OF_UI_ELEMENT,
      INPUT_PORT_INDEX: 0,
      VALUE: primaryInputs.first.value,
    );
    enqueueResponseToUiQueue(responseToUi);
  }

  //block specific fields
  //  NIL
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  CircleBooleanInputBlock COPY() {
    var block = CircleBooleanInputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;
    return block;
  }

  static CircleBooleanInputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = CircleBooleanInputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];
    return block;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

class TextBooleanInputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'IN', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    var responseToUi = ResponseToUi.CREATE_FROM_BOOL(
      TYPE_OF_UI_ELEMENT: TextBoolean,
      KEY_OF_UI_ELEMENT: _KEY_OF_UI_ELEMENT,
      INPUT_PORT_INDEX: 0,
      VALUE: primaryInputs.first.value,
    );
    enqueueResponseToUiQueue(responseToUi);
  }

  //block specific fields
  //  NIL
  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  TextBooleanInputBlock COPY() {
    var block = TextBooleanInputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;
    return block;
  }

  static TextBooleanInputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = TextBooleanInputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];
    return block;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

class MultiTextBooleanInputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'IN', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];

  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    for (int i = 0; i < primaryInputs.length; ++i) {
      var responseToUi = ResponseToUi.CREATE_FROM_BOOL(
        TYPE_OF_UI_ELEMENT: MultiTextBoolean,
        KEY_OF_UI_ELEMENT: _KEY_OF_UI_ELEMENT,
        INPUT_PORT_INDEX: i,
        VALUE: primaryInputs[i].value,
      );
      enqueueResponseToUiQueue(responseToUi);
    }
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  TextBooleanInputBlock COPY() {
    var block = TextBooleanInputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;
    return block;
  }

  static TextBooleanInputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = TextBooleanInputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];
    return block;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

class MultiTextButtonInputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(label: 'IN', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    for (int i = 0; i < primaryInputs.length; ++i) {
      var responseToUi = ResponseToUi.CREATE_FROM_BOOL(
        TYPE_OF_UI_ELEMENT: MultiTextButton,
        KEY_OF_UI_ELEMENT: _KEY_OF_UI_ELEMENT,
        INPUT_PORT_INDEX: i,
        VALUE: primaryInputs[i].value,
      );
      enqueueResponseToUiQueue(responseToUi);
    }
  }
  //block specific fields

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  MultiTextButtonInputBlock COPY() {
    var block = MultiTextButtonInputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;
    return block;
  }

  static MultiTextButtonInputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = MultiTextButtonInputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];
    return block;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

class MultiTextButtonOutputBlock implements LogicBlock {
  //field for block related to ui element
  late final String _KEY_OF_UI_ELEMENT;

  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [
    OutputPort(label: 'OUT 1', portType: [PortType.boolean], value: false),
  ];
  // block specific fields
  Map<int, bool> currentOutput = {};
  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    Set<int> indicesContainingRequests = Set<int>.from(currentOutput.keys);
    Set<int> allIndices = Set<int>.from(Iterable.generate(output.length));
    Set<int> indicesNotContainingRequests =
        allIndices.difference(indicesContainingRequests);

    for (int i in indicesContainingRequests) {
      output[i].value = currentOutput[i];
    }
    for (int i in indicesNotContainingRequests) {
      output[i].value = false;
    }

    currentOutput.clear();
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_KEY_OF_UI_ELEMENT'] = _KEY_OF_UI_ELEMENT;
    return jsonEncode(m);
  }

  @override
  MultiTextButtonOutputBlock COPY() {
    var block = MultiTextButtonOutputBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._KEY_OF_UI_ELEMENT = _KEY_OF_UI_ELEMENT;
    return block;
  }

  static MultiTextButtonOutputBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = MultiTextButtonOutputBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._KEY_OF_UI_ELEMENT = m['_KEY_OF_UI_ELEMENT'];
    return block;
  }

  /// value from request is copied in Map<int,bool> currentOutput
  void updateFromRequests(RequestFromUi REQUEST_FROM_UI) {
    currentOutput[REQUEST_FROM_UI.OUTPUT_PORT_INDEX] = REQUEST_FROM_UI.VALUE;
  }

  void updateKeyOfUiElement(String KEY_OF_UI_ELEMENT) =>
      _KEY_OF_UI_ELEMENT = KEY_OF_UI_ELEMENT;
}

///Modbus boolean read block is used to read boolean value (either a coil or a
///discrete input) from a modbus device.
/// #### Input Port = 0
/// - Nil
/// #### Output Port = 2
/// - Boolean value read
///   - If modbus read is success, then value of this output port is either true or false
/// - Fail
///   - If modbus read fails, then value of this output port is true.
///   - If modbus read succeeds, then value of this output port is false.
class ModbusTcpReadBooleanBlock implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [
    OutputPort(
        label: 'Boolean value read',
        portType: [PortType.boolean],
        value: false),
    OutputPort(label: 'Fail', portType: [PortType.boolean], value: false),
  ];

  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    // send read request to modbus device after _scanTime
    if (DateTime.now().difference(_epochLastRequestSent) > _scanTime) {
      if (_discreteInputNotCoil) {
        enqueueRequestToModbusQueue(RequestToModbus.fromReadDiscreteInputValues(
          ipv4: _ipv4OfSlave,
          port: _portNumberOfSlave,
          elementNumberFrom1To65536: _elementNumber,
          timeout: _timeOut,
        ));
      } else {
        enqueueRequestToModbusQueue(RequestToModbus.fromReadCoilValues(
          ipv4: _ipv4OfSlave,
          port: _portNumberOfSlave,
          elementNumberFrom1To65536: _elementNumber,
          timeout: _timeOut,
        ));
      }
      _epochLastRequestSent = DateTime.now();
    }

    // update itself from request received from modbus
    while (_responses.isNotEmpty) {
      var response = _responses.removeFirst();
      if (response.isSuccess) {
        output[0].value = response.readData;
        output[1].value = false;
      } else {
        output[1].value = true;
      }
    }
  }

  //block specific fields
  // String keyOfElement = '';
  String _ipv4OfSlave = '';
  int _portNumberOfSlave = 502;
  bool _discreteInputNotCoil = true;
  int _elementNumber = 1;
  Duration _timeOut = MODBUS_TCP_DEFAULT_TIMEOUT;
  Duration _scanTime = MODBUS_TCP_DEFAULT_SCAN_TIME_FOR_READ;
  String _modbusBlockId = '';
  DateTime _epochLastRequestSent = DateTime.now();
  Queue<ResponseFromModbus> _responses = Queue();

  //block specific method
  void buildModbusBlockIdStringFromSelf() {
    final id = modbus_master_isolate.ModbusBlockId(
      ip: _ipv4OfSlave,
      port: _elementNumber,
      readWrite: modbus_master_isolate.ReadWrite.read,
      elementType: _discreteInputNotCoil
          ? modbus_master_isolate.ElementType.discreteInput
          : modbus_master_isolate.ElementType.coil,
      elementNumber: _elementNumber,
    );
    _modbusBlockId = id.asString();
  }

  String GET_MODBUS_BLOCK_ID_STRING() => _modbusBlockId;

  //block specific method
  void enqueueResponseFromModbus(ResponseFromModbus responseFromModbus) {
    _responses.addLast(responseFromModbus);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_ipv4OfSlave'] = _ipv4OfSlave;
    m['_portNumberOfSlave'] = _portNumberOfSlave.toString();
    m['_discreteInputNotCoil'] = _discreteInputNotCoil.toString();
    m['_elementNumber'] = _elementNumber.toString();
    m['_timeOut'] = TypeConversion.STRING_FROM_DURATION(_timeOut);
    m['_scanTime'] = TypeConversion.STRING_FROM_DURATION(_scanTime);
    m['_modbusBlockId'] = _modbusBlockId;
    m['_epochLastRequestSent'] =
        TypeConversion.STRING_FROM_DATETIME(_epochLastRequestSent);

    return jsonEncode(m);
  }

  @override
  ModbusTcpReadBooleanBlock COPY() {
    var block = ModbusTcpReadBooleanBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._ipv4OfSlave = _ipv4OfSlave;
    block._portNumberOfSlave = _portNumberOfSlave;
    block._discreteInputNotCoil = _discreteInputNotCoil;
    block._elementNumber = _elementNumber;
    block._timeOut = _timeOut;
    block._scanTime = _scanTime;
    block._modbusBlockId = _modbusBlockId;
    block._epochLastRequestSent = _epochLastRequestSent;
    block._responses = Queue<ResponseFromModbus>();
    for (var response in _responses) {
      block._responses.addLast(response.COPY());
    }
    return block;
  }

  static ModbusTcpReadBooleanBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ModbusTcpReadBooleanBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._ipv4OfSlave = m['_ipv4OfSlave'];
    block._portNumberOfSlave = int.parse(m['_portNumberOfSlave']);
    block._discreteInputNotCoil =
        TypeConversion.BOOL_FROM_STRING(m['_discreteInputNotCoil']);
    block._elementNumber = TypeConversion.INT_FROM_STRING(m['_elementNumber']);
    block._timeOut = TypeConversion.DURATION_FROM_STRING(m['_timeOut']);
    block._scanTime = TypeConversion.DURATION_FROM_STRING(m['_scanTime']);
    block._modbusBlockId = m['_modbusBlockId'];
    block._epochLastRequestSent =
        TypeConversion.DATETIME_FROM_STRING(m['_epochLastRequestSent']);
    return block;
  }
}

///Modbus write boolean block is used to write boolean value (either to a coil
/// or to discrete input) to a modbus device.
/// #### Input Port = 2
/// - Boolean input
///   - When rising pulse is detected at 'Pulse input' port, at that instant
///     value of this port is written to modbus slave device.
/// - Pulse input
///   - This pulse is sensed for rising pulse.
/// #### Output Port = 0
/// - Nil
class ModbusTcpWriteBooleanBlock implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [
    InputPort(
        label: 'Boolean input', portType: [PortType.boolean], value: false),
    InputPort(label: 'Pulse input', portType: [PortType.boolean], value: false),
  ];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  // List<InputPort> previousInput = [];
  @override
  List<OutputPort> output = [];

  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {
    bool risingPulseIsDetected =
        (!_pulseInputPreviousValue) && (primaryInputs[1].value == true);
    _pulseInputPreviousValue = primaryInputs[1].value;

    // send write request to modbus device if rising pulse is detected at
    // pulse input
    if (risingPulseIsDetected) {
      enqueueRequestToModbusQueue(RequestToModbus.fromWriteCoilValues(
        ipv4: _ipv4OfSlave,
        port: _portNumberOfSlave,
        elementNumberFrom1To65536: _elementNumber,
        valueToBeWritten: primaryInputs[0].value,
        timeout: _timeOut,
      ));
    }

    // update error block if write fails
    while (_responses.isNotEmpty) {
      var response = _responses.removeFirst();
      if (response.isSuccess) {
        referenceOfErrorBlock.output[0].value = false;
      } else {
        referenceOfErrorBlock.output[0].value = true;
      }
    }
  }

  //block specific fields
  // String keyOfElement = '';
  String _ipv4OfSlave = '';
  int _portNumberOfSlave = 502;
  int _elementNumber = 1;
  Duration _timeOut = MODBUS_TCP_DEFAULT_TIMEOUT;
  String _modbusBlockId = '';
  // DateTime _epochLastRequestSent = DateTime.now();
  bool _pulseInputPreviousValue = false;
  Queue<ResponseFromModbus> _responses = Queue();

  late final int INDEX_OF_ERROR_BLOCK;
  late final ModbusTcpWriteBooleanErrorBlock referenceOfErrorBlock;

  void buildModbusBlockIdStringFromSelf() {
    final id = modbus_master_isolate.ModbusBlockId(
      ip: _ipv4OfSlave,
      port: _elementNumber,
      readWrite: modbus_master_isolate.ReadWrite.write,
      elementType: modbus_master_isolate.ElementType.coil,
      elementNumber: _elementNumber,
    );
    _modbusBlockId = id.asString();
  }

  String GET_MODBUS_BLOCK_ID_STRING() => _modbusBlockId;

  void enqueueResponseFromModbus(ResponseFromModbus responseFromModbus) {
    _responses.addLast(responseFromModbus);
  }

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    m['_ipv4OfSlave'] = _ipv4OfSlave;
    m['_portNumberOfSlave'] = _portNumberOfSlave.toString();
    m['_elementNumber'] = _elementNumber.toString();
    m['_timeOut'] = TypeConversion.STRING_FROM_DURATION(_timeOut);
    m['_modbusBlockId'] = _modbusBlockId;
    m['_pulseInputPreviousValue'] =
        TypeConversion.STRING_FROM_BOOL(_pulseInputPreviousValue);
    m['INDEX_OF_ERROR_BLOCK'] = INDEX_OF_ERROR_BLOCK;
    return jsonEncode(m);
  }

  @override
  ModbusTcpWriteBooleanBlock COPY() {
    var block = ModbusTcpWriteBooleanBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    block._ipv4OfSlave = _ipv4OfSlave;
    block._portNumberOfSlave = _portNumberOfSlave;
    // block._discreteInputNotCoil = _discreteInputNotCoil;
    block._elementNumber = _elementNumber;
    block._timeOut = _timeOut;
    // block._scanTime = _scanTime;
    block._modbusBlockId = _modbusBlockId;
    // block._epochLastRequestSent = _epochLastRequestSent;
    block._pulseInputPreviousValue = _pulseInputPreviousValue;
    block.INDEX_OF_ERROR_BLOCK = INDEX_OF_ERROR_BLOCK;
    block._responses = Queue<ResponseFromModbus>();
    for (var response in _responses) {
      block._responses.addLast(response.COPY());
    }
    block.INDEX_OF_ERROR_BLOCK = INDEX_OF_ERROR_BLOCK;
    return block;
  }

  static ModbusTcpWriteBooleanBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ModbusTcpWriteBooleanBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    block._ipv4OfSlave = m['_ipv4OfSlave'];
    block._portNumberOfSlave = int.parse(m['_portNumberOfSlave']);
    block._elementNumber = TypeConversion.INT_FROM_STRING(m['_elementNumber']);
    block._timeOut = TypeConversion.DURATION_FROM_STRING(m['_timeOut']);
    block._modbusBlockId = m['_modbusBlockId'];
    block._pulseInputPreviousValue =
        TypeConversion.BOOL_FROM_STRING(m['_pulseInputPreviousValue']);
    block.INDEX_OF_ERROR_BLOCK = m['INDEX_OF_ERROR_BLOCK'];
    return block;
  }
}

class ModbusTcpWriteBooleanErrorBlock implements LogicBlock {
  @override
  late final int selfKey;
  @override
  PointBoolean topLeftCorner = const PointBoolean.zero();
  @override
  List<InputPort> primaryInputs = [];
  @override
  List<InputPort> secondaryInputs = [];
  @override
  List<InputAddress> primaryInputAddresses = [];
  @override
  List<InputAddress> secondaryInputAddresses = [];
  @override
  List<OutputPort> output = [
    OutputPort(label: 'Write Fail', portType: [PortType.boolean], value: false),
  ];

  @override
  void processBlock(
    void Function(ResponseToUi) enqueueResponseToUiQueue,
    void Function(RequestToModbus) enqueueRequestToModbusQueue,
  ) {}

  @override
  String JSON() {
    Map m = GET_MAP_CONTAINING_STRING_FROM(this);
    return jsonEncode(m);
  }

  @override
  ModbusTcpWriteBooleanErrorBlock COPY() {
    var block = ModbusTcpWriteBooleanErrorBlock();
    block.selfKey = selfKey;
    block.topLeftCorner = topLeftCorner.copy;
    block.primaryInputs.clear();
    for (var inputPort in primaryInputs) {
      block.primaryInputs.add(inputPort.copy);
    }
    block.secondaryInputs.clear();
    for (var inputPort in secondaryInputs) {
      block.secondaryInputs.add(inputPort.copy);
    }
    block.primaryInputAddresses.clear();
    for (var inputAddress in primaryInputAddresses) {
      block.primaryInputAddresses.add(inputAddress.COPY);
    }
    block.secondaryInputAddresses.clear();
    for (var inputAddress in secondaryInputAddresses) {
      block.secondaryInputAddresses.add(inputAddress.COPY);
    }
    block.output.clear();
    for (var outputPort in output) {
      block.output.add(outputPort.copy);
    }
    return block;
  }

  static ModbusTcpWriteBooleanErrorBlock BUILD_FROM_JSON(String JSON_FILE) {
    Map m = jsonDecode(JSON_FILE);
    var block = ModbusTcpWriteBooleanErrorBlock();
    var retVal = BUILD_BASIC_LOGIC_BLOCK_FROM_MAP_CONTAINING_STRING(m);
    block.selfKey = retVal.selfKey;
    block.topLeftCorner = retVal.topLeftCorner;
    block.output = retVal.output;
    block.primaryInputAddresses = retVal.primaryInputAddresses;
    block.primaryInputs = retVal.primaryInputs;
    block.secondaryInputAddresses = retVal.secondaryInputAddresses;
    block.secondaryInputs = retVal.secondaryInputs;
    return block;
  }
}

//Modbus Integer read block

//Modbus Integer write block on rising pulse

//THESE FOUR BLOCKS TO BE WRITTEN LATER
//Modbus DoubleInteger read block

//Modbus DoubleInteger write block on rising pulse

//Modbus Real read block

//Modbus Real write block on rising pulse
