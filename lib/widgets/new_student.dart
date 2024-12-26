import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  Department? _selectedDepartment = departments[0];
  Genders? _selectedGender = Genders.male;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider)![widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _gradeController.text = student.grade.toString();
      _selectedGender = student.gender;
      _selectedDepartment = student.department;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _submitStudentData() async {
     final grade = int.tryParse(_gradeController.text);

    if (grade == null || _selectedDepartment == null || _selectedGender == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter valid data for all fields.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

    if (widget.studentIndex != null) {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            grade,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            grade,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop(null); 
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(studentsProvider.notifier);

    Widget mainScreen = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _firstNameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("First Name")),
          ),
          TextField(
            controller: _lastNameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Last Name")),
          ),
          TextField(
            controller: _gradeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(label: Text("Grade")),
          ),
          DropdownButton<Genders>(
            value: _selectedGender,
            items: Genders.values
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender == Genders.male ? "Male" : "Female"),
                    ))
                .toList(),
            onChanged: (value) => setState(() {
              _selectedGender = value;
            }),
          ),
          DropdownButton<Department>(
            value: _selectedDepartment,
            items: departments
                .map((department) => DropdownMenuItem(
                      value: department,
                      child: Row(
                        children: [
                          Icon(department.icon, size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(department.name),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(() {
              _selectedDepartment = value;
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _submitStudentData,
                child: const Text("Save"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
    if(notifier.isLoading) {
      mainScreen = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return mainScreen;
  }
}
