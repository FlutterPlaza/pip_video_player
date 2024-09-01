import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';
import 'package:pip_video_player_windows/pip_video_player_windows.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayerWindows', () {
    const kPlatformName = 'Windows';
    late PipVideoPlayerWindows pipVideoPlayer;
    late List<MethodCall> log;

    setUp(() async {
      pipVideoPlayer = PipVideoPlayerWindows();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pipVideoPlayer.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      PipVideoPlayerWindows.registerWith();
      expect(PipVideoPlayerPlatform.instance, isA<PipVideoPlayerWindows>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await pipVideoPlayer.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
