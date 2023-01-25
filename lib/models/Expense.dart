import 'package:hive/hive.dart';
part "Expense.g.dart";

@HiveType(typeId: 0)
class Expense extends HiveObject{
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double cost;

  @HiveField(3)
  String receiptPath;

  @HiveField(4)
  String date;

  @HiveField(5)
  double lat;

  @HiveField(6)
  double lng;

  @HiveField(7)
  String addressName;

  @HiveField(8)
  String contactName;

  @HiveField(9)
  String contactNumber;

  @HiveField(10)
  int category;

  Expense(this.title, this.cost, this.receiptPath, this.date, this.lat,
      this.lng, this.addressName, this.contactName, this.contactNumber, this.category);

}