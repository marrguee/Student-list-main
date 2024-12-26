import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Department({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

final departments = [
  Department(id: '1', name: 'Finance', color: Colors.green, icon: Icons.money),
  Department(id: '2', name: 'Law', color: Colors.blue, icon: Icons.gavel),
  Department(id: '3', name: 'IT', color: Colors.deepPurple, icon: Icons.computer),
  Department(id: '4', name: 'Medicine', color: Colors.red, icon: Icons.health_and_safety),
];
