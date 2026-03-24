import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _filterType = 'All'; // All, Completed, Pending
  static const String _tasksKey = 'tasks_list';
  late SharedPreferences _prefs;

  // Getters
  List<Task> get tasks {
    if (_filterType == 'Completed') {
      return _tasks.where((task) => task.isCompleted).toList();
    } else if (_filterType == 'Pending') {
      return _tasks.where((task) => !task.isCompleted).toList();
    }
    return _tasks;
  }

  List<Task> get allTasks => _tasks;
  String get filterType => _filterType;

  int get completedCount => _tasks.where((task) => task.isCompleted).length;
  int get totalCount => _tasks.length;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadTasks();
  }

  // Save tasks to local storage
  Future<void> _saveTasks() async {
    try {
      final taskList = _tasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'isCompleted': task.isCompleted,
          'createdAt': task.createdAt.toIso8601String(),
          'dueDate': task.dueDate?.toIso8601String(),
        };
      }).toList();
      await _prefs.setString(_tasksKey, jsonEncode(taskList));
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  // Load tasks from local storage
  Future<void> _loadTasks() async {
    try {
      final tasksJson = _prefs.getString(_tasksKey);
      if (tasksJson != null) {
        final List<dynamic> decodedList = jsonDecode(tasksJson);
        _tasks.clear();
        for (var taskJson in decodedList) {
          _tasks.add(
            Task(
              id: taskJson['id'],
              title: taskJson['title'],
              description: taskJson['description'] ?? '',
              isCompleted: taskJson['isCompleted'] ?? false,
              createdAt: DateTime.parse(taskJson['createdAt']),
              dueDate: taskJson['dueDate'] != null
                  ? DateTime.parse(taskJson['dueDate'])
                  : null,
            ),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    }
  }

  // Add task
  void addTask(String title, {String description = '', DateTime? dueDate}) {
    if (title.isEmpty) return;

    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );

    _tasks.add(newTask);
    _saveTasks();
    notifyListeners();
  }

  // Update task
  void updateTask(
    String id, {
    required String title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        title: title,
        description: description ?? _tasks[index].description,
        dueDate: dueDate ?? _tasks[index].dueDate,
        isCompleted: isCompleted ?? _tasks[index].isCompleted,
      );
      _saveTasks();
      notifyListeners();
    }
  }

  // Toggle task completion
  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      _saveTasks();
      notifyListeners();
    }
  }

  // Delete task
  Task? deleteTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final deletedTask = _tasks.removeAt(index);
      _saveTasks();
      notifyListeners();
      return deletedTask;
    }
    return null;
  }

  // Restore deleted task
  void restoreTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  // Set filter
  void setFilter(String filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    _tasks.clear();
    await _prefs.remove(_tasksKey);
    notifyListeners();
  }

  // Get task by id
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}
