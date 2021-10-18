import 'package:flutter/material.dart';
import 'package:one_time_actions/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:one_time_actions/my_test_prov.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyTest>(
      create: (_) => MyTest(),
      child: MaterialApp(
        title: 'One time actions',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final MyTest myProv;

  @override
  void initState() {
    super.initState();
    myProv = context.read<MyTest>();
    myProv.addListener(registerListener);
  }

  @override
  void dispose() {
    myProv.removeListener(registerListener);
    super.dispose();
  }

  void registerListener() {
    if (myProv.state.status == MyTestStatus.error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Error: ${myProv.state.status}'),
          );
        },
      );
    } else if (myProv.state.status == MyTestStatus.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return NextScreen();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyTest>().state;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text(
            state.status == MyTestStatus.loading
                ? 'Loading...'
                : 'Do Something',
            style: TextStyle(fontSize: 24.0),
          ),
          onPressed: state.status == MyTestStatus.loading
              ? null
              : () {
                  context.read<MyTest>().doSomething();
                },
        ),
      ),
    );
  }
}
