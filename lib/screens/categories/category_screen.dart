import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:targyalo/providers/category_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  Future<void> _displayTextInputDialog(BuildContext context) async{
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.addCategory),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.categoryName),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  Provider.of<CategoryProvider>(context, listen: false).add(_textFieldController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayDialog(BuildContext context) async {
    if( Provider.of<CategoryProvider>(context, listen: false).alert()){
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.warning),
              content: Text(AppLocalizations.of(context)!.warningText),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Navigator.pop(context);
                    _displayTextInputDialog(context);
                  },
                ),
              ],
            );
          });
    }else{
      _displayTextInputDialog(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: ListView.builder(
          itemCount: Provider
              .of<CategoryProvider>(context)
              .items
              .length,
          itemBuilder: (context, index) {
            String res = Provider
                .of<CategoryProvider>(context)
                .items[index];
            return Dismissible(
              background: Container(color: Colors.red),
              key: UniqueKey(),
              onDismissed: (direction) {
                Provider.of<CategoryProvider>(context, listen: false).remove(res);
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
                  title: Text(
                    res,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.addCategory,
          child: Icon(Icons.add),
          onPressed: () {
            _displayDialog(context);
          }
      ),
    );
  }
}
