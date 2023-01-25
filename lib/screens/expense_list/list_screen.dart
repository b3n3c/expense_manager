import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/screens/expense_list/view_expense_screen.dart';
import '../../boxes.dart';
import '../../models/Expense.dart';
import 'add_expense_screen.dart';
import 'package:targyalo/providers/expense_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListScreen extends StatefulWidget {

  ListScreen ({Key? key}): super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();

}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage ({Key? key}): super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Expense>(HiveBoxes.expense).listenable(),
          builder: (context, Box<Expense> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.emptyList),
              );
            }

            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Expense? res = box.getAt(index);
                return Dismissible(
                  background: Container(color: Colors.red),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    res!.delete();
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                    ),
                    child: ListTile(
                        tileColor: Colors.white,
                        title: Text(res!.title),
                        subtitle: Text(res.addressName),
                        trailing: Text(
                            res.cost.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          context.read<ExpenseProvider>().setExpense(res);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewExpense(index: index),
                            )
                          );
                        }),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.addExpense,
        child: Icon(Icons.add),
        onPressed: () {
          context.read<ExpenseProvider>().makeEmpty();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(),
            )
          );
        }
      ),
    );
  }
}