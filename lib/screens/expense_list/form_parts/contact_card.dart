import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/expense_provider.dart';

class ContactCard extends StatefulWidget {

  Contact? contact;
  ContactCard({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  final FlutterContactPicker _contactPicker = new FlutterContactPicker();
  Contact? _contact;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contact != null){
      _contact = widget.contact;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _contact == null ? 'Nincs kiválasztott névjegy' : _contact.toString(),
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text("Névjegy kiválasztása"),
                onPressed: () async {
                  Contact? contact = await _contactPicker.selectContact();
                  setState(() {
                    _contact = contact;
                    context.read<ExpenseProvider>().setContact(contact);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
