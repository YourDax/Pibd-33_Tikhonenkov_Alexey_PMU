abstract class HomeEvent {
  const HomeEvent();
}

class HomeLoadDataEvent extends HomeEvent {
  final String? search;
  final String? author;

  const HomeLoadDataEvent({this.search, this.author});
}

class HomeRefreshEvent extends HomeEvent {
  final String? search;
  final String? author;

  const HomeRefreshEvent({this.search, this.author});
}
