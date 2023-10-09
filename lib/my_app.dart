import 'package:dioproject/pages/bmi_records_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const BmiRecordsPage(),
        theme: ThemeData(
            primarySwatch: Colors.orange,
            textTheme: GoogleFonts.latoTextTheme()));
  }
}
