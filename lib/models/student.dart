import 'package:flutter/material.dart';

enum Departments { finance, law, it, medical }
enum Genders { male, female }

const departmentIcons = {
  Departments.finance: Icons.money,
  Departments.law: Icons.gavel,
  Departments.it: Icons.computer,
  Departments.medical: Icons.medication
};

class Student {
  Student({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender
  });

  final String firstName;
  final String lastName;
  final Departments department;
  final int grade;
  final Genders gender;
}