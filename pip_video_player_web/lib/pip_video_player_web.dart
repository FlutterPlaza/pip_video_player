import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

/// The Web implementation of [PipVideoPlayerPlatform].
class PipVideoPlayerWeb extends PipVideoPlayerPlatform {
  /// Registers this class as the default instance of [PipVideoPlayerPlatform]
  static void registerWith([Object? registrar]) {
    PipVideoPlayerPlatform.instance = PipVideoPlayerWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
