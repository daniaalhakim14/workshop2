import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:workshop_2/budget_tab_page.dart';
import 'home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';


void main() async{
  try {  // make connection with database
    final conn = await Connection.open(Endpoint(
      host: 'duitappworkshop2.postgres.database.azure.com',
      database: 'postgres',
      username: 'duit_admin',
      password: '@Bcd1234',
    ));
    print('Database connection successful!');
    runApp(MyApp());
  }catch (e) {
    print('Database connection failed: $e');
    // Optionally, handle the error (e.g., show an error screen or retry)
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // root widget
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // Add this for month-year picker
      ],

      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.teal, // determines the overall color palette for app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.tealAccent,
        )
      ),
      home: Home(),
    );
  }
}