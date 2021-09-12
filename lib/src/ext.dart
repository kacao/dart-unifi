part of 'package:unifi/src/controller.dart';

abstract class Ext {
  final BaseController controller;

  Ext(this.controller);

  void dispose();
}
