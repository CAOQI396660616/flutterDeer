import 'package:flutter_deer/login/models/voice_vibe_home_model.dart';

/// VoiceVibe 首页演示数据。
///
/// 内容与 Figma 节点 `3:56` 设计稿保持一致，仅用于本地设计还原，不请求真实服务端。
class VoiceVibeHomeData {
  const VoiceVibeHomeData._();

  static const String _assetDir = 'assets/images/login/voice_vibe';

  /// 顶部分类标签，第一项默认选中。
  static const List<String> categories = <String>['热门', '音乐', '聊天', '游戏', '情感'];

  /// 精选 live 现场横向轮播数据。
  static const List<VoiceVibeLiveRoom> featuredRooms = <VoiceVibeLiveRoom>[
    VoiceVibeLiveRoom(
      id: 'featured-01',
      title: '深夜留声机 | 情感树洞',
      coverAsset: '$_assetDir/voice_vibe_card_1.png',
      hostName: '温柔阿秋',
      hostAvatarAsset: '$_assetDir/voice_vibe_host_1.png',
      listenerLabel: '2.4k',
    ),
    VoiceVibeLiveRoom(
      id: 'featured-02',
      title: '说唱新世代 Live 海选室',
      coverAsset: '$_assetDir/voice_vibe_card_2.png',
      hostName: 'DJ_Vibe',
      hostAvatarAsset: '$_assetDir/voice_vibe_host_2.png',
      listenerLabel: '1.8k',
    ),
  ];

  /// 为您推荐列表数据。
  static const List<VoiceVibeRecommendRoom> recommendRooms = <VoiceVibeRecommendRoom>[
    VoiceVibeRecommendRoom(
      id: 'recommend-01',
      title: '吉他弹唱：慵懒午后治愈私播',
      avatarAsset: '$_assetDir/voice_vibe_rec_1.png',
      hostName: '夏野',
      categoryLabel: '音乐',
      listenerLabel: '852 在听',
    ),
    VoiceVibeRecommendRoom(
      id: 'recommend-02',
      title: '来聊聊天吧！今日无主题连麦',
      avatarAsset: '$_assetDir/voice_vibe_rec_2.png',
      hostName: '甜甜圈女孩',
      categoryLabel: '聊天',
      listenerLabel: '1.2k 在听',
    ),
    VoiceVibeRecommendRoom(
      id: 'recommend-03',
      title: '【王者荣耀】高端局连麦开黑招募中',
      avatarAsset: '$_assetDir/voice_vibe_rec_3.png',
      hostName: '孤影野王',
      categoryLabel: '游戏',
      listenerLabel: '420 在听',
    ),
  ];
}
