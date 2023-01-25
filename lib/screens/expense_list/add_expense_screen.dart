import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:hive/hive.dart';
import 'package:targyalo/screens/expense_list/form_parts/address_card.dart';
import 'package:targyalo/models/Address.dart';
import 'package:targyalo/models/Expense.dart';
import 'package:intl/intl.dart';
import 'package:targyalo/providers/category_provider.dart';
import 'package:targyalo/providers/expense_provider.dart';
import 'package:targyalo/screens/expense_list/form_parts/contact_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../boxes.dart';
import 'form_parts/picture.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({Key? key}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();
  late Address address;
  late Contact contact;


  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmit();
      print("Form Validated");
    } else {
      print("Form Not Validated");
      return;
    }
  }

  @override
  void initState() {
    dateInput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
                    value: Provider.of<CategoryProvider>(context, listen: false).items[
                      context.watch<ExpenseProvider>().expense.category
                    ],
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
                        labelText: AppLocalizations.of(context)!.selectDate
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
                      child: Text(AppLocalizations.of(context)!.addExpense),
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
    Box<Expense> contactsBox = Hive.box<Expense>(HiveBoxes.expense);
    contactsBox.add(Provider.of<ExpenseProvider>(context, listen: false).expense);
    Navigator.of(context).pop();
  }
}