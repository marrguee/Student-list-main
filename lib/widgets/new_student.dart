import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

class NewStudent extends StatefulWidget {
  const NewStudent({
    super.key,
    required this.onAddStudent,
    required this.onEditStudent,
    this.existingStudent,
  });

  final void Function(Student student) onAddStudent;
  final void Function(Student student, Student newStudent) onEditStudent;
  final Student? existingStudent;

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  Department? _selectedDepartment = departments[0];
  Genders? _selectedGender = Genders.male;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final student = widget.existingStudent;
    if (student != null) {
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

  void _submitStudentData() {
    final grade = int.tryParse(_gradeController.text);
    if (grade == null || _selectedDepartment == null || _selectedGender == null) {
      return;
    }

    final newStudent = Student(
      id: widget.existingStudent?.id ?? DateTime.now().toString(),
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      department: _selectedDepartment!,
      grade: grade,
      gender: _selectedGender!,
    );

    if (widget.existingStudent != null) {
      widget.onEditStudent(widget.existingStudent!, newStudent);
    } else {
      widget.onAddStudent(newStudent);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  }
}
