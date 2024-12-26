import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../models/student.dart';
import 'students_list.dart';
import 'new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showNewStudentForm(BuildContext context, WidgetRef ref, {Student? existingStudent}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          onAddStudent: (student) {
            ref.read(studentsProvider.notifier).addStudent(student);
          },
          onEditStudent: (oldStudent, newStudent) {
            ref.read(studentsProvider.notifier).editStudent(oldStudent, newStudent);
          },
          existingStudent: existingStudent,
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, Student student) {
    final notifier = ref.read(studentsProvider.notifier);
    notifier.deleteStudent(student.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Student data removed."),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            notifier.restoreStudent(student);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        actions: [
          IconButton(
            onPressed: () => _showNewStudentForm(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: students.isEmpty
          ? const Center(
              child: Text("No students found. Start adding some!"),
            )
          : StudentsList(
              students: students,
              onRemoveStudent: (student) => _deleteStudent(context, ref, student),
              onSelectStudent: (student) => _showNewStudentForm(context, ref, existingStudent: student),
            ),
    );
  }
}
