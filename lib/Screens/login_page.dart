import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/utilities/validation.dart';
import 'package:todo_app/Screens/my_homepage.dart';
import 'package:todo_app/Screens/sign_up_page.dart';
import 'package:todo_app/utilities/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static String id = "loginPage";

  const LoginPage({super.key});

  final String title = "Sign In";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibilty = false;

  @override
  Widget build(BuildContext context) {
    String emailAddress = "";
    String password = "";

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70.0, bottom: 20.0),
                child: Icon(
                  Icons.account_circle_sharp,
                  size: 200,
                  color: Colors.blueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          onSaved: (value) {
                            emailAddress = value!;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email ID',
                            hintText: 'username@email.com',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email id';
                            } else if (!isEmailValid(value)) {
                              return 'Please enter a valid email id';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          obscureText: !passwordVisibilty,
                          onSaved: (value) {
                            password = value!;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'your secret Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisibilty
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisibilty = !passwordVisibilty;
                                });
                              },
                              splashRadius: 20,
                              color: Colors.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (!isPasswordValid(value)) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logging In . . .'),
                                    backgroundColor: Colors.grey,
                                  ),
                                );

                                signInWithEmailAndPassword(
                                  emailAddress: emailAddress,
                                  password: password,
                                ).then((user) {
                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Invalid Email or Password'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, MyHomePage.id, (_) => false);
                                  }
                                });
                              }
                            }
                          },
                          child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.grey.shade600,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpPage.id);
                        },
                        child: const Text("Sign Up ?"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}