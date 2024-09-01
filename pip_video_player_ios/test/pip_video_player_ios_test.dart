import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_ios/pip_video_player_ios.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayerIOS', () {
    const kPlatformName = 'iOS';
    late PipVideoPlayerIOS pipVideoPlayer;
    late List<MethodCall> log;

    setUp(() async {
      pipVideoPlayer = PipVideoPlayerIOS();

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
      PipVideoPlayerIOS.registerWith();
      expect(PipVideoPlayerPlatform.instance, isA<PipVideoPlayerIOS>());
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
