import 'package:devtools_plugins/devtools_plugins.dart';
import 'package:flutter/material.dart';

import 'package:devtools_plugins/devtools_plugin_template.dart';

void main() {
  runApp(const FooPackageDevToolsPlugin());
}

class FooPackageDevToolsPlugin extends StatelessWidget {
  const FooPackageDevToolsPlugin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foo DevTools Plugin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DevToolsPlugin(
        child: FooExtensionHomePage(),
      ),
    );
  }
}

class FooExtensionHomePage extends StatefulWidget {
  const FooExtensionHomePage({super.key});

  @override
  State<FooExtensionHomePage> createState() => _FooExtensionHomePageState();
}

class _FooExtensionHomePageState extends State<FooExtensionHomePage> {
  int _counter = 0;

  String? _message;

  @override
  void initState() {
    super.initState();
    // Example of the devtools plugin registering a custom handler.
    pluginManager.registerEventHandler(
      DevToolsPluginEventType.testEvent,
      (event) {
        setState(() {
          _message = event.data?['message'] as String?;
        });
      },
    );
  }

  void _incrementCounter() {
    pluginManager.postMessageToDevTools(
      DevToolsPluginEvent(
        DevToolsPluginEventType.testEvent,
        data: {'increment_count': _counter},
      ),
    );
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Foo DevTools Plugin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24.0),
            Text(
              'Message from DevTools: $_message',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Text('Post to DevTools'),
      ),
    );
  }
}
