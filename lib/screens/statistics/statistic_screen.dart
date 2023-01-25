import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/models/Expense.dart';
import 'package:targyalo/providers/category_provider.dart';

import '../../boxes.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  Map<String, double> data = {};

  @override
  void initState() {
    super.initState();
    List<String> categories = Provider.of<CategoryProvider>(context, listen: false).items;
    Box<Expense> categoryBox = Hive.box<Expense>(HiveBoxes.expense);
    List<Expense> expenses = categoryBox.values.toList();
    for (Expense expense in expenses){
      if(data.keys.contains(categories[expense.category])){
        double a = data[categories[expense.category]]!;
        data[categories[expense.category]] = a + expense.cost;
      }else{
        data[categories[expense.category]] = expense.cost;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PieChart(
            dataMap: data,
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: false,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListView.builder(
                  itemCount: data.keys.toList().length,
                  itemBuilder: (context, index) {
                    String key = data.keys.toList()[index];
                    return Container(
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
                        title: Text(
                          key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data[key].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
