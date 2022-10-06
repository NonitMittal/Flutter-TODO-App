import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/Screens/my_homepage.dart';
import 'package:todo_app/utilities/firebase_firestore.dart';

import '../utilities/todo_item.dart';

class UpdateItemPage extends StatefulWidget {
  static String id = "updateItemPage";

  const UpdateItemPage(
      {super.key,
      required this.todoId,
      required this.title,
      required this.information,
      required this.complete});

  final String title;
  final String information;
  final bool complete;
  final String todoId;

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> updateTodoItem({
    required String title,
    required String information,
    required bool complete,
    required String todoId,
  }) async {
    ToDoItem newData = ToDoItem(
      id: todoId,
      title: title,
      information: information,
      complete: complete,
    );

    await updateItem(
      id: todoId,
      newData: newData,
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String information = widget.information;

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
                        initialValue: title,
                        onSaved: (value) {
                          title = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Update Title',
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
                        initialValue: information,
                        onSaved: (value) {
                          information = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Information',
                          hintText: 'Update Information',
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
                                content: Text('Updating Item . . .'),
                                backgroundColor: Colors.grey,
                              ),
                            );

                            updateTodoItem(
                                    title: title,
                                    information: information,
                                    todoId: widget.todoId,
                                    complete: widget.complete)
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
                        child: const Text('Update'),
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
