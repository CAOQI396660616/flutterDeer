import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/voice_vibe_login_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VoiceVibe 登录页展示设计关键元素', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VoiceVibeLoginPage()));

    expect(find.text('VoiceVibe 声浪'), findsOneWidget);
    expect(find.text('用声音遇见温暖的灵魂'), findsOneWidget);
    expect(find.text('立即登录 / 注册'), findsOneWidget);
    expect(find.text('第三方登录'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
