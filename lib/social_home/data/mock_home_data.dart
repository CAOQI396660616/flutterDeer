import 'package:flutter_deer/social_home/models/room_model.dart';
import 'package:flutter_deer/social_home/data/user_assets.dart';

class MockHomeData {
  static const List<String> familyCategories = <String>['Yeni', 'Takip'];

  static const List<RoomModel> familyRooms = <RoomModel>[
    RoomModel(
        id: 'family-01',
        title: 'Yeni Arkadaşlarla Tanış',
        category: 'Yeni',
        onlineCount: 86,
        coverAsset: UserAssets.avatars[0],
        hostName: 'Mina',
        location: 'Istanbul'),
    RoomModel(
        id: 'family-02',
        title: 'Akşam Muhabbeti',
        category: 'Yeni',
        onlineCount: 64,
        coverAsset: UserAssets.avatars[1],
        hostName: 'Lina',
        location: 'Ankara'),
    RoomModel(
        id: 'family-03',
        title: 'Günün Sohbet Odası',
        category: 'Takip',
        onlineCount: 52,
        coverAsset: UserAssets.avatars[2],
        hostName: 'Aylin',
        location: 'Izmir'),
    RoomModel(
        id: 'family-04',
        title: 'Dostlarla Keyifli Vakit',
        category: 'Takip',
        onlineCount: 41,
        coverAsset: UserAssets.avatars[3],
        hostName: 'Ece',
        location: 'Bursa'),
  ];

  static const List<String> categories = <String>[
    'All',
    'Çay Sohbet Odaları',
    'Türk Müzik & Şarkı Odaları',
  ];

  static const List<RoomModel> rooms = <RoomModel>[
    RoomModel(
        id: 'tea-01',
        title: 'Akşam Çayı Sohbeti',
        category: 'Çay Sohbet Odaları',
        onlineCount: 128,
        coverAsset: UserAssets.avatars[0],
        hostName: 'Mina',
        location: 'Istanbul'),
    RoomModel(
        id: 'music-01',
        title: 'Türkçe Müzik Keyfi',
        category: 'Türk Müzik & Şarkı Odaları',
        onlineCount: 96,
        coverAsset: UserAssets.avatars[1],
        hostName: 'Lina',
        location: 'Ankara'),
    RoomModel(
        id: 'tea-02',
        title: 'Yeni Arkadaşlar',
        category: 'Çay Sohbet Odaları',
        onlineCount: 74,
        coverAsset: UserAssets.avatars[2],
        hostName: 'Aylin',
        location: 'Izmir'),
    RoomModel(
        id: 'music-02',
        title: 'Şarkı İstekleri',
        category: 'Türk Müzik & Şarkı Odaları',
        onlineCount: 63,
        coverAsset: UserAssets.avatars[3],
        hostName: 'Ece',
        location: 'Bursa'),
    RoomModel(
        id: 'tea-03',
        title: 'Gecenin Muhabbeti',
        category: 'Çay Sohbet Odaları',
        onlineCount: 51,
        coverAsset: UserAssets.avatars[4],
        hostName: 'Derya',
        location: 'Antalya'),
    RoomModel(
        id: 'music-03',
        title: 'Nostalji Şarkıları',
        category: 'Türk Müzik & Şarkı Odaları',
        onlineCount: 42,
        coverAsset: UserAssets.avatars[5],
        hostName: 'Elif',
        location: 'Adana'),
  ];

  static List<RoomModel> roomsForPage(int pageIndex, int offset, int limit) {
    final List<RoomModel> source = switch (pageIndex) {
      0 => familyRooms,
      1 => familyRooms.skip(1).toList(),
      2 => rooms,
      3 => rooms.where((RoomModel room) => room.id.startsWith('tea')).toList(),
      _ => rooms.where((RoomModel room) => room.id.startsWith('music')).toList(),
    };
    return List<RoomModel>.generate(limit, (int index) {
      final int number = offset + index;
      final RoomModel base = source[number % source.length];
      return RoomModel(
        id: '${base.id}-$number',
        title: number < source.length ? base.title : '${base.title} ${number + 1}',
        category: base.category,
        onlineCount: base.onlineCount + number * 3,
        coverAsset: base.coverAsset,
        hostName: base.hostName,
        location: base.location,
      );
    });
  }
}
