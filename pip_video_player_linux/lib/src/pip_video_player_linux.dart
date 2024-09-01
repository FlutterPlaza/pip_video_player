import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

/// The Linux implementation of [PipVideoPlayerPlatform].
class PipVideoPlayerLinux extends PipVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pip_video_player_linux');

  /// Registers this class as the default instance of [PipVideoPlayerPlatform]
  static void registerWith() {
    PipVideoPlayerPlatform.instance = PipVideoPlayerLinux();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
