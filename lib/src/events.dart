library unifi;

import 'dart:core';
import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';
import './controller.dart';
import './http.dart';
import 'package:path/path.dart' as path;

enum EventType {
  connecting,
  connected,
  disconnected,
  reconnecting,
  data,
  error,
  closing
}

class Events {
  UnifiController _controller;
  StreamController _streamController = new StreamController.broadcast();
  IOWebSocketChannel _channel;
  bool _closing = false;
  int reconnectDelay = 5;
  Client _client;
  WebSocket _ws;
  Uri _wsUrl;
  Stream<dynamic> get stream => _streamController.stream;

  Events(this._controller, Client client) {
    String p = path
        .join(epBase, epWebsocket)
        .replaceFirst("%site%", _controller.siteId);
    _wsUrl = Uri.parse("wss://${p}");
    _client = client;
  }

  void connect() async {
    _streamController.add(Event(EventType.connecting));
    if (!_controller.authenticated) {
      await _controller.login();
    }
    _ws = await _controller.createWebSocket();
    print(_ws.readyState);
    await _ws.listen(_onData, onDone: _onDone, onError: _onError);
    _streamController.add(Event(EventType.connected));
    /*WebSocket ws = await _client.createWebSocket(_wsUrl,
        headers: _controller.getHeaders());
    _ws = ws;
    print(await ws.listen(_onData, onDone: _onDone, onError: _onError));
    _streamController.add(Event(EventType.connected));
    print('after listen');*/
  }

  void _onData(dynamic message) async {
    _streamController.add(Event(EventType.data, data: message));
  }

  void _onDone() async {
    print('done');
    _streamController.add(Event(EventType.disconnected));
    if (!_closing) {
      print('reconnecting');
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
      await Future.delayed(Duration(seconds: reconnectDelay));
      await connect();
    }
  }

  void _onError(Object error) async {
    print('error');
    print(error);
    _streamController.add(Event(EventType.error, data: error));
    if (!_closing) {
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
    }
  }

  void close() async {
    print('closing');
    _streamController.add(Event(EventType.closing));
    _closing = true;
    _ws.close();
    _streamController.close();
  }
}

class Event {
  EventType type;
  dynamic data;
  Event(this.type, {this.data}) {}
}
