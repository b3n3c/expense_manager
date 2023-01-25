import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/category_provider.dart';
import 'package:targyalo/providers/expense_provider.dart';
import 'package:targyalo/screens/categories/category_screen.dart';
import 'package:targyalo/screens/home_screen.dart';
import 'package:targyalo/screens/expense_list/list_screen.dart';
import 'package:targyalo/screens/statistics/statistic_screen.dart';
import 'boxes.dart';
import 'language.dart';
import 'models/Expense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  //   hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>(HiveBoxes.expense);
  await Hive.openBox<String>(HiveBoxes.category);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider())
      ],
      child: MyApp()
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    Provider.of<CategoryProvider>(context, listen: false).changeList(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Localization',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale == null ? Locale("en", "") : _locale,
        home: HomeScreen()
    );
  }
}