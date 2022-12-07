import 'package:flutter/material.dart';
import 'package:my_mvvm/my_mvvm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter my_mvvm_package_example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'my_mvvm package example '),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CounterViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                viewModel._counter.toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          children: [
            const SizedBox(
              width: 50,
            ),
            FloatingActionButton(
              onPressed: viewModel.incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: viewModel.decrementCounter,
              tooltip: 'Decrement',
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.remove,
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => CounterViewModel(),
      onModelReady: (viewModel) => viewModel.setCounterTo999(),
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
    );
  }
}

// our view model initiliazed at here
class CounterViewModel extends BaseViewModel {
  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if (counter != 0) {
      _counter--;
    }
    notifyListeners();
  }

  void setCounterTo999() {
    _counter = 999;
    notifyListeners();
  }
}
