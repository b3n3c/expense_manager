import 'package:flutter_test/flutter_test.dart';
import 'package:targyalo/models/Address.dart';
import 'package:targyalo/models/Expense.dart';
import 'package:targyalo/providers/expense_provider.dart';

void main() {
  group('Expense', () {
    test('stores expense correctly', () {
      var model = ExpenseProvider();
      model.expense = Expense(
          "Teszt", 50.0, "", "", 50, 60, "Teszt cím", "Teszt kontakt", "+362058616", 2
      );
      expect(model.expense.title, "Teszt");
      expect(model.expense.cost, 50);
      expect(model.expense.receiptPath, "");
      expect(model.expense.date, "");
      expect(model.expense.lat, 50);
      expect(model.expense.lng, 60);
      expect(model.expense.addressName, "Teszt cím");
      expect(model.expense.contactName, "Teszt kontakt");
      expect(model.expense.contactNumber, "+362058616");
      expect(model.expense.category, 2);
    });

    test('returns correct address', () {
      var model = ExpenseProvider();
      model.expense = Expense(
          "Teszt", 50.0, "", "", 50, 60, "Teszt cím", "Tezst kontakt", "+362058616", 2
      );
      Address a = Address(name: "Teszt cím", latitude: 50, longitude: 60);

      expect(model.getAddress().name, a.name);
      expect(model.getAddress().latitude, a.latitude);
      expect(model.getAddress().longitude, a.longitude);
    });
  });
}
