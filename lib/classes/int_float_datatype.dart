import 'dart:math';

class Int16 {
  static int MAX = 32767;
  static int MIN = -32768;
  late final String BITS_16;

  Int16(this.BITS_16);

  Int16.fromInt32(Int32 int32) {
    final bitsInt32 = int32.BITS_32;

    String sign = bitsInt32[0];
    String value;

    if (bitsInt32.substring(1, 17).contains('1')) {
      value = '111111111111111';
    } else {
      value = bitsInt32.substring(17);
    }

    StringBuffer buf = StringBuffer();
    buf.writeAll([sign, value]);

    BITS_16 = buf.toString();
  }

  Int16.fromInt64(Int64 int64) {
    final BITS_64 = int64.BITS_64;

    String sign = BITS_64[0];
    String value;

    if (BITS_64.substring(1, 49).contains('1')) {
      value = '111111111111111';
    } else {
      value = BITS_64.substring(49);
    }

    StringBuffer buf = StringBuffer();
    buf.writeAll([sign, value]);

    BITS_16 = buf.toString();
  }

  Int16.fromFloat32(Float32 float32) {
    double val = float32.BITS_32[0] == '1' ? -1 : 1;
    val *= pow(2, (Int16.decimalFromBinary(float32.BITS_32, 1, 9) - 127));
    val *= (1 + Int16.decimalFromBinary(float32.BITS_32, 9));

    int intVal = val.toInt();
    if (intVal > 32767) {
      BITS_16 = '0111111111111111';
    } else if (intVal < -32768) {
      BITS_16 = '1111111111111111';
    } else {
      StringBuffer buf = StringBuffer();
      buf.writeAll([intVal < 0 ? '1' : '0']);

      for (int i = 1; i <= 15; ++i) {
        String thisBit = (0x0000000000004000 & intVal) > 0 ? '1' : '0';
        buf.writeAll([thisBit]);
        intVal = intVal << 1;
      }
      BITS_16 = buf.toString();
    }
  }

  static int decimalFromBinary(
    String BITS, [
    int? startIndexInclusive,
    int? finalIndexInclusive,
  ]) {
    int val = 0;

    if (startIndexInclusive == null) {
      val = 0;
      for (int i = 0; i < BITS.length; ++i) {
        val = val << 1;
        val = val | (BITS[i] == '1' ? 1 : 0);
      }
      return val;
    } else if (finalIndexInclusive == null) {
      val = 0;
      for (int i = startIndexInclusive; i < BITS.length; ++i) {
        val = val << 1;
        val = val | (BITS[i] == '1' ? 1 : 0);
      }
      return val;
    } else {
      val = 0;
      for (int i = startIndexInclusive; i <= finalIndexInclusive; ++i) {
        val = val << 1;
        val = val | (BITS[i] == '1' ? 1 : 0);
      }
      return val;
    }
  }

  @override
  String toString() {
    int val = 0;
    int multiplier = 1;
    for (int i = 15; i > 0; ++i) {
      val += (BITS_16[i] == '1' ? 1 : 0) * multiplier;
      multiplier *= 2;
    }
    val = val * (BITS_16[0] == '1' ? -1 : 1);
    return val.toString();
  }
}

class Int32 {
  static int MAX_VALUE = 2147483647;
  static int MIN_VALUE = -2147483648;
  late final String BITS_32;
  Int32(this.BITS_32);

  Int32.fromInt16(Int16 int16) {
    StringBuffer buf = StringBuffer();
    buf.write(int16.BITS_16[0]);
    buf.write('0000000000000000');
    buf.write(int16.BITS_16.substring(1));
    BITS_32 = buf.toString();
  }

  Int32.fromInt64(Int64 int64) {
    int intVal = Int16.decimalFromBinary(int64.BITS_64.substring(1));
    intVal *= int64.BITS_64[0] == '1' ? -1 : 1;
    if (intVal > MAX_VALUE) {
      BITS_32 = '01111111111111111111111111111111';
    } else if (intVal < MIN_VALUE) {
      BITS_32 = '11111111111111111111111111111111';
    } else {
      StringBuffer buf = StringBuffer();
      buf.write(int64.BITS_64[0]);
      buf.write(int64.BITS_64.substring(33));
      BITS_32 = buf.toString();
    }
  }

  Int32.fromFloat32(Float32 float32) {
    double floatVal = double.parse(float32.toString());

    if (floatVal > MAX_VALUE) {
      BITS_32 = '01111111111111111111111111111111';
    } else if (floatVal < MIN_VALUE) {
      BITS_32 = '11111111111111111111111111111111';
    } else {
      int intVal = floatVal.toInt();
    }
  }
}

class Int64 {
  late final String BITS_64;
  Int64(this.BITS_64);
}

class Float32 {
  late final String BITS_32;
  Float32(this.BITS_32);
}
