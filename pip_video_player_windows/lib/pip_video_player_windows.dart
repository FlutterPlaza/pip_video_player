import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

/// The Windows implementation of [PipVideoPlayerPlatform].
class PipVideoPlayerWindows extends PipVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pip_video_player_windows');

  /// Registers this class as the default instance of [PipVideoPlayerPlatform]
  static void registerWith() {
    PipVideoPlayerPlatform.instance = PipVideoPlayerWindows();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
