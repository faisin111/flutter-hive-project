import 'package:flutter/material.dart';
import 'package:hive_project/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final defaultuser = "faisin";
  final dafaultpass = "8891912383";

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (defaultuser == usernameController.text &&
        dafaultpass == passwordController.text) {
      await prefs.setString('username', usernameController.text);
      await prefs.setString('password', passwordController.text);
      prefs.setBool('loggin', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ivalid username and password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 186, 186, 186),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
          "login",
        ),
        leading: Icon(color: Colors.white, Icons.draw_rounded),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 52,
            bottom: 190,
            child: Container(
              width: 310,
              height: 370,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.9),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Title(
                      color: Colors.blue,
                      child: Text(
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                        "Login Page",
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hint: Text("User Name"),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 103, 103, 103),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hint: Text("Password"),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 95, 95, 95),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        saveData();
                      },
                      child: Text(
                        style: TextStyle(color: Colors.white),
                        "Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(color: Colors.blue),
    );
  }
}
