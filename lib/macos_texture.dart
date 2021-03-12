import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MacosTexture {
  static const MethodChannel _channel = const MethodChannel('macos_texture');

  static Future<Texture> get texture async {
    final int textureId = await _channel.invokeMethod('getTextureId');
    return Texture(textureId: textureId);
  }
}
