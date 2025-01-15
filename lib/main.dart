import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../ViewModel/insight_view_model.dart';
import 'View/authentication_pages/first_page.dart';
import 'ViewModel/account_viewmodel.dart';
import 'ViewModel/app_appearance_viewmodel.dart'; // Import your InsightViewModel

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // root widget
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InsightViewModel()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
        ChangeNotifierProvider(create: (_) => AppAppearanceViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Homepage',
        theme: ThemeData(
          primarySwatch: Colors.teal, // determines the overall color palette for app
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF65ADAD),
          ),
        ),
        home: FirstPage(),
      ),
    );
  }
}


