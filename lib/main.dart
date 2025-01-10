import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:workshop2/pages/checkemailpage.dart';
import 'package:workshop2/pages/first_page.dart';
import 'package:workshop2/pages/homepage.dart';
import 'package:workshop2/pages/loginpage.dart';
import 'package:workshop2/pages/passwordrecovery.dart';
import 'package:workshop2/pages/signuppage.dart';
import 'package:workshop2/setnewpassword.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:FirstPage(),
    );
  }
}


