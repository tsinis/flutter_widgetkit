import 'package:flutter/cupertino.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoApp(
        home: MyHomePage(title: 'WidgetKit with Flutter'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  static const _style = TextStyle(color: CupertinoColors.black);

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(widget.title)),
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
                    const TextSpan(text: '\n\n'),
                    TextSpan(
                      text: _counter.toString(),
                      style: _style.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
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
