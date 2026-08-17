import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/voice_vibe_message_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VoiceVibe 消息页展示设计关键元素', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeMessagePage()));

    expect(find.text('消息'), findsOneWidget);
    expect(find.text('晴天歌姬'), findsOneWidget);
    expect(find.text('DJ_Vibe'), findsOneWidget);
    expect(find.text('温柔阿秋'), findsOneWidget);
    expect(find.text('声优大叔'), findsOneWidget);
    expect(find.text('孤影野王'), findsOneWidget);
    expect(find.text('夏野'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('VoiceVibe 消息页点击对话给出反馈', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeMessagePage()));

    await tester.tap(find.text('晴天歌姬'));
    await tester.pump();

    expect(find.text('即将打开「晴天歌姬」的对话'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
