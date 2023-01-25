import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/category_provider.dart';
import 'package:targyalo/screens/statistics/statistic_screen.dart';

import '../language.dart';
import '../main.dart';
import 'categories/category_screen.dart';
import 'expense_list/list_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Locale? _locale;
  final _screenOptions = [
    MyHomePage(),
    StatisticScreen(),
    CategoryScreen(),
  ];

  @override
  void dispose() async {
    Hive.close();
    super.dispose();
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    Provider.of<CategoryProvider>(context, listen: false).changeList(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale == null ? Locale("en", "") : _locale,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 20,
            title: const Text('ExpenseManager'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<Language>(
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  onChanged: (Language? language) {
                    if (language != null) {
                      MyApp.setLocale(context, Locale(language.languageCode, ""));
                      setLocale(Locale(language.languageCode, ""));
                    }
                  },
                  items: Language.languageList()
                      .map<DropdownMenuItem<Language>>(
                        (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
          body: Center(
            child: _screenOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100]!,
                  color: Colors.black,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: AppLocalizations.of(context)!.expenseList,
                    ),
                    GButton(
                      icon: LineIcons.pieChart,
                      text: AppLocalizations.of(context)!.statistics,
                    ),
                    GButton(
                      icon: LineIcons.list,
                      text: AppLocalizations.of(context)!.categoryList,
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        )
    );
  }
}