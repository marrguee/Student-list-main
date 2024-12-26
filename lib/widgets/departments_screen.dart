import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../models/department.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final department = departments[index];
        final studentCount = students == null 
          ? 0 
          : students.where((s) => s.department == department).length;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(department.icon, size: 40, color: department.color),
              const SizedBox(height: 8),
              Text(
                department.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: department.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$studentCount students',
                style: TextStyle(
                  color: department.color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
