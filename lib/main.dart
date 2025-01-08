import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';
import 'package:workshop_2/ViewModel/AIBudgetTextFieldViewModel.dart';
import 'package:workshop_2/ViewModel/AIBudgetViewModel.dart';
import 'package:workshop_2/ViewModel/AnalysisViewModel.dart';
import 'package:workshop_2/ViewModel/CategoryViewModel.dart';
import 'package:workshop_2/ViewModel/DateViewModel.dart';
import 'View/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'ViewModel/BudgetViewModel.dart';
import 'ViewModel/BudgetTextFieldViewModel.dart';


void main() async{
  int userid = 1;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CategoryViewModel()),
      ChangeNotifierProvider(create: (context) => BudgetTextFieldViewModel()),
      ChangeNotifierProvider(create: (context) => BudgetViewModel()),
      ChangeNotifierProvider(create: (context) => DateViewModel()),
      ChangeNotifierProvider(create: (context) => AIBudgetTextFieldViewModel()),
      ChangeNotifierProvider(create: (context) => AIBudgetViewModel()),
      ChangeNotifierProvider(create: (context) => AnalysisViewModel())
    ],
    child: MyApp(),
  ));
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