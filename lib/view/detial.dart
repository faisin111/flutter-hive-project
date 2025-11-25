import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive_project/service/studentservice.dart';


class Detial extends ConsumerWidget {
  const Detial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentProvider);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final studentss = students[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Container(
              width: 100,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadiusDirectional.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 39,
                    backgroundImage: FileImage(File(studentss.imagePath)),
                  ),
                  Text(
                    studentss.name,
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "class:${studentss.classs}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "age${studentss.age}",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  Text('address:${studentss.address}',style: TextStyle(fontSize: 17),)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
