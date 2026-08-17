import 'package:flutter_deer/login/models/voice_vibe_message_model.dart';

/// VoiceVibe 消息页演示数据。
///
/// 内容与 Figma 节点 `3:397` 设计稿保持一致，仅用于本地设计还原，不请求真实服务端。
class VoiceVibeMessageData {
  const VoiceVibeMessageData._();

  static const String _assetDir = 'assets/images/login/voice_vibe';

  /// 私信列表数据。
  static const List<VoiceVibeMessage> messages = <VoiceVibeMessage>[
    VoiceVibeMessage(
      id: 'msg-01',
      name: '晴天歌姬',
      avatarAsset: '$_assetDir/voice_vibe_discover_host_1.png',
      lastMessage: '谢谢你送的礼物～下次直播见哦 🎵',
      timeLabel: '刚刚',
      unreadCount: 3,
    ),
    VoiceVibeMessage(
      id: 'msg-02',
      name: 'DJ_Vibe',
      avatarAsset: '$_assetDir/voice_vibe_discover_host_2.png',
      lastMessage: '今晚 8 点新歌首播，来捧场！',
      timeLabel: '10:32',
      unreadCount: 1,
    ),
    VoiceVibeMessage(
      id: 'msg-03',
      name: '温柔阿秋',
      avatarAsset: '$_assetDir/voice_vibe_host_1.png',
      lastMessage: '好的，明天我会准时上线',
      timeLabel: '昨天',
      unreadCount: 0,
    ),
    VoiceVibeMessage(
      id: 'msg-04',
      name: '声优大叔',
      avatarAsset: '$_assetDir/voice_vibe_discover_host_3.png',
      lastMessage: '[语音消息] 19″',
      timeLabel: '昨天',
      unreadCount: 0,
    ),
    VoiceVibeMessage(
      id: 'msg-05',
      name: '孤影野王',
      avatarAsset: '$_assetDir/voice_vibe_rec_3.png',
      lastMessage: '上把五杀太帅了，下次继续！',
      timeLabel: '周二',
      unreadCount: 0,
    ),
    VoiceVibeMessage(
      id: 'msg-06',
      name: '夏野',
      avatarAsset: '$_assetDir/voice_vibe_rec_1.png',
      lastMessage: '新谱子写好了，明天来试音',
      timeLabel: '周一',
      unreadCount: 0,
    ),
  ];
}