import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/voice_vibe_live_room_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VoiceVibe 直播房间展示设计关键元素', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VoiceVibeLiveRoomPage(
          title: '深夜留声机 | 情感树洞',
          coverAsset: 'assets/images/login/voice_vibe/voice_vibe_card_1.png',
          hostName: '温柔阿秋',
          listenerLabel: '2.4k',
        ),
      ),
    );

    expect(find.text('深夜留声机 | 情感树洞'), findsOneWidget);
    expect(find.text('主持：温柔阿秋'), findsOneWidget);
    expect(find.text('System：欢迎来到「深夜留声机 | 情感树洞」！请文明发言，共同维护健康社区环境。'), findsOneWidget);
    expect(find.bySemanticsLabel('礼物'), findsOneWidget);
    expect(find.bySemanticsLabel('关闭房间'), findsOneWidget);
  });

  test('直播房间路由会编码动态参数', () {
    final String path = VoiceVibeLiveRoomPage.routePath(
      title: '深夜留声机 | 情感树洞',
      coverAsset: 'assets/images/login/voice_vibe/voice_vibe_card_1.png',
      hostName: '温柔阿秋',
      listenerLabel: '2.4k',
    );

    expect(path, contains('/login/voiceVibe/liveRoom?'));
    expect(path, contains('title='));
    expect(path, contains('%E6%B7%B1%E5%A4%9C'));
  });
}
