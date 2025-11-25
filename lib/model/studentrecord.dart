import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'studentrecord.g.dart';

@immutable
@HiveType(typeId: 0)
class StudentRecord {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String age;
  @HiveField(3)
  final String classs;
  @HiveField(4)
  final String address;
  @HiveField(5)
  final String imagePath;

  const StudentRecord({
    required this.name,
    required this.age,
    required this.classs,
    required this.address,
    required this.imagePath,
  });

  StudentRecord copyWith({
    String? name,
    String? age,
    String? classs,
    String? address,
    String? imagePath,
  }) {
    return StudentRecord(
      name: name ?? this.name,
      age: age ?? this.age,
      classs: classs ?? this.classs,
      address: address ?? this.address,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
