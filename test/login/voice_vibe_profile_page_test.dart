import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/voice_vibe_profile_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VoiceVibe 我的页展示设计关键元素', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeProfilePage()));

    expect(find.text('晴天歌姬'), findsOneWidget);
    expect(find.text('@sunny_voice'), findsOneWidget);
    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('我的认证'), findsOneWidget);
    expect(find.text('个性装扮'), findsOneWidget);
    expect(find.text('创作中心'), findsOneWidget);
    expect(find.text('我的收藏'), findsOneWidget);
    expect(find.text('浏览记录'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('VoiceVibe 我的页点击菜单给出反馈', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeProfilePage()));

    await tester.tap(find.text('我的认证'));
    await tester.pump();

    expect(find.text('即将打开「我的认证」'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}