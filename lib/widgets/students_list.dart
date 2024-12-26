import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsList extends StatelessWidget {
  const StudentsList({
    super.key,
    required this.students,
    required this.onRemoveStudent,
    required this.onSelectStudent,
  });

  final List<Student> students;
  final void Function(int student) onRemoveStudent;
  final void Function(int student) onSelectStudent;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(students[index].id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onRemoveStudent(index),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: InkWell(
          onTap: () => onSelectStudent(index),
          child: StudentItem(
            student: students[index],
            onSelect: () {
              onSelectStudent(index);
            },),
        ),
      ),
    );
  }
}



