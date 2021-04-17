import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';
import './controller.dart';

class Events {
  UnifiController _controller;
  IOWebSocketChannel _events;
  Function(dynamic message) _onData;
  Function _onDone;
  Function(Object error) _onError;

  Events(this._controller) {}

  listen() {
    _events = IOWebSocketChannel.connect(_controller.websocketUrl,
        headers: _controller.getHeaders());
    _events.stream.listen(_onData, onError: _onError, onDone: _onDone);
  }

  onData(void f(dynamic message)) {
    _onData = f;
    return this;
  }

  onDone(void f()) {
    _onDone = f;
    return this;
  }

  onError(void f(Object error)) {
    _onError = f;
    return this;
  }

  close() {
    _events.sink.close(status.goingAway);
  }
}
