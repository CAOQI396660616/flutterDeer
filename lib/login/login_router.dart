import 'package:fluro/fluro.dart';
import 'package:flutter_deer/routers/i_router.dart';

import 'page/login_flow_page.dart';
import 'page/register_page.dart';
import 'page/reset_password_page.dart';
import 'page/sms_login_page.dart';
import 'page/update_password_page.dart';
import 'page/voice_vibe_discover_page.dart';
import 'page/voice_vibe_home_page.dart';
import 'page/voice_vibe_live_room_page.dart';
import 'page/voice_vibe_login_page.dart';
import 'page/voice_vibe_message_page.dart';
import 'page/voice_vibe_profile_page.dart';

class LoginRouter implements IRouterProvider {
  static String loginPage = '/login';
  static String registerPage = '/login/register';
  static String smsLoginPage = '/login/smsLogin';
  static String resetPasswordPage = '/login/resetPassword';
  static String updatePasswordPage = '/login/updatePassword';
  static String voiceVibeLoginPage = '/login/voiceVibe';
  static String voiceVibeHomePage = '/login/voiceVibe/home';
  static String voiceVibeDiscoverPage = '/login/voiceVibe/discover';
  static String voiceVibeMessagePage = '/login/voiceVibe/messages';
  static String voiceVibeProfilePage = '/login/voiceVibe/profile';
  static String voiceVibeLiveRoomPage = '/login/voiceVibe/liveRoom';

  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const LoginFlowPage()));
    router.define(registerPage, handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
    router.define(smsLoginPage, handler: Handler(handlerFunc: (_, __) => const SMSLoginPage()));
    router.define(resetPasswordPage,
        handler: Handler(handlerFunc: (_, __) => const ResetPasswordPage()));
    router.define(updatePasswordPage,
        handler: Handler(handlerFunc: (_, __) => const UpdatePasswordPage()));
    router.define(voiceVibeLoginPage,
        handler: Handler(handlerFunc: (_, __) => const VoiceVibeLoginPage()));
    router.define(voiceVibeHomePage,
        handler: Handler(handlerFunc: (_, __) => const VoiceVibeHomePage()));
    router.define(voiceVibeDiscoverPage,
        handler: Handler(handlerFunc: (_, __) => const VoiceVibeDiscoverPage()));
    router.define(voiceVibeMessagePage,
        handler: Handler(handlerFunc: (_, __) => const VoiceVibeMessagePage()));
    router.define(voiceVibeProfilePage,
        handler: Handler(handlerFunc: (_, __) => const VoiceVibeProfilePage()));
    router.define(voiceVibeLiveRoomPage, handler: Handler(handlerFunc: (_, params) {
      return VoiceVibeLiveRoomPage(
        title: params['title']?.first ?? '深夜留声机 | 情感树洞',
        coverAsset:
            params['cover']?.first ?? 'assets/images/login/voice_vibe/voice_vibe_card_1.png',
        hostName: params['host']?.first ?? '温柔阿秋',
        listenerLabel: params['listeners']?.first ?? '2.4k',
      );
    }));
  }
}
