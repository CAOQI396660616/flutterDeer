import 'package:flutter_deer/login/models/voice_vibe_profile_model.dart';

/// VoiceVibe「我的」页面演示数据。
///
/// 内容与 Figma 节点 `3:481` 设计稿保持一致，仅用于本地设计还原，不请求真实服务端。
class VoiceVibeProfileData {
  const VoiceVibeProfileData._();

  static const String _assetDir = 'assets/images/login/voice_vibe';

  /// 用户基本信息。
  static const String userName = '晴天歌姬';
  static const String userId = '@sunny_voice';
  static const String userAvatar = '$_assetDir/voice_vibe_discover_host_1.png';
  static const String fansLabel = '12.8w 粉丝';
  static const String followLabel = '关注 86';

  /// 菜单项列表。
  static const List<VoiceVibeProfileMenuItem> menuItems = <VoiceVibeProfileMenuItem>[
    VoiceVibeProfileMenuItem(
      id: 'profile-01',
      label: '我的认证',
      iconAsset: '$_assetDir/voice_vibe_mic.svg',
      trailing: '已认证',
    ),
    VoiceVibeProfileMenuItem(
      id: 'profile-02',
      label: '个性装扮',
      iconAsset: '$_assetDir/voice_vibe_headphones.svg',
      trailing: '',
    ),
    VoiceVibeProfileMenuItem(
      id: 'profile-03',
      label: '创作中心',
      iconAsset: '$_assetDir/voice_vibe_tab_home.svg',
      trailing: '',
    ),
    VoiceVibeProfileMenuItem(
      id: 'profile-04',
      label: '我的收藏',
      iconAsset: '$_assetDir/voice_vibe_tab_compass.svg',
      trailing: '',
    ),
    VoiceVibeProfileMenuItem(
      id: 'profile-05',
      label: '浏览记录',
      iconAsset: '$_assetDir/voice_vibe_search.svg',
      trailing: '',
    ),
    VoiceVibeProfileMenuItem(
      id: 'profile-06',
      label: '设置',
      iconAsset: '$_assetDir/voice_vibe_bell_dot.svg',
      trailing: '',
    ),
  ];
}