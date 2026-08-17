/// VoiceVibe「我的」页面功能入口数据。
///
/// 对应 Figma 节点 `3:481` 中 profile 页面的菜单/功能列表项。
class VoiceVibeProfileMenuItem {
  const VoiceVibeProfileMenuItem({
    required this.id,
    required this.label,
    required this.iconAsset,
    required this.trailing,
  });

  final String id;
  final String label;
  final String iconAsset;

  /// 列表项尾部内容，例如 `12.8w 粉丝`、`已认证` 或空。
  final String trailing;
}