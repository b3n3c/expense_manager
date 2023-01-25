import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/expense_provider.dart';
import 'form_parts/address_card.dart';
import '../../boxes.dart';
import '../../models/Expense.dart';
import '../../providers/category_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'form_parts/contact_card.dart';
import 'form_parts/picture.dart';

class ViewExpense extends StatefulWidget {
  int index;

  ViewExpense({Key? key, required this.index}) : super(key: key);

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();

  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmit();
      print("Form Validated");
    } else {
      print("Form Not Validated");
      return;
    }
  }

  String getCategory(int index){
    if(index < Provider.of<CategoryProvider>(context, listen: false).items.length){
      return Provider.of<CategoryProvider>(context, listen: false).items[index];
    }else
      return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.details),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    initialValue: context.watch<ExpenseProvider>().expense.title,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.title),
                    onChanged: (value) {
                      context.read<ExpenseProvider>().setTitle(value);
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().length == 0) {
                        return AppLocalizations.of(context)!.required;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: context.watch<ExpenseProvider>().expense.cost.toString(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.cost,
                    ),
                    onChanged: (value) {
                      context.read<ExpenseProvider>().setCost(double.parse(value));
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().length == 0) {
                        return AppLocalizations.of(context)!.required;
                      }
                      return null;
                    },
                  ),
                  DropdownButton<String>(
                    value: getCategory(context.watch<ExpenseProvider>().expense.category),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: Provider.of<CategoryProvider>(context, listen: false).items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      context.read<ExpenseProvider>().setCategory(
                          Provider.of<CategoryProvider>(context, listen: false).items.indexOf(newValue!)
                      );
                    },
                  ),
                  TextField(
                    controller: dateInput,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: context.watch<ExpenseProvider>().expense.date
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(Provider.of<ExpenseProvider>(context, listen: false).expense.date),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        context.read<ExpenseProvider>().setDate(formattedDate);
                        setState(() {
                          dateInput.text =
                              formattedDate;
                        });
                      } else {}
                    },
                  ),
                  ReceiptPicture(path: context.watch<ExpenseProvider>().expense.receiptPath),
                  AddressCard(address: context.watch<ExpenseProvider>().getAddress()),
                  ContactCard(contact: context.watch<ExpenseProvider>().getContact()),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        validated();
                      },
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onFormSubmit() {
    Box<Expense> expenseBox = Hive.box<Expense>(HiveBoxes.expense);
    expenseBox.putAt(widget.index, Provider.of<ExpenseProvider>(context, listen: false).expense);
    Navigator.of(context).pop();
  }
}
