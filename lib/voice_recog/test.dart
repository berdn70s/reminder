import 'package:alan_voice/alan_voice.dart';
// ignore: unused_import
import 'dart:typed_data';
// ignore: unused_import
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: unused_import
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlanSDK Flutter',
      home: MyHomePage(title: 'AlanSDK Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({ Key? key, this.title = "Flutter example" }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    /// Init Alan Button with project key from Alan Studio - log in to https://studio.alan.app, go to your project > Integrations > Alan SDK Key
    AlanVoice.addButton(
        "b8fedf8e596df9dac5434247b2b0a4802e956eca572e1d8b807a3e2338fdd0dc/stage");

    /// ... or init Alan Button with project key and additional params
    // var params = jsonEncode({"uuid":"111-222-333-444"});
    // AlanVoice.addButton("8e0b083e795c924d64635bba9c3571f42e956eca572e1d8b807a3e2338fdd0dc/stage", authJson: params);

    /// Set log level - "all", "none"
    AlanVoice.setLogLevel("none");

    /// Add button state handler
    AlanVoice.onButtonState.add((state) {
      debugPrint("got new button state ${state.name}");
    });

    /// Add command handler
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });

    /// Add event handler
    AlanVoice.onEvent.add((event) {
      debugPrint("got new event ${event.data.toString()}");
    });

    /// Activate Alan Button
    // ignore: unused_element
    void _activate() {
      AlanVoice.activate();
    }

    /// Deactivate Alan Button
    // ignore: unused_element
    void _deactivate() {
      AlanVoice.deactivate();
    }

    /// Send any text via Alan Button
    // ignore: unused_element
    void _sendText() {
      /// Provide text as string param
      AlanVoice.sendText("Hello from Alan");
    }

    /// Play any text via Alan Button
    // ignore: unused_element
    void _playText() {
      /// Provide text as string param
      AlanVoice.playText("Hello from Alan");
    }

    /// Execute any command locally (and handle it with onCommand callback)
    // ignore: unused_element
    void _playCommand() {
      /// Provide any params with json
      var command = jsonEncode({"command": "commandName"});
      AlanVoice.playCommand(command);
    }

    /// Call project API from Alan Studio script
    // ignore: unused_element
    void _callProjectApi() {
      /// Provide any params with json
      var params = jsonEncode({"apiParams": "paramsValue"});
      AlanVoice.callProjectApi("projectAPI", params);
    }

    /// Set visual state in Alan Studio script
    // ignore: unused_element
    void _setVisualState() {
      /// Provide any params with json
      var visualState = jsonEncode({"visualState": "stateValue"});
      AlanVoice.setVisualState(visualState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Text(
          'Alan Button Example',
        ));
  }
}