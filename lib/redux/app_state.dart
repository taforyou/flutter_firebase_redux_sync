import 'package:meta/meta.dart';

@immutable
class AppState {
  final int counter;
  final String testFetch;

  AppState({
    this.counter = 0,
    this.testFetch = 'init testFetch'
  });

  AppState copyWith({int counter}) => new AppState(counter: counter ?? this.counter);
}
