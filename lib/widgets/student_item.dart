import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  final VoidCallback onSelect;

  const StudentItem({super.key, required this.student, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Card(
        color: student.gender == Genders.male ? Colors.blue : Colors.pink,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(
                student.department.icon,
                color: student.department.color,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${student.firstName} ${student.lastName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    student.grade.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
