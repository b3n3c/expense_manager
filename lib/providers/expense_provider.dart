import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:intl/intl.dart';
import 'package:targyalo/models/Address.dart';
import 'package:targyalo/models/Expense.dart';

class ExpenseProvider extends ChangeNotifier{
  Expense expense = Expense("", 0.0, "", DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Address.SZEGED_LATLNG.latitude, Address.SZEGED_LATLNG.longitude,
      "Szeged", "", "", 0);

  void makeEmpty(){
    expense = Expense("", 0.0, "", DateFormat('yyyy-MM-dd').format(DateTime.now()),
        Address.SZEGED_LATLNG.latitude, Address.SZEGED_LATLNG.longitude,
        "Szeged", "", "", 0);
  }

  void setExpense(Expense expense){
    this.expense = expense;
    notifyListeners();
  }

  void setTitle(String title){
    expense.title = title;
    notifyListeners();
  }

  void setCost(double cost){
    expense.cost = cost;
    notifyListeners();
  }

  void setDate(String date){
    expense.date = date;
    notifyListeners();
  }

  void setAddress(Address address){
    expense.addressName = address.name;
    expense.lat = address.latLng.latitude;
    expense.lng = address.latLng.longitude;
    notifyListeners();
  }

  void setContact(Contact? contact){
    if(contact != null){
      expense.contactName = contact.fullName!;
      expense.contactNumber = contact.phoneNumbers!.first;
    }else{
      expense.contactName = "";
      expense.contactNumber = "";
    }

    notifyListeners();
  }

  void setReceiptPath(String path){
    expense.receiptPath = path;
    notifyListeners();
  }

  void setCategory(int index){
    expense.category = index;
    notifyListeners();
  }

  Address getAddress(){
    Address a = Address(
        name: expense.addressName,
        latitude: expense.lat,
        longitude: expense.lng)
    ;
    return a;
  }

  Contact getContact(){
    Contact contact = Contact(
      fullName: expense.contactName,
      phoneNumbers: [expense.contactNumber]
    );
    return contact;
  }
}