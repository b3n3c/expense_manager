import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../boxes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryProvider with ChangeNotifier {

  Box<String> categoryBox = Hive.box<String>(HiveBoxes.category);
  List<String> _items = Hive.box<String>(HiveBoxes.category).isEmpty ?
  ["Food", "Travel", "Transportation", "Investment", "Utility", "Personal", "Healthcare"] :
  Hive.box<String>(HiveBoxes.category).values.toList();

  UnmodifiableListView<String> get items => UnmodifiableListView(_items);

  void add(String item) {
    _items.add(item);
    categoryBox.add(item);
    notifyListeners();
  }

  void changeList(Locale locale){
    if(categoryBox.isEmpty){
      if(locale.languageCode == "hu"){
        _items = [
          "Étel",
          "Utazás",
          "Közlekedés",
          "Befektetés",
          "Közmű",
          "Személyes",
          "Egészségügy"
        ];
      }else if(locale.languageCode == "en"){
        _items = [
          "Food",
          "Travel",
          "Transportation",
          "Investment",
          "Utility",
          "Personal",
          "Healthcare"
        ];
      }
    }
    notifyListeners();
  }

  void remove(String item) {
    _items.remove(item);
    if(categoryBox.isEmpty){
      for (var element in _items) { categoryBox.add(element); }
    }else if(categoryBox.values.contains(item)){
      categoryBox.deleteAt(categoryBox.values.toList().indexOf(item));
    }
    notifyListeners();
  }

  bool alert(){
    return categoryBox.isEmpty;
  }
}