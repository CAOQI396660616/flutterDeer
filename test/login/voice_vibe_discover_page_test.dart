import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/voice_vibe_discover_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VoiceVibe 发现页展示设计关键元素', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeDiscoverPage()));

    expect(find.text('搜索主播、房间、声音标签...'), findsOneWidget);
    expect(find.text('音乐'), findsOneWidget);
    expect(find.text('聊天'), findsOneWidget);
    expect(find.text('情感'), findsOneWidget);
    expect(find.text('游戏'), findsOneWidget);
    expect(find.text('教育'), findsOneWidget);
    expect(find.text('当下最热现场'), findsOneWidget);
    expect(find.text('说唱海选，在线麦霸PK'), findsOneWidget);
    expect(find.text('人气红人'), findsOneWidget);
    expect(find.text('晴天歌姬'), findsOneWidget);
    expect(find.text(r'DJ\_Vibe'), findsOneWidget);
    expect(find.text('声优大叔'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('VoiceVibe 发现页切换分类给出反馈', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeDiscoverPage()));

    await tester.tap(find.text('聊天'));
    await tester.pump();

    expect(find.text('已切换到「聊天」分类'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('VoiceVibe 发现页点击关注给出反馈', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeDiscoverPage()));

    await tester.tap(find.text('+ 关注').first);
    await tester.pump();

    expect(find.text('已关注「晴天歌姬」'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
