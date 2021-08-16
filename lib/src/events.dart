import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';
import './controller.dart';

enum EventType {
  connecting,
  connected,
  disconnected,
  reconnecting,
  data,
  error,
  closing
}

const epWebsocket = 'wss/s/%site%/events';

class Events {
  UnifiController _controller;
  StreamController _streamController = new StreamController.broadcast();
  IOWebSocketChannel _channel;
  WebSocket _ws;
  Stream get stream => _streamController.stream;
  Uri _url;

  bool _closing = false;
  int reconnectDelay = 5;

  Events(this._controller) {
    _url = Uri(scheme: "wss", host: _controller.host, port: _controller.port)
        .resolve(epBase)
        .resolve(epWebsocket);
  }

  connect() {
    _streamController.add(Event(EventType.connecting));
    WebSocket.connect(_url.toString(), headers: _controller.getHeaders())
        .then((ws) {
      _ws = ws;
      _channel = IOWebSocketChannel(ws);
      ws.listen(_onData, onDone: _onDone, onError: _onError);
      _streamController.add(Event(EventType.connected));
    });
  }

  _onData(dynamic message) async {
    _streamController.add(Event(EventType.data, data: message));
    return this;
  }

  _onDone() async {
    _streamController.add(Event(EventType.disconnected));
    if (!_closing) {
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
      await Future.delayed(Duration(seconds: reconnectDelay));
      await connect();
    }
    return this;
  }

  _onError(Object error) async {
    _streamController.add(Event(EventType.error, data: error));
    if (!_closing) {
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
    }
    return this;
  }

  close() {
    _streamController.add(Event(EventType.closing));
    _closing = true;
    _streamController.close();
    _ws.close(status.goingAway);
  }
}

class Event {
  EventType type;
  dynamic data;
  Event(this.type, {this.data}) {}
}
