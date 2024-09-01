import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

PipVideoPlayerPlatform get _platform => PipVideoPlayerPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
