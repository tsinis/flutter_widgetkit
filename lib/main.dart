import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show AsyncValueSetter;

import 'database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseService.openDb;
  runApp(
    CupertinoApp(
      home: MyHomePage(await db.getCount(), onUpdate: db.updateCount),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.count, {required this.onUpdate, super.key});

  final int? count;
  final AsyncValueSetter<int> onUpdate;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _style = TextStyle(color: CupertinoColors.systemGrey);

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.count ?? 0;
  }

  Future<void> _incrementCounter() {
    setState(() => _counter++);

    return widget.onUpdate(_counter);
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('WidgetKit with Flutter'),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text.rich(
                style: _style,
                textAlign: TextAlign.center,
                TextSpan(
                  text: '\nYou have pushed the button this many times:',
                  children: [
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: _counter.toString(),
                      style: _style.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                onPressed: _incrementCounter,
                color: CupertinoColors.systemBlue,
                child: const Icon(CupertinoIcons.add),
              ),
            ],
          ),
        ),
      );
}
