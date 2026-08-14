/// VoiceVibe 首页精选直播卡片数据。
///
/// 对应 Figma 节点 `3:85` / `3:98` 的横向轮播卡片。
class VoiceVibeLiveRoom {
  const VoiceVibeLiveRoom({
    required this.id,
    required this.title,
    required this.coverAsset,
    required this.hostName,
    required this.hostAvatarAsset,
    required this.listenerLabel,
  });

  final String id;
  final String title;
  final String coverAsset;
  final String hostName;
  final String hostAvatarAsset;

  /// 在线收听人数展示文案，例如 `2.4k`。
  final String listenerLabel;
}

/// VoiceVibe 首页「为您推荐」列表项数据。
///
/// 对应 Figma 节点 `3:114` / `3:134` / `3:154`。
class VoiceVibeRecommendRoom {
  const VoiceVibeRecommendRoom({
    required this.id,
    required this.title,
    required this.avatarAsset,
    required this.hostName,
    required this.categoryLabel,
    required this.listenerLabel,
  });

  final String id;
  final String title;
  final String avatarAsset;
  final String hostName;

  /// 房间分类标签，例如 `音乐`、`聊天`、`游戏`。
  final String categoryLabel;

  /// 在线收听人数展示文案，例如 `852 在听`。
  final String listenerLabel;
}
