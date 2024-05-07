import 'package:simple_hmi/classes/modbus_master_isolate.dart';

enum ElementType {
  noElement,
  lineBoolean,
  rectangleBoolean,
  circleBoolean,
  circleBooleanPointPoint,
  text,
  multiText,
  multiTextButton,
}

enum SnapOn {
  grid,
  centre,
  endPoint,
  boundary,
}

enum Property {
  propertyType,
  value,
  lowerConstraint,
  upperConstraint,
  integerKey,
}

enum PropertyTypeOfElement {
  boolean,
  color,
  width,
  fontSize,
  string,
}

enum PortType {
  boolean,
  integer,
  doubleInteger,
  // longInteger,
  real,
}

enum CompareBlockType {
  equal,
  notEqual,
  less,
  lessOrEqual,
  greater,
  greaterOrEqual,
}

enum CompareBlockDataType {
  integer,
  doubleInteger,
  real,
}

CompareBlockDataType getCompareBlockDataTypeFromString(string) {
  switch (string) {
    case 'CompareBlockDataType.integer':
      return CompareBlockDataType.integer;
    case 'CompareBlockDataType.doubleInteger':
      return CompareBlockDataType.doubleInteger;
    case 'CompareBlockDataType.real':
      return CompareBlockDataType.real;
  }
  return CompareBlockDataType.integer;
}

enum TimerType {
  onDelay,
  offDelay,
  retentiveOnDelay,
  pulse,
  extendedPulse,
}

enum TimerBase {
  zeroPointOne,
  one,
  ten,
  minute,
  hour,
}

// enum ConverterInputType { integer, doubleInteger, real }
