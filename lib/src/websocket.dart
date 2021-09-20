import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:unifi/src/controller.dart';
import 'package:unifi/src/errors.dart';
import 'package:unifi/src/session.dart';

class WebSocketSession extends Session {
  int _autoReconnectInterval = 5;

  StreamController _sink = new StreamController.broadcast();
  Stream get stream => _sink.stream;

  late WebSocketChannel _channel;

  bool _isClosing = false;

  WebSocketSession(
      {required String host,
      required int port,
      required String username,
      required String password,
      required String siteId,
      required bool isUnifiOs})
      : super(
            host: host,
            port: port,
            username: username,
            password: password,
            siteId: siteId,
            isUnifiOs: isUnifiOs);

  factory WebSocketSession.fromMap(Map<String, dynamic> map,
      {bool isUnifiOs = true}) {
    return WebSocketSession(
        host: map['host'],
        port: map['port'],
        username: map['username'],
        password: map['password'],
        siteId: map['siteId'],
        isUnifiOs: isUnifiOs);
  }

  Future<void> listen() async {
    _add(EventType.connecting);

    if (!await login()) throw InvalidCredentials("Invalid login");
    try {
      _channel.sink.close();
    } catch (_) {}

    print('creating websocket: ${url.websocket}');

    _channel =
        IOWebSocketChannel.connect(this.url.websocket, headers: this.headers);
    await _channel.stream.listen(_onData, onDone: _onDone, onError: _onError);

    _add(EventType.connected);
  }

  void close() {
    try {
      _isClosing = true;
      _channel.sink.close();
    } catch (_) {}
  }

  Future<void> _onData(dynamic message) async {
    _add(EventType.data, data: message);
  }

  Future<void> _onDone() async {
    if (!_isClosing) {
      _add(EventType.disconnected);
      _add(EventType.reconnecting, data: _autoReconnectInterval);
      await Future.delayed(Duration(seconds: _autoReconnectInterval));
      await listen();
    }
  }

  Future<void> _onError(Object error) async {
    print(error);
    _add(EventType.error, data: error);
    if (!_isClosing) {
      _add(EventType.reconnecting, data: _autoReconnectInterval);
    }
  }

  void _add(EventType type, {dynamic data}) {
    if (!_sink.isClosed) _sink.add(Event(type, data: data));
  }
}
