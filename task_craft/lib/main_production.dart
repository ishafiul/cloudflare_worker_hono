import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_craft/app/app.dart';
import 'package:task_craft/bootstrap.dart';
import 'package:task_craft/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
