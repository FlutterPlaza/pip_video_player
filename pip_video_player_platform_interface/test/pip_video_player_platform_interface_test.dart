import 'package:flutter_test/flutter_test.dart';
import 'package:pip_video_player_platform_interface/pip_video_player_platform_interface.dart';

class PipVideoPlayerMock extends PipVideoPlayerPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PipVideoPlayerPlatformInterface', () {
    late PipVideoPlayerPlatform pipVideoPlayerPlatform;

    setUp(() {
      pipVideoPlayerPlatform = PipVideoPlayerMock();
      PipVideoPlayerPlatform.instance = pipVideoPlayerPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await PipVideoPlayerPlatform.instance.getPlatformName(),
          equals(PipVideoPlayerMock.mockPlatformName),
        );
      });
    });
  });
}
