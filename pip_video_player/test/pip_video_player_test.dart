import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pip_video_player/pip_video_player.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPipVideoPlayerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PipVideoPlayerPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayer', () {
    late PipVideoPlayerPlatform pipVideoPlayerPlatform;

    setUp(() {
      pipVideoPlayerPlatform = MockPipVideoPlayerPlatform();
      PipVideoPlayerPlatform.instance = pipVideoPlayerPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => pipVideoPlayerPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => pipVideoPlayerPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
