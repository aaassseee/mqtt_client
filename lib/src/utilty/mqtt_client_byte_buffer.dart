/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

part of mqtt_client;

/// Utility class to allow stream like access to a sized byte buffer.
class ByteBuffer {
  ByteBuffer(this._buffer) {
    _length = _buffer.length;
  }

  int _index = 0;

  int get currentIndex => _index;

  void reset() {
    _index = 0;
  }

  int _length;

  int get length => _length;

  typed.Uint8Buffer _buffer;

  typed.Uint8Buffer get buffer => _buffer;

  /// Read a byte. If the index would overflow the last byte
  /// is returned.
  int readByte() {
    final int tmp = _buffer[_index];
    if (_index < _buffer.length) {
      _index++;
    }
    return tmp;
  }

  /// Read a short int(16 bits)
  int readShort() {
    final int tmp = readByte();
    final int tmp1 = readByte();
    return tmp1 * 256 + tmp;
  }

  /// Write a byte.
  void writeByte(int byte) {
    _buffer.add(byte);
    _index++;
  }

  /// Write a short(16 bit)
  void writeShort(int short) {
    final int tmp = short & 0xFF;
    final int tmp1 = short & 0xFF00;
    writeByte(tmp1);
    writeByte(tmp);
  }

  /// Seek to. Increments the index to the seek value. If the index
  /// would overflow the buffer the last byte is selected.
  void seekTo(int seek) {
    if ((seek <= _length) && (seek >= 0)) {
      _index = seek;
    } else
      _index = _length;
  }

  /// Write a byte buffer to the current buffer
  void write(typed.Uint8Buffer buffer) {
    if (_buffer == null) {
      _buffer = buffer;
    } else {
      _buffer.addAll(buffer);
    }
    _length = _buffer.length;
  }

  /// Writes an MQTT string.
  /// stringStream - The stream containing the string to write.
  /// stringToWrite - The string to write.
  static void writeMqttString(ByteBuffer stringStream, String stringToWrite) {
    final MQTTEncoding enc = new MQTTEncoding();
    final typed.Uint8Buffer stringBytes = enc.getBytes(stringToWrite);
    stringStream.write(stringBytes);
  }

  /// Reads an MQTT string
  static String readMqttString(ByteBuffer buffer) {
    // TODO
    return "";
  }
}
