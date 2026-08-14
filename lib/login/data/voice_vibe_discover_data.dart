import 'package:flutter_deer/login/models/voice_vibe_discover_model.dart';

/// VoiceVibe 发现页演示数据。
///
/// 内容与 Figma 节点 `3:291` 设计稿保持一致，仅用于本地设计还原，不请求真实服务端。
class VoiceVibeDiscoverData {
  const VoiceVibeDiscoverData._();

  static const String _assetDir = 'assets/images/login/voice_vibe';

  /// 搜索建议 placeholder。
  static const String searchHint = '搜索主播、房间、声音标签...';

  /// 标签筛选，第一项默认选中。
  static const List<String> chips = <String>['音乐', '聊天', '情感', '游戏', '教育'];

  /// 当下最热现场 2×2 网格数据。
  static const List<VoiceVibeDiscoverGridCard> trendingCards = <VoiceVibeDiscoverGridCard>[
    VoiceVibeDiscoverGridCard(
      id: 'discover-trend-01',
      title: '说唱海选，在线麦霸PK',
      coverAsset: '$_assetDir/voice_vibe_discover_card_1.png',
      hostLine: r'Host: Rap\_King · 4.8k',
    ),
    VoiceVibeDiscoverGridCard(
      id: 'discover-trend-02',
      title: '治愈系电台：倾听你的故事',
      coverAsset: '$_assetDir/voice_vibe_discover_card_2.png',
      hostLine: 'Host: 主播安暖 \u00b7 2.5k',
    ),
    VoiceVibeDiscoverGridCard(
      id: 'discover-trend-03',
      title: '深夜修仙开黑房',
      coverAsset: '$_assetDir/voice_vibe_discover_card_3.png',
      hostLine: 'Host: 金牌射手 \u00b7 920',
    ),
    VoiceVibeDiscoverGridCard(
      id: 'discover-trend-04',
      title: '深夜留声机',
      coverAsset: '$_assetDir/voice_vibe_discover_card_4.png',
      hostLine: 'Host: 温柔阿秋 \u00b7 2.4k',
    ),
  ];

  /// 人气红人列表。
  static const List<VoiceVibeDiscoverHost> hosts = <VoiceVibeDiscoverHost>[
    VoiceVibeDiscoverHost(
      id: 'discover-host-01',
      name: '晴天歌姬',
      fansLabel: '粉丝: 12.8w',
      avatarAsset: '$_assetDir/voice_vibe_discover_host_1.png',
      isOnline: true,
    ),
    VoiceVibeDiscoverHost(
      id: 'discover-host-02',
      name: r'DJ\_Vibe',
      fansLabel: '粉丝: 8.4w',
      avatarAsset: '$_assetDir/voice_vibe_discover_host_2.png',
      isOnline: true,
    ),
    VoiceVibeDiscoverHost(
      id: 'discover-host-03',
      name: '声优大叔',
      fansLabel: '粉丝: 24.5w',
      avatarAsset: '$_assetDir/voice_vibe_discover_host_3.png',
      isOnline: false,
    ),
  ];
}
