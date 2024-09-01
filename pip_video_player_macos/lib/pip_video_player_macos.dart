import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

/// The MacOS implementation of [PipVideoPlayerPlatform].
class PipVideoPlayerMacOS extends PipVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pip_video_player_macos');

  /// Registers this class as the default instance of [PipVideoPlayerPlatform]
  static void registerWith() {
    PipVideoPlayerPlatform.instance = PipVideoPlayerMacOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
