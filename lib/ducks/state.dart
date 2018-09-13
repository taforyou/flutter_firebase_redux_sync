import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';

import 'search.dart';
import 'counter.dart';

@immutable
class AppState {
  final int counter;
  final String query;
  final List<Post> posts;

  AppState(
      {this.counter = 0, this.query = 'init query', this.posts = const []});

  AppState copyWith({int counter}) =>
      new AppState(counter: counter ?? this.counter);
}

// - Root Reducer -

AppState appStateReducer(AppState state, dynamic action) {
  return new AppState(
      counter: counterReducer(state.counter, action),
      query: queryReducer(state.query, action),
      posts: postsReducer(state.posts, action));
}

// - Root Epic -

final allEpics =
    combineEpics<AppState>([counterEpic, incrementEpic, searchEpic]);
