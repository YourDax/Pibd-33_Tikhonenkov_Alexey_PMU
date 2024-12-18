import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'like_event.dart';
import 'like_state.dart';

const String _likedPrefsKey = 'liked';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(const LikeState(likedIds: [])) {
    on<ChangeLikeEvent>(_onChangeLike);
    on<LoadLikesEvent>(_onLoadLikes);
  }

  Future<void> _onLoadLikes(LoadLikesEvent event, Emitter<LikeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_likedPrefsKey);

    emit(state.copyWith(likedIds: data));
  }

  Future<void> _onChangeLike(ChangeLikeEvent event, Emitter<LikeState> emit) async {
    final updatedList = List<String>.from(state.likedIds ?? []);

    if (updatedList.contains(event.id)) {
      updatedList.remove(event.id);
    } else {
      updatedList.add(event.id);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_likedPrefsKey, updatedList);

    emit(state.copyWith(likedIds: updatedList));
  }
}