import 'package:flutter_deer/social_home/models/room_model.dart';

class MockHomeData {
  static const List<String> categories = <String>[
    'All',
    'Çay Sohbet Odaları',
    'Türk Müzik & Şarkı Odaları',
  ];

  static const List<RoomModel> rooms = <RoomModel>[
    RoomModel(id: 'tea-01', title: 'Akşam Çayı Sohbeti', category: 'Çay Sohbet Odaları', onlineCount: 128),
    RoomModel(id: 'music-01', title: 'Türkçe Müzik Keyfi', category: 'Türk Müzik & Şarkı Odaları', onlineCount: 96),
    RoomModel(id: 'tea-02', title: 'Yeni Arkadaşlar', category: 'Çay Sohbet Odaları', onlineCount: 74),
    RoomModel(id: 'music-02', title: 'Şarkı İstekleri', category: 'Türk Müzik & Şarkı Odaları', onlineCount: 63),
    RoomModel(id: 'tea-03', title: 'Gecenin Muhabbeti', category: 'Çay Sohbet Odaları', onlineCount: 51),
    RoomModel(id: 'music-03', title: 'Nostalji Şarkıları', category: 'Türk Müzik & Şarkı Odaları', onlineCount: 42),
  ];
}
