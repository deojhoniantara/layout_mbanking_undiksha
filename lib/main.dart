import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'provider/nasabah_provider.dart';
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await initializeDateFormatting('id_ID', null); 
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NasabahProvider()),
        ChangeNotifierProvider(create: (_) => MutasiProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koperasi Undiksha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
