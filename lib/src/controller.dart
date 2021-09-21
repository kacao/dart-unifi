import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:core';

//import 'package:logging/logging.dart';
import 'package:unifi/src/session.dart';
import 'package:unifi/src/websocket.dart';

class Controller {
  final Session _session;
  final WebSocketSession _webSocketSession;

  Map<String, Ext> _extensions = {};

  get stream => _webSocketSession.stream;

  Controller(
      {required String host,
      int port = 443,
      required String username,
      required String password,
      String siteId: 'default',
      isUnifiOs = true})
      : _session = Session(
            host: host,
            port: port,
            username: username,
            password: password,
            siteId: siteId,
            isUnifiOs: isUnifiOs),
        _webSocketSession = WebSocketSession(
            host: host,
            port: port,
            username: username,
            password: password,
            siteId: siteId,
            isUnifiOs: isUnifiOs) {
    //log.level = Level.ALL;
    //log.onRecord.listen((record) {
    //  print('${record.level.name}: ${record.time}: ${record.message}');
    //});
  }

  factory Controller.fromMap(Map<String, dynamic> map) {
    return Controller(
        host: map['host'],
        port: map.containsKey('port') ? map['port'] : 443,
        username: map['username'],
        password: map['password'],
        siteId: map.containsKey('siteId') ? map['siteId'] : 'default',
        isUnifiOs: map.containsKey('isUnifiOs') ? map['isUnifiOs'] : true);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> payloads,
      {String? siteId, bool authenticate: true}) async {
    return await fetch(endpoint,
        payloads: payloads,
        method: Method.post,
        siteId: siteId,
        authenticate: authenticate);
  }

  Future<dynamic> fetch(String endpoint,
      {Method method: Method.get,
      Map<String, dynamic>? payloads,
      String? siteId,
      bool authenticate: true}) async {
    var res = await _session.fetch(
        endpoint: endpoint, method: method, payloads: payloads);

    if (res.statusCode == HttpStatus.ok) {
      return jsonDecode(res.body)['data'];
    }
  }

  Future<bool> login() async {
    return await _session.login();
  }

  Future<bool> logout() async {
    return await _session.logout();
  }

  Future<void> subscribe() async {
    print('start subscribing');
    await _webSocketSession.listen();
  }

  void dispose() {
    _extensions.values.forEach((element) {
      element.dispose();
    });
    logout();
  }

  Ext use(String key, Ext Function() ext) {
    return _extensions.putIfAbsent(key, ext);
  }
}

abstract class Ext {
  final Controller controller;

  Ext(this.controller);

  void dispose();
}

enum EventType {
  connecting,
  connected,
  disconnected,
  reconnecting,
  data,
  error,
  closing
}

class Event {
  final EventType type;
  final dynamic data;
  Event(this.type, {this.data}) {}
}
