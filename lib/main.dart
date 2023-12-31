import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_crud/students.dart';

void main() async {
  // Errors caused by Flutter Upgrade
  WidgetsFlutterBinding.ensureInitialized();

  // Open Database and store the references.
  final database = openDatabase(


      join(await getDatabasesPath(), 'emp_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id INTEGER PRIMARY KEY,name TEXT , email TEXT)',
        );
      }, version: 1);

  // Fetch/Retrieve Data
  Future<List<Employees>> EmployeesList() async {
    // Get the reference
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('employees');

    return List.generate(maps.length, (index) {
      return Employees(
          id: maps[index]['id'],
          name: maps[index]['name'],
          email: maps[index]['email']);
    });
  }

  print(await EmployeesList());

  //Update Employees Data
  Future<void> updateEmployees(Employees employees) async {
    final db = await database;

    await db.update(
      'employees',
      employees.toMap(),
      where: 'id =?',
      whereArgs: [employees.id],
    );
  }



  // Insert Data
  Future<void> insertEmployee(Employees employees) async {
    // Get a reference to the database
    final db = await database;

    // 'conflictAlgorithm - To use incase the same employee is inserted twice , TO replace any previous data'
    await db.insert('employees', employees.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  var venkatesh =
  Employees(id: 01, name: 'Venkatesh', email: 'venkatesh@gmail.com');
  var nagaharish =
  Employees(id: 02, name: 'nagaharish', email: 'nagaharish@gmail.com');
  var manoj =
  Employees(id: 03, name: 'manojprabhakar', email: 'manojptn16@gmail.com');
  var jitendra =
  Employees(id: 04, name: 'jitendra', email: 'jitendra12@gmail.com');
  var ruchita =
  Employees(id: 05, name: 'ruchitha', email: 'ruchitha@gmail.com');

  manoj = Employees(id: manoj.id + 8, name: manoj.name, email: manoj.email);

  await updateEmployees(manoj);

  await insertEmployee(venkatesh);
  await insertEmployee(nagaharish);
  await insertEmployee(manoj);
  await insertEmployee(jitendra);
  await insertEmployee(ruchita);
}