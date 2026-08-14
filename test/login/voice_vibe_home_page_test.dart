import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/voice_vibe_home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VoiceVibe 首页展示设计关键元素', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeHomePage()));

    expect(find.text('VoiceVibe'), findsOneWidget);
    expect(find.text('热门'), findsOneWidget);
    expect(find.text('精选 live 现场'), findsOneWidget);
    expect(find.text('深夜留声机 | 情感树洞'), findsOneWidget);
    expect(find.text('为您推荐'), findsOneWidget);
    expect(find.text('852 在听'), findsOneWidget);
    expect(find.text('开播'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('VoiceVibe 首页切换分类给出反馈', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeHomePage()));

    await tester.tap(find.text('音乐').first);
    await tester.pump();

    expect(find.text('已切换到「音乐」分类'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
