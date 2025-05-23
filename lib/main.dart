import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:tab_bar_widget/ViewModel/change_email_viewmodel.dart';
import 'View/Main_pages/first_page.dart';
import 'ViewModel/AIBudgetTextFieldViewModel.dart';
import 'ViewModel/AIBudgetViewModel.dart';
import 'ViewModel/AnalysisViewModel.dart';
import 'ViewModel/BudgetTextFieldViewModel.dart';
import 'ViewModel/BudgetViewModel.dart';
import 'ViewModel/CategoryViewModel.dart';
import 'ViewModel/DateViewModel.dart';
import 'ViewModel/Income/Income_View_Model.dart';
import 'ViewModel/InsightPage_ViewModel/InsightPage_View_Model.dart';
import 'ViewModel/SignupLoginPage_ViewModel/SignupLoginPage_View_Model.dart';
import 'ViewModel/account_viewmodel.dart';
import 'ViewModel/app_appearance_viewmodel.dart'; // Import your InsightViewModel
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ViewModel/change_password_viewmodel.dart';
import 'admin_dashboard/models/services/local_notification_service.dart';
import 'ViewModel/edit_profile_viewmodel.dart';
import 'loading.dart';
import 'configure_API.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  initPusher();
  listenToNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // root widget
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InsightViewModel()),
        ChangeNotifierProvider(create: (_) => SignupLoginPage_ViewModule()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
        ChangeNotifierProvider(create: (_) => AppAppearanceViewModel()),
        ChangeNotifierProvider(create: (context) => CategoryViewModel()),
        ChangeNotifierProvider(create: (context) => BudgetTextFieldViewModel()),
        ChangeNotifierProvider(create: (context) => BudgetViewModel()),
        ChangeNotifierProvider(create: (context) => DateViewModel()),
        ChangeNotifierProvider(create: (context) => AIBudgetTextFieldViewModel()),
        ChangeNotifierProvider(create: (context) => AIBudgetViewModel()),
        ChangeNotifierProvider(create: (context) => AnalysisViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => IncomeViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ChangeEmailViewModel()),




      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF65ADAD),
          ),
        ),
        home: FirstPage(),
      ),
    );
  }
}


