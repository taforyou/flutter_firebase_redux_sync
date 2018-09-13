import 'package:meta/meta.dart';
import 'package:redux_epics/redux_epics.dart';

import 'search.dart';
import 'counter.dart';

@immutable
class AppState {
  final int counter;
  final String query;

  AppState({this.counter = 0, this.query = 'init query'});

  AppState copyWith({int counter}) =>
      new AppState(counter: counter ?? this.counter);
}

// - Root Reducer -

AppState appStateReducer(AppState state, dynamic action) {
  return new AppState(
    counter: counterReducer(state.counter, action),
    query: searchReducer(state.query, action),
  );
}

// - Root Epic -

final allEpics =
    combineEpics<AppState>([counterEpic, incrementEpic, searchEpic]);
