import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'ducks/state.dart';
import 'ducks/search.dart';
import 'ducks/counter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final store = new Store<AppState>(appStateReducer,
      initialState: new AppState(), middleware: [new EpicMiddleware(allEpics)]);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'Flutter: Firebase & Redux in sync',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter: Firebase & Redux in sync'),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Post>>(
      converter: (store) => store.state.posts,
      builder: (context, list) {
        if (list.length > 0) {
          return Flexible(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final post = list[index];

                  return ListTile(
                      title: Text(post.title), subtitle: Text(post.body));
                }),
          );
        }
        return Text("Press the button first");
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder(
      onInit: (store) => store.dispatch(new RequestCounterDataEventsAction()),
      onDispose: (store) => store.dispatch(new CancelCounterDataEventsAction()),
      builder: (context, Store<AppState> store) {
        //print(Theme.of(context).toString());
        //Rprint(store.toString());
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(title),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PostList(),
                new Text('You have pushed the button this many times:'),
                new Text(
                  '${store.state.counter}',
                  style: Theme.of(context).textTheme.display1,
                ),
                new RaisedButton(
                  onPressed: () {
                    store.dispatch(new SearchAction('test 112233'));
                  },
                  textColor: Colors.white,
                  color: Colors.red,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Search Posts",
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              store.dispatch(new IncrementCounterAction());
            },
            tooltip: 'Increment',
            child: new Icon(Icons.add),
          ),
        );
      },
    );
  }
}
