class IncrementCounterAction {}

class TestCounterAction {}

class RequestSearchDataEventsAction {
  final String testFetch;

  RequestSearchDataEventsAction(this.testFetch);
}

class CounterDataPushedAction {}

class RequestCounterDataEventsAction {
  // @override
  // String toString() => 'RequestCounterDataEventsAction{test:}';
}

class CancelCounterDataEventsAction {}

class CounterOnDataEventAction {
  final int counter;

  CounterOnDataEventAction(this.counter);

  @override
  String toString() => 'CounterOnDataEventAction{counter: $counter}';
}

class CounterOnErrorEventAction {
  final dynamic error;

  CounterOnErrorEventAction(this.error);

  @override
  String toString() => 'CounterOnErrorEventAction{error: $error}';
}
