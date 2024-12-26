import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  void addStudent(Student student) => state = [...state, student];

  void updateStudent(String id, Student updatedStudent) {
    state = state.map((student) => student.id == id ? updatedStudent : student).toList();
  }

  void editStudent(Student oldStudent, Student newStudent) {
    updateStudent(oldStudent.id, newStudent);
  }

  void deleteStudent(String id) {
    state = state.where((student) => student.id != id).toList();
  }

  void restoreStudent(Student student) {
    state = [...state, student];
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) => StudentsNotifier(),
);
