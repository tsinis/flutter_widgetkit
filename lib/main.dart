import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show AsyncValueSetter;

import 'database_service.dart';

/// Entry point for any Flutter application.
Future<void> main() async {
  /// Need this one to initialize the database, but since DB service have no
  /// idea when and from where it's being started, it's a good place use it.
  WidgetsFlutterBinding.ensureInitialized();

  /// Opens a database and returns a [DatabaseService] instance to store values.
  final db = await DatabaseService.openDb();

  /// Run our app and provide initial count with save to DB callback.
  runApp(
    CupertinoApp(
      home: MyHomePage(await db.getCount(), onUpdate: db.updateCount),
    ),
  );
}

/// Home page with a counter and a button to update it, similar to default one.
class MyHomePage extends StatefulWidget {
  const MyHomePage(this._storedCount, {required this.onUpdate, super.key});

  /// Initial tap count to display, that might be stored in DB.
  final int? _storedCount;

  /// Callback to update the count in the DB.
  final AsyncValueSetter<int> onUpdate;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State for [MyHomePage] to manage the counter and the button.
class _MyHomePageState extends State<MyHomePage> {
  /// Default text style for all texts on the page.
  static const _style = TextStyle(color: CupertinoColors.systemGrey);

  /// Current taps count to display.
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    /// Set initial count from database if it's available.
    _counter = widget._storedCount ?? 0;
  }

  /// Increments the counter and updates the DB, as in default counter app,
  /// but with async callback to save/update tap counts in database.
  Future<void> _incrementCounter() {
    /// Update count on UI.
    setState(() => _counter++);

    /// Update count in database.
    return widget.onUpdate(_counter);
  }

  /// iOS-style page with counter and button to increment it.
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
