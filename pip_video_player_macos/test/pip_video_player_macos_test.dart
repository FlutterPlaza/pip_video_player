import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_macos/pip_video_player_macos.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayerMacOS', () {
    const kPlatformName = 'MacOS';
    late PipVideoPlayerMacOS pipVideoPlayer;
    late List<MethodCall> log;

    setUp(() async {
      pipVideoPlayer = PipVideoPlayerMacOS();

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
      PipVideoPlayerMacOS.registerWith();
      expect(PipVideoPlayerPlatform.instance, isA<PipVideoPlayerMacOS>());
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
