import 'package:pip_video_player_platform_interface/src/method_channel_pip_video_player.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of pip_video_player must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `PipVideoPlayer`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [PipVideoPlayerPlatform] methods.
abstract class PipVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a PipVideoPlayerPlatform.
  PipVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PipVideoPlayerPlatform _instance = MethodChannelPipVideoPlayer();

  /// The default instance of [PipVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPipVideoPlayer].
  static PipVideoPlayerPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PipVideoPlayerPlatform] when they register themselves.
  static set instance(PipVideoPlayerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
