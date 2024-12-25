import 'package:flutter/material.dart';
import 'package:turbaba_danylo/models/student.dart';
import 'package:turbaba_danylo/widgets/new_student.dart';
import 'package:turbaba_danylo/widgets/students_list.dart';

class Students extends StatefulWidget {
  const Students({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StudentsState();
  }
}

class _StudentsState extends State<Students> {
  final List<Student> _registeredStudents = [
    Student(
        firstName: "John",
        lastName: "Carmack",
        department: Departments.it,
        grade: 9,
        gender: Genders.male),
    Student(
        firstName: "Judie",
        lastName: "Heal",
        department: Departments.medical,
        grade: 6,
        gender: Genders.female),
    Student(
        firstName: "Jordan",
        lastName: "Belfort",
        department: Departments.finance,
        grade: 8,
        gender: Genders.male),
    Student(
        firstName: "Jim",
        lastName: "Carrey",
        department: Departments.law,
        grade: 6,
        gender: Genders.male),
    Student(
        firstName: "Lana",
        lastName: "Stewart",
        department: Departments.it,
        grade: 7,
        gender: Genders.female),
  ];

  void _addStudent(Student student) {
    setState(() {
      _registeredStudents.add(student);
    });
  }

  void _removeStudent(Student student) {
    final studentIndex = _registeredStudents.indexOf(student);
    setState(() {
      _registeredStudents.remove(student);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Student data removed."),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredStudents.insert(studentIndex, student);
              });
            }),
      ),
    );
  }

  void _selectStudent(Student student) {
    _openNewStudentOverlay(context, student);
  }

  void _editStudent(Student student, Student newStudent) {
    final studentIndex = _registeredStudents.indexOf(student);
    setState(() {
      _registeredStudents[studentIndex] = newStudent;
    });
  }

  void _openNewStudentOverlay(BuildContext context, [Student? oldStudent]) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => NewStudent(
              onAddStudent: _addStudent,
              onEditStudent: _editStudent,
              existingStudent: oldStudent,
            ),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No students found. Start adding some!"),
    );

    if (_registeredStudents.isNotEmpty) {
      mainContent = StudentsList(
        students: _registeredStudents,
        onRemoveStudent: _removeStudent,
        onSelectStudent: _selectStudent,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        actions: [
          IconButton(
              onPressed: () => _openNewStudentOverlay(context),
              icon: const Icon(Icons.add))
        ],
      ),
      body: mainContent,
    );
  }
}
