import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:unifi/src/consts.dart';
import 'package:unifi/src/controller.dart';
import 'package:unifi/src/errors.dart';
import 'package:unifi/src/session.dart';

class WebSocketSession extends Session {
  int _autoReconnectInterval = 5;

  StreamController<Event> _sink = new StreamController<Event>.broadcast();
  Stream<Event> get stream => _sink.stream;

  late WebSocket _socket;
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

  Future<void> listen(
      {void Function(Event event)? onData,
      Function? onError,
      void onDone()?}) async {
    _add(EventType.connecting);

    if (!await login()) throw InvalidCredentials("Invalid login");
    try {
      _channel.sink.close();
    } catch (_) {}

    print('creating websocket: ${this.url.resolve(Endpoints.webSocket)}');
    this.stream.listen(onData, onError: onError, onDone: onDone);
    _socket = await WebSocket.connect(
        this.url.resolve(Endpoints.webSocket).toString(),
        headers: this.headers);
    _channel = IOWebSocketChannel(_socket);
    await _channel.stream.listen(_onData, onDone: _onDone, onError: _onError);

    _add(EventType.connected);
  }

  void close() {
    try {
      _isClosing = true;
      _channel.sink.close();
      _socket.close();
    } catch (_) {}
  }

  Future<void> _onData(dynamic message) async {
    _add(EventType.data, data: message);
  }

  void _onDone() async {
    if (!_isClosing) {
      _add(EventType.disconnected);
      _add(EventType.reconnecting, data: _autoReconnectInterval);
      await Future.delayed(Duration(seconds: _autoReconnectInterval));
      await login();
      await listen();
    }
  }

  void _onError(Object error) async {
    print("Error: ${error as WebSocketChannelException}");
    _add(EventType.error, data: error);
    if (!_isClosing) {
      _add(EventType.reconnecting, data: _autoReconnectInterval);
    }
  }

  void _onTimeout() async {
    print("TIME OUT");
  }

  void _add(EventType type, {dynamic data}) {
    if (!_sink.isClosed) _sink.add(Event(type, data: data));
  }
}
