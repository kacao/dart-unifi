part of 'package:unifi/src/controller.dart';

abstract class Ext {
  final Controller controller;

  Ext(this.controller);

  void dispose();
}
