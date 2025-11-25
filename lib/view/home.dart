import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_project/model/studentrecord.dart';
import 'package:hive_project/service/studentservice.dart';
import 'package:hive_project/view/detial.dart';
import 'package:hive_project/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('loggin', false);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _namecontroller = TextEditingController();
    final TextEditingController _agecontroller = TextEditingController();
    final TextEditingController _classscontroller = TextEditingController();
    final TextEditingController _addresscontroller = TextEditingController();
    final TextEditingController _imagecontroller = TextEditingController();
    final selected = StateProvider<File?>((ref) {
      File? _selectedImage;
      return _selectedImage;
    });

    File? imageee = ref.watch(selected);
    final ImagePicker _picker = ImagePicker();
    final students = ref.watch(studentProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Detial()),
              );
            },
            icon: Icon(Icons.details),
          ),
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Student"),
                content: Container(
                  height: 400,
                  child: Column(
                    children: [
                      TextField(
                        controller: _namecontroller,
                        decoration: InputDecoration(hint: Text("enter name")),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _agecontroller,
                        decoration: InputDecoration(hint: Text("enter age")),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _classscontroller,
                        decoration: InputDecoration(hint: Text("enter class")),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _addresscontroller,
                        decoration: InputDecoration(
                          hint: Text("enter address"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          imageee != null
                              ? Image.file(
                                  imageee!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Text("No image selected"),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final pickedFile = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              if (pickedFile != null) {
                                imageee = File(pickedFile.path);
                                _imagecontroller.text = pickedFile.path;
                              }
                            },
                            child: Icon(Icons.image),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text(
                      "cancel",
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newStudent = StudentRecord(
                        name: _namecontroller.text,
                        age: _agecontroller.text,
                        classs: _classscontroller.text,
                        address: _addresscontroller.text,
                        imagePath: _imagecontroller.text,
                      );

                      await ref
                          .read(studentProvider.notifier)
                          .addStudent(newStudent);
                      _namecontroller.clear();
                      _agecontroller.clear();
                      _classscontroller.clear();
                      _addresscontroller.clear();
                      _imagecontroller.clear();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text(
                      "add",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 11),
            child: Container(
              width: 300,
              height: 95,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 166, 166, 166),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: ListTile(
                  onTap: () {},
                  leading: CircleAvatar(
                    radius: 29,
                    backgroundImage: FileImage(File(student.imagePath)),
                  ),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        student.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "class:${student.classs}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "age:${student.age}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(student.address),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        onPressed: () async {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Edit Student"),
                                content: Container(
                                  height: 350,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _namecontroller,
                                        decoration: InputDecoration(
                                          hint: Text("enter name"),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      TextField(
                                        controller: _agecontroller,
                                        decoration: InputDecoration(
                                          hint: Text("enter age"),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      TextField(
                                        controller: _classscontroller,
                                        decoration: InputDecoration(
                                          hint: Text("enter class"),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      TextField(
                                        controller: _addresscontroller,
                                        decoration: InputDecoration(
                                          hint: Text("enter address"),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        children: [
                                          imageee != null
                                              ? Image.file(
                                                  imageee!,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Text("No image selected"),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              final pickedFile = await _picker
                                                  .pickImage(
                                                    source: ImageSource.gallery,
                                                  );

                                              if (pickedFile != null) {
                                                imageee = File(pickedFile.path);
                                                _imagecontroller.text =
                                                    pickedFile.path;
                                              }
                                            },
                                            child: Icon(Icons.image),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      "cancel",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final editstudent = await StudentRecord(
                                        name: _namecontroller.text,
                                        age: _agecontroller.text,
                                        classs: _classscontroller.text,
                                        address: _addresscontroller.text,
                                        imagePath: _imagecontroller.text,
                                      );
                                      await ref
                                          .read(studentProvider.notifier)
                                          .updateStudent(index, editstudent);
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      "update",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await ref
                              .read(studentProvider.notifier)
                              .deleteStudent(index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
