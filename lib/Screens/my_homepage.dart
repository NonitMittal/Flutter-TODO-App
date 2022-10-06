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

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
    final ToDoItem removedItem = todoItems[removedItemIndex];
    todoItems.removeAt(removedItemIndex);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(
        animation: animation,
        item: removedItem,
      ),
    );

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
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.id, (_) => false);
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getItems().then((items) {
        items!.sort((a, b) => a.data().id.compareTo(b.data().id));

        Future ft = Future(() {});
        for (var e in items) {
          ft = ft.then((data) {
            return Future.delayed(const Duration(milliseconds: 100), () {
              todoItems.add(ToDoItem(
                id: e.data().id,
                title: e.data().title,
                information: e.data().information,
                complete: e.data().complete,
              ));
              _listKey.currentState?.insertItem(todoItems.length - 1);
            });
          });
        }
      });
    });
  }

  final Animatable<Offset> _offset = Tween(
    begin: const Offset(1, 0),
    end: const Offset(0, 0),
  ).chain(CurveTween(
    curve: Curves.elasticInOut,
  ));

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
        child: AnimatedList(
          key: _listKey,
          initialItemCount: todoItems.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(
              animation: animation,
              item: todoItems[index],
              onChange: (value) {
                if (value != null) {
                  changeTodoItem(value: value, item: todoItems[index]);
                }
              },
              onDelete: () {
                deleteTodoItem(index: index, item: todoItems[index]);
              },
            );
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

  SlideTransition _buildItem({
    required ToDoItem item,
    required Animation<double> animation,
    Function(bool?)? onChange,
    Function()? onDelete,
  }) {
    return SlideTransition(
      position: animation.drive(_offset),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
          child: CheckboxListTile(
              title: Text(item.title),
              subtitle: Text(item.information),
              value: item.complete,
              onChanged: onChange,
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
                                  todoId: item.id,
                                  title: item.title,
                                  information: item.information,
                                  complete: item.complete)));
                    },
                    icon: const Icon(Icons.edit),
                    splashColor: Colors.blue,
                    tooltip: "Edit",
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    splashColor: Colors.red,
                    tooltip: "Delete",
                  )
                ],
              ))),
    );
  }
}
