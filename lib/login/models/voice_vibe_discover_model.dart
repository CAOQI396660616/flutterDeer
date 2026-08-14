/// 发现页网格卡片数据。
///
/// 对应 Figma 节点 `3:317` / `3:324` / `3:332` / `3:339` 的 2×2 网格直播卡片。
class VoiceVibeDiscoverGridCard {
  const VoiceVibeDiscoverGridCard({
    required this.id,
    required this.title,
    required this.coverAsset,
    required this.hostLine,
  });

  final String id;
  final String title;
  final String coverAsset;

  /// 主机信息文本，例如 `Host: Rap_King · 4.8k`。
  final String hostLine;
}

/// 发现页人气红人数据。
///
/// 对应 Figma 节点 `3:349` / `3:358` / `3:367`。
class VoiceVibeDiscoverHost {
  const VoiceVibeDiscoverHost({
    required this.id,
    required this.name,
    required this.fansLabel,
    required this.avatarAsset,
    required this.isOnline,
  });

  final String id;
  final String name;
  final String avatarAsset;

  /// 粉丝数标签，例如 `粉丝: 12.8w`。
  final String fansLabel;

  /// 是否在线；离线时展示「离线」文字而非绿色「在线」。
  final bool isOnline;
}
