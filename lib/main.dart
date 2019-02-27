import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game of life',
      theme: ThemeData(primarySwatch: Colors.red, canvasColor: Colors.black38),
      home: MyHomePage(title: 'Lets play LIFE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int size = 10;
  int iterations = 50;
  int currentIteration = 0;
  double sliderIterationsValue = 50.0;
  double sliderSpeedValue = 300;
  int speed = 300;
  final Random random = Random.secure();
  List<List<bool>> _status = new List();

  List<List<bool>> getFirstStatus() {
    List<List<bool>> result = new List();
    for (var row = 0; row < size; row++) {
      List<bool> cells = new List();
      for (var item = 0; item < size; item++) {
        cells.add(random.nextBool());
      }
      result.add(cells);
    }
    return result;
  }

  bool liveOrDie(i, j) {
    int c = 0;
    for (var k = i - 1; k < i + 2; k++) {
      for (var l = j - 1; l < j + 2; l++) {
        if (_status[k % size][l % size] == true) {
          c++;
        }
      }
    }
    if (c == 3) {
      return true;
    }
    if (_status[i % size][j % size] == true && c == 2) {
      return true;
    }
    return false;
  }

  List<List<bool>> getNextStatus() {
    List<List<bool>> result = new List();
    for (var row = 0; row < size; row++) {
      List<bool> cells = new List();
      for (var item = 0; item < size; item++) {
        cells.add(liveOrDie(row, item));
      }
      result.add(cells);
    }
    return result;
  }

  _startNow() {
    if (currentIteration == 0) {
      _status = getFirstStatus();
      _startChangingStatus();
    } else {
      currentIteration = iterations;
    }
  }

  bool _equalMatrix(List<List<bool>> a, List<List<bool>> b) {
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (a[i][j] != b[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  _startChangingStatus() {
    if (currentIteration < iterations) {
      new Timer(Duration(milliseconds: sliderSpeedValue.truncate()),
          () => _startChangingStatus());
    } else {
      currentIteration = 0;
      _startNow();
      return;
    }
    currentIteration++;
    setState(() {
      var newStatus = getNextStatus();
      if (_equalMatrix(_status, newStatus)) {
        currentIteration = iterations;
      } else {
        _status = getNextStatus();
      }
    });
  }

  List<Widget> getRows() {
    if (_status.length == 0) {
      _status = getFirstStatus();
    }
    List<Widget> result = new List();

    for (var row = 0; row < _status.length; row++) {
      List<Icon> icons = new List();
      for (var item = 0; item < _status[row].length; item++) {
        if (_status[row][item] == true) {
          icons.add(Icon(
            Icons.donut_large,
            color: Colors.red,
          ));
        } else {
          icons.add(Icon(
            Icons.donut_large,
            color: Colors.black38,
          ));
        }
      }

      result.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: icons,
      ));
    }

    return result;
  }

  Widget getCounter() {
    if (currentIteration == 0 || currentIteration == iterations) {
      return Icon(Icons.directions_run);
    } else {
      return Text("$currentIteration");
    }
  }

  _changeIterations(double e) {
    setState(() {
      iterations = e.truncate();
      sliderIterationsValue = e;
    });
  }

  _changeSpeed(double e) {
    setState(() {
      speed = e.truncate();
      sliderSpeedValue = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(children: getRows()),
            Divider(
              color: Colors.black38,
              height: 50,
            ),
            Column(children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Iterations",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                        child: Slider(
                      value: sliderIterationsValue,
                      min: 5,
                      max: 500,
                      onChanged: (double e) => _changeIterations(e),
                    )),
                    Text(
                      "$iterations",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Delay",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                        child: Slider(
                      value: sliderSpeedValue,
                      min: 100,
                      max: 1000,
                      onChanged: (double e) => _changeSpeed(e),
                    )),
                    Text(
                      "$speed ms",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ])
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNow,
        tooltip: 'GO',
        child: getCounter(),
      ), 
    );
  }
}
