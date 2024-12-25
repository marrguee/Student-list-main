import 'package:flutter/material.dart';
import 'package:turbaba_danylo/models/student.dart';

class NewStudent extends StatefulWidget {
  const NewStudent(
      {super.key,
      required this.onAddStudent,
      required this.onEditStudent,
      this.existingStudent});

  final void Function(Student student) onAddStudent;
  final void Function(Student student, Student newStudent) onEditStudent;
  final Student? existingStudent;

  @override
  State<StatefulWidget> createState() {
    return _NewStudentState();
  }
}

class _NewStudentState extends State<NewStudent> {
  Departments _selectedDepartment = Departments.it;
  Genders _selectedGender = Genders.male;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var student = widget.existingStudent;
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
    var oldStudent = widget.existingStudent;
    var newStudent = Student(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        department: _selectedDepartment,
        grade: int.tryParse(_gradeController.text)!,
        gender: _selectedGender);

    if (oldStudent != null) {
      widget.onEditStudent(oldStudent, newStudent);
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
            decoration: const InputDecoration(label: Text("First name")),
          ),
          TextField(
            controller: _lastNameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Last name")),
          ),
          TextField(
            controller: _gradeController,
            decoration: const InputDecoration(label: Text("Grade")),
          ),
          DropdownButton(
            value: _selectedGender,
            items: Genders.values
                .map((gender) => DropdownMenuItem(
                    value: gender, child: Text(gender.name.toUpperCase())))
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          DropdownButton(
            value: _selectedDepartment,
            items: Departments.values
                .map((department) => DropdownMenuItem(
                    value: department,
                    child: Text(department.name.toUpperCase())))
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedDepartment = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _submitStudentData();
                },
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
