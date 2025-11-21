import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_project/model/studentrecord.dart';
import 'package:hive_project/service/studentservice.dart';
import 'package:hive_project/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _agecontroller = TextEditingController();
  final TextEditingController _classscontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _imagecontroller = TextEditingController();
  final StudentService _studentService = StudentService();
  List<StudentRecord> _student = [];

  File? _selectedImage;
  
  final ImagePicker _picker = ImagePicker();

  Future<void> loadStudent() async {
    _student = await _studentService.getStudent();
    setState(() {});
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('loggin', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void initState() {
    loadStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addShowAlert();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _student.length,
        itemBuilder: (context, index) {
          final students = _student[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 11),
            child: Container(
              width: 300,
              height: 75,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 166, 166, 166),
                borderRadius: BorderRadius.circular(40),
              ),
              child: ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: FileImage(File(students.imagePath)),
                ),

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${students.name}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "class:${students.classs}",
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
                    Text("age:${students.age}", style: TextStyle(fontSize: 15)),
                    Text("${students.address}"),
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
                      onPressed: () {
                        editStudent(students, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _studentService.deleteStudent(index);
                        loadStudent();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> addShowAlert() async {
    await showDialog(
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
                  decoration: InputDecoration(hint: Text("enter address")),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : const Text("No image selected"),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
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
                await _studentService.addStudent(newStudent);
                _namecontroller.clear();
                _agecontroller.clear();
                _classscontroller.clear();
                _addresscontroller.clear();
                _imagecontroller.clear();
                Navigator.pop(context);
                loadStudent();
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
  }

  Future<void> editStudent(StudentRecord student, int index) async {
    _namecontroller.text = student.name;
    _agecontroller.text = student.age;
    _classscontroller.text = student.classs;
    _addresscontroller.text = student.address;
    await showDialog(
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
                  decoration: InputDecoration(hint: Text("enter address")),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : const Text("No image selected"),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
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
                student.name = _namecontroller.text;
                student.age = _agecontroller.text;
                student.classs = _classscontroller.text;
                student.address = _addresscontroller.text;
                _studentService.updateStudent(index, student);
                Navigator.pop(context);
                loadStudent();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(
                "update",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imagecontroller.text = pickedFile.path;
      });
    }
  }
}
