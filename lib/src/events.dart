part of 'package:unifi/src/controller.dart';

enum EventType {
  authenticated,
  unauthenticated,
  connecting,
  connected,
  disconnected,
  reconnecting,
  data,
  error,
  closing
}

enum ReadyState { connecting, open, closing, closed }
Map<int, ReadyState> _readyStateMap = {
  0: ReadyState.connecting,
  1: ReadyState.open,
  2: ReadyState.closing,
  3: ReadyState.closed
};

class Events {
  bool _closing = false;
  int reconnectDelay = 5;
  WebSocket? _ws = null;
  late String _url;
  Stream<dynamic> get stream => _controller._sink.stream;
  ReadyState? get readyState => _readyStateMap[_ws?.readyState ?? 3];
  late Controller _controller;
  Events(this._controller) {
    _url = addSiteId(_controller._urlWs.toString(), _controller.siteId);
  }

  Future<void> connect() async {
    _add(Event(EventType.connecting));
    if (_controller.authenticated) {
      await _controller.login();
    }
    _ws = await _controller._client
        .createWebSocket(_url.toString(), _controller.getHeaders());
    await _ws?.listen(_onData, onDone: _onDone, onError: _onError);
    _add(Event(EventType.connected));
  }

  Future<void> _onData(dynamic message) async {
    _add(Event(EventType.data, data: message));
  }

  Future<void> _onDone() async {
    if (!_closing) {
      _add(Event(EventType.disconnected));
      _add(Event(EventType.reconnecting, data: reconnectDelay));
      await Future.delayed(Duration(seconds: reconnectDelay));
      await connect();
    }
  }

  Future<void> _onError(Object error) async {
    print(error);
    _add(Event(EventType.error, data: error));
    if (!_closing) {
      _add(Event(EventType.reconnecting, data: reconnectDelay));
    }
  }

  void _add(Event event) {
    if (!_controller._sink.isClosed) _controller._sink.add(event);
  }

  void dispose() {
    _add(Event(EventType.closing));
    _closing = true;
    _ws?.close();
  }
}

class Event {
  final EventType type;
  final dynamic data;
  Event(this.type, {this.data}) {}
}
