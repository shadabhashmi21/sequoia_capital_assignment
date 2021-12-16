extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T t) {
    List<T> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}

extension ListCanSort<T> on List<T> {
  bool canSort() {
    return length > 1;
  }
}

extension MyIterable<E> on Iterable<E> {
  Iterable<E> sortedBy(Comparable Function(E e) key, bool isAsc) {
    if (isAsc) {
      return toList()..sort((a, b) => key(a).compareTo(key(b)));
    } else {
      return (toList()..sort((a, b) => key(a).compareTo(key(b)))).reversed;
    }
  }
}
