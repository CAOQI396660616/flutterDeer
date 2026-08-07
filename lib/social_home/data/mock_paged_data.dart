import 'dart:math';

/// Ortak yerel sayfalama kuralı.
///
/// İlk yükleme 10 kayıt, ardından en fazla 5 kez 10 kayıt; yenilemede ilk 10 kayıt karıştırılır.
class MockPagedData<T> {
  MockPagedData({required this.pageFactory, this.pageSize = 10, this.maxLoadMore = 5});

  final List<T> Function(int offset, int limit) pageFactory;
  final int pageSize;
  final int maxLoadMore;

  int _loadMoreCount = 0;
  bool hasMore = true;

  List<T> firstPage() {
    _loadMoreCount = 0;
    hasMore = true;
    return _shuffledPage(0);
  }

  List<T> nextPage() {
    if (!hasMore) {
      return <T>[];
    }
    _loadMoreCount++;
    if (_loadMoreCount >= maxLoadMore) {
      hasMore = false;
    }
    return _shuffledPage(_loadMoreCount * pageSize);
  }

  List<T> _shuffledPage(int offset) {
    final List<T> page = pageFactory(offset, pageSize);
    page.shuffle(Random());
    return page;
  }
}
