import 'package:ddd_todo/presentation/core/app_widget.dart';
import 'package:ddd_todo/presentation/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
