import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_android/pip_video_player_android.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PipVideoPlayerAndroid', () {
    const kPlatformName = 'Android';
    late PipVideoPlayerAndroid pipVideoPlayer;
    late List<MethodCall> log;

    setUp(() async {
      pipVideoPlayer = PipVideoPlayerAndroid();

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
      PipVideoPlayerAndroid.registerWith();
      expect(PipVideoPlayerPlatform.instance, isA<PipVideoPlayerAndroid>());
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
