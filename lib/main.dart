import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:notes_app/services/connectivity_service.dart';
import 'package:notes_app/themes/app_theme.dart';

import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';
import 'auth/auth_wrapper.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider2<AuthProvider, ConnectivityService, NotesProvider>(
          create: (_) => NotesProvider(null),
          update: (_, authProvider, connectivityService, notesProvider) =>
              NotesProvider(authProvider.user?.uid),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: AppTheme.theme,
        home: const AuthWrapper(),
      ),
    );
  }
}

