import 'package:hive/hive.dart';

part 'studentrecord.g.dart';

@HiveType(typeId: 0)
class StudentRecord {
  @HiveField(0)
  String name;
  @HiveField(1)
  String age;
  @HiveField(3)
  String classs;
  @HiveField(4)
  String address;
  @HiveField(5)
  String imagePath;


  StudentRecord({
    required this.name,
    required this.age,
    required this.classs,
    required this.address,
    required this.imagePath,
  });
}





