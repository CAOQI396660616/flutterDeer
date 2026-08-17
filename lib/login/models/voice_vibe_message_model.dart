/// VoiceVibe 消息页私信列表项数据。
///
/// 对应 Figma 节点 `3:397` 中的聊天列表项。
class VoiceVibeMessage {
  const VoiceVibeMessage({
    required this.id,
    required this.name,
    required this.avatarAsset,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
  });

  final String id;
  final String name;
  final String avatarAsset;

  /// 最后一条消息预览文本。
  final String lastMessage;

  /// 时间标签，例如 `刚刚`、`10:32`、`昨天`。
  final String timeLabel;

  /// 未读消息数；0 表示不显示角标。
  final int unreadCount;
}