import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'sql_connection.dart';
import 'home_page.dart';



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
  // root widget
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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