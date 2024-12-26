import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import 'students_list.dart';
import 'new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showNewStudentForm(BuildContext context, WidgetRef ref, {int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          studentIndex: index
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, int studentIndex) {
    final notifier = ref.read(studentsProvider.notifier);
    notifier.removeStudent(studentIndex);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Student data removed."),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            notifier.restoreStudent();
          },
        ),
      ),
    ).closed.then((value) {
      if (value != SnackBarClosedReason.action) {
        ref
            .read(studentsProvider.notifier)
            .removeStudentOnServer();
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final notifier = ref.watch(studentsProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notifier.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              notifier.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        notifier.clearError();
      }
    });

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
      body: () {
        if (notifier.isLoading) {
          return const Center(
            child: Text("No students found. Start adding some!"),
          );
        } else if (students == null || students.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return StudentsList(
            students: students,
            onRemoveStudent: (index) => _deleteStudent(context, ref, index),
            onSelectStudent: (index) => _showNewStudentForm(context, ref, index: index),
          );
        }
      }(),
    );
  }
}
