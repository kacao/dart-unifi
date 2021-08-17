library unifi;

import 'dart:core';
import 'dart:async';
import 'dart:io';

import './controller.dart';
import './http.dart';

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
  bool _closing = false;
  int reconnectDelay = 5;
  Client _client;
  WebSocket _ws;
  Uri _url;
  Stream<dynamic> get stream => _streamController.stream;

  Events(this._controller, this._client) {
    _url = _controller.websocketUrl;
  }

  void connect() async {
    _streamController.add(Event(EventType.connecting));
    if (!_controller.authenticated) {
      await _controller.login();
    }
    _ws = await _client.createWebSocket(
        _url.toString(), _controller.getHeaders());
    await _ws.listen(_onData, onDone: _onDone, onError: _onError);
    _streamController.add(Event(EventType.connected));
  }

  void _onData(dynamic message) async {
    _streamController.add(Event(EventType.data, data: message));
  }

  void _onDone() async {
    print('done');
    if (!_closing) {
      _streamController.add(Event(EventType.disconnected));
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
      await Future.delayed(Duration(seconds: reconnectDelay));
      await connect();
    }
  }

  void _onError(Object error) async {
    print(error);
    _streamController.add(Event(EventType.error, data: error));
    if (!_closing) {
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
    }
  }

  void close() async {
    _streamController.add(Event(EventType.closing));
    _closing = true;
    if (_ws != null) {
      _ws.close();
    }
    _streamController.close();
  }
}

class Event {
  EventType type;
  dynamic data;
  Event(this.type, {this.data}) {}
}
