import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/Screens/my_homepage.dart';
import 'package:todo_app/utilities/firebase_firestore.dart';

class AddItemPage extends StatefulWidget {
  static String id = "addItemPage";

  const AddItemPage({super.key});

  final String title = "Add Item";

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String title = "";
    String information = "";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 10,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        onSaved: (value) {
                          title = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter Title',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email id';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        onSaved: (value) {
                          information = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Information',
                          hintText: 'Enter Information',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 8,
                        maxLines: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Adding Item . . .'),
                                backgroundColor: Colors.grey,
                              ),
                            );

                            addItem(title: title, information: information)
                                .then(
                              (_) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  MyHomePage.id,
                                  (_) => false,
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}