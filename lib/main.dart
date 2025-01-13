import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'View/home_page.dart';
import '../ViewModel/insight_view_model.dart'; // Import your InsightViewModel

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
        home: Home(),
      ),
    );
  }
}
