import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';
import 'package:pip_video_player_web/pip_video_player_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayerWeb', () {
    const kPlatformName = 'Web';
    late PipVideoPlayerWeb pipVideoPlayer;

    setUp(() async {
      pipVideoPlayer = PipVideoPlayerWeb();
    });

    test('can be registered', () {
      PipVideoPlayerWeb.registerWith();
      expect(PipVideoPlayerPlatform.instance, isA<PipVideoPlayerWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pipVideoPlayer.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
