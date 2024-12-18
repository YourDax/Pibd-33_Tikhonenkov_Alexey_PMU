import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/quotes_repository.dart';
import '/presentation/home_page/bloc/events.dart';
import '/presentation/home_page/bloc/state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final QuotesRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
    on<HomeRefreshEvent>(_onRefreshData);
  }

  void _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    final author = event.author?.trim() ?? '';
    final search = event.search?.trim() ?? '';

    // Если поле автора не заполнено, загружаем данные из репозитория
    if (author.isEmpty) {
      emit(state.copyWith(
        data: repo.loadData(q: search).then((result) => result ?? []), // Обработка null
      ));
    } else {
      // Если автор указан, фильтруем данные по тексту цитаты
      try {
        final currentData = await repo.loadData(
          q: search,
          author: author,
        );
        final filteredData = currentData?.where((quote) {
          final matchesAuthor = quote.author.toLowerCase().contains(author.toLowerCase());
          final matchesSearch =
              search.isEmpty || quote.text.toLowerCase().contains(search.toLowerCase());
          return matchesAuthor && matchesSearch;
        }).toList();
        emit(state.copyWith(data: Future.value(filteredData)));
      } catch (error) {
        emit(state.copyWith(data: Future.error(error)));
      }
    }
  }

  Future<void> _onRefreshData(HomeRefreshEvent event, Emitter<HomeState> emit) async {
    add(HomeLoadDataEvent(
        search: event.search, author: event.author)); // Просто перезапускаем загрузку
  }
}
