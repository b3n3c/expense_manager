import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:targyalo/boxes.dart';
import 'package:targyalo/models/Expense.dart';
import 'package:targyalo/providers/category_provider.dart';
import 'package:targyalo/providers/expense_provider.dart';
import 'package:targyalo/screens/expense_list/add_expense_screen.dart';

void main() {
  group('ExpenseScreen', () {
    testWidgets('localizatons correct', (WidgetTester tester) async {
      await Hive.initFlutter();
      await tester.runAsync(()=>Hive.openBox<Expense>(HiveBoxes.expense));
      await tester.runAsync(()=>Hive.openBox<String>(HiveBoxes.category));
      await tester.pumpWidget(
        Localizations(
          locale: Locale('en', ''),
          delegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ExpenseProvider()),
                ChangeNotifierProvider(create: (_) => CategoryProvider())
              ],
              child: MaterialApp(
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: Locale("en", ""),
                  home: AddExpenseScreen()),
          ),
        ),
      );

      final textFinder = find.text("Add Expense");
      expect(textFinder, findsOneWidget);
    });
  });
}