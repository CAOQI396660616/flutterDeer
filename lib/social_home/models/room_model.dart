class RoomModel {
  const RoomModel(
      {required this.id,
      required this.title,
      required this.category,
      required this.onlineCount,
      required this.coverAsset,
      required this.hostName,
      required this.location});

  final String id;
  final String title;
  final String category;
  final int onlineCount;
  final String coverAsset;
  final String hostName;
  final String location;
}
