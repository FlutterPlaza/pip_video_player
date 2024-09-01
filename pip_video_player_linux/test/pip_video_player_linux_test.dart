import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_linux/pip_video_player_linux.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayerLinux', () {
    const kPlatformName = 'Linux';
    late PipVideoPlayerLinux pipVideoPlayer;
    late List<MethodCall> log;

    setUp(() async {
      pipVideoPlayer = PipVideoPlayerLinux();

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
      PipVideoPlayerLinux.registerWith();
      expect(PipVideoPlayerPlatform.instance, isA<PipVideoPlayerLinux>());
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
