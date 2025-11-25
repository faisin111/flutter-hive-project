import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_project/model/studentrecord.dart';
import 'package:hive_flutter/hive_flutter.dart';

final studentProvider =
    StateNotifierProvider<StudentServiceNotifier, List<StudentRecord>>((ref) {
      final box = ref.watch(openBoxProvider);
      return StudentServiceNotifier(box);
    });

final openBoxProvider = Provider<Box<StudentRecord>>((ref) {
  return Hive.box<StudentRecord>("student_box");
});

class StudentServiceNotifier extends StateNotifier<List<StudentRecord>> {
  final Box<StudentRecord>? box;
  StudentServiceNotifier(this.box) : super(box!.values.toList());

  Future<void> addStudent(StudentRecord student) async {
    await box!.add(student);
    state = box!.values.toList();
  }

  Future<void> updateStudent(int index, StudentRecord student) async {
    await box!.putAt(index, student);
    state = box!.values.toList();
  }

  Future<void> deleteStudent(int index) async {
    await box!.deleteAt(index);
    state = box!.values.toList();
  }
}
