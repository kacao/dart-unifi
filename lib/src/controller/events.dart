part of 'controller.dart';

enum EventType {
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
  late Controller _controller;
  StreamController _streamController = new StreamController.broadcast();
  bool _closing = false;
  int reconnectDelay = 5;
  WebSocket? _ws = null;
  late String _url;
  Stream<dynamic> get stream => _streamController.stream;
  ReadyState? get readyState => _readyStateMap[_ws?.readyState ?? 3];
  Events(this._controller) {
    _url = addSiteId(this._controller._urlWs.toString(), _controller.siteId);
  }

  Future<void> connect() async {
    _streamController.add(Event(EventType.connecting));
    if (!_controller.authenticated) {
      await _controller.login();
    }
    _ws = await _controller._client
        .createWebSocket(_url.toString(), _controller.getHeaders());
    await _ws?.listen(_onData, onDone: _onDone, onError: _onError);
    _streamController.add(Event(EventType.connected));
  }

  Future<void> _onData(dynamic message) async {
    _streamController.add(Event(EventType.data, data: message));
  }

  Future<void> _onDone() async {
    if (!_closing) {
      _streamController.add(Event(EventType.disconnected));
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
      await Future.delayed(Duration(seconds: reconnectDelay));
      await connect();
    }
  }

  Future<void> _onError(Object error) async {
    print(error);
    _streamController.add(Event(EventType.error, data: error));
    if (!_closing) {
      _streamController
          .add(Event(EventType.reconnecting, data: reconnectDelay));
    }
  }

  void dispose() {
    _streamController.add(Event(EventType.closing));
    _closing = true;
    _ws?.close();
    _streamController.close();
  }
}

class Event {
  EventType type;
  dynamic data;
  Event(this.type, {this.data}) {}
}
