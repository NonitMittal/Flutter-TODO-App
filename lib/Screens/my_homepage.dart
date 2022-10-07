import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/Screens/add_item_page.dart';
import 'package:todo_app/Screens/login_page.dart';
import 'package:todo_app/Screens/update_item_page.dart';
import 'package:todo_app/utilities/firebase_auth.dart';
import 'package:todo_app/utilities/firebase_firestore.dart';
import 'package:todo_app/utilities/todo_item.dart';

class MyHomePage extends StatefulWidget {
  static String id = "homePage";

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? loginedUser;
  List<ToDoItem> todoItems = [];

  Future<void> changeTodoItem({
    required bool value,
    required ToDoItem item,
  }) async {
    ToDoItem newData = ToDoItem(
      id: item.id,
      title: item.title,
      information: item.information,
      complete: !item.complete,
    );

    todoItems[todoItems.indexWhere((e) => e.id == item.id)] = newData;

    await updateItem(
      id: item.id,
      newData: newData,
    );
  }

  Future<void> deleteTodoItem(
      {required int index, required ToDoItem item}) async {
    final int removedItemIndex = todoItems.indexWhere((e) => e.id == item.id);
    todoItems.removeAt(removedItemIndex);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Deleted'),
        backgroundColor: Colors.blueGrey,
      ),
    );

    await deleteItem(
      id: item.id,
    );
  }

  @override
  void initState() {
    super.initState();

    getLoginedUser().then(
      (value) {
        if (value != null) {
          loginedUser = value;

          getItems().then((items) {
            items!.sort((a, b) => a.data().id.compareTo(b.data().id));

            for (var e in items) {
              todoItems.add(ToDoItem(
                id: e.data().id,
                title: e.data().title,
                information: e.data().information,
                complete: e.data().complete,
              ));
            }
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.id, (_) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        loginedUser = user;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: "Logout",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logging Out . . .'),
                  backgroundColor: Colors.grey,
                ),
              );

              logoutUser();

              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (_) => false);
            },
          )
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: todoItems.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
                child: CheckboxListTile(
                    title: Text(todoItems[index].title),
                    subtitle: Text(todoItems[index].information),
                    value: todoItems[index].complete,
                    onChanged: (value) {
                      if (value != null) {
                        changeTodoItem(value: value, item: todoItems[index]);
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: Wrap(
                      spacing: 7, // space between two icons
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateItemPage(
                                        todoId: todoItems[index].id,
                                        title: todoItems[index].title,
                                        information:
                                            todoItems[index].information,
                                        complete: todoItems[index].complete)));
                          },
                          icon: const Icon(Icons.edit),
                          splashColor: Colors.blue,
                          tooltip: "Edit",
                        ),
                        IconButton(
                          onPressed: () {
                            deleteTodoItem(
                                index: index, item: todoItems[index]);
                          },
                          icon: const Icon(Icons.delete),
                          splashColor: Colors.red,
                          tooltip: "Delete",
                        )
                      ],
                    )));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddItemPage.id);
        },
        tooltip: "Add Item",
        elevation: 10,
        child: const Icon(Icons.add),
      ),
    );
  }
}
