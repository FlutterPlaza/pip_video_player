import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

/// An implementation of [PipVideoPlayerPlatform] that uses method channels.
class MethodChannelPipVideoPlayer extends PipVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pip_video_player');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
