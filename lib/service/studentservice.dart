import 'package:hive_project/model/studentrecord.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentService {
  
   Box<StudentRecord>? _studentBox;

  Future<void> openBox() async {
    _studentBox = Hive.box<StudentRecord>("student_box");
  }

  Future<void> addStudent(StudentRecord student) async {
    if (_studentBox == null) {
      await openBox();
    }
    await _studentBox!.add(student);
  }

  Future<List<StudentRecord>> getStudent() async {
    if (_studentBox == null) {
      await openBox();
    }
    return _studentBox!.values.toList();
  }

  Future<void> updateStudent(int index, StudentRecord student) async {
    if (_studentBox == null) {
      await openBox();
    }
    await _studentBox!.putAt(index, student);
  }

  Future<void> deleteStudent(int index) async {
    if (_studentBox == null) {
      await openBox();
    }
    await _studentBox!.deleteAt(index);
  }
}