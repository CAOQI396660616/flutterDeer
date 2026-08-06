class RoomModel {
  const RoomModel(
      {required this.id,
      required this.title,
      required this.category,
      required this.onlineCount,
      required this.coverAsset});

  final String id;
  final String title;
  final String category;
  final int onlineCount;
  final String coverAsset;
}
