import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [];
  static const String _notesKey = 'notes_list';
  late SharedPreferences _prefs;

  List<Note> get notes => _notes;
  int get notesCount => _notes.length;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadNotes();
  }

  // Save notes to local storage
  Future<void> _saveNotes() async {
    try {
      final noteList = _notes.map((note) {
        return {
          'id': note.id,
          'title': note.title,
          'content': note.content,
          'createdAt': note.createdAt.toIso8601String(),
          'updatedAt': note.updatedAt.toIso8601String(),
        };
      }).toList();
      await _prefs.setString(_notesKey, jsonEncode(noteList));
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  // Load notes from local storage
  Future<void> _loadNotes() async {
    try {
      final notesJson = _prefs.getString(_notesKey);
      if (notesJson != null) {
        final List<dynamic> decodedList = jsonDecode(notesJson);
        _notes.clear();
        for (var noteJson in decodedList) {
          _notes.add(
            Note(
              id: noteJson['id'],
              title: noteJson['title'],
              content: noteJson['content'],
              createdAt: DateTime.parse(noteJson['createdAt']),
              updatedAt: DateTime.parse(noteJson['updatedAt']),
            ),
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
  }

  // Add note
  void addNote(String title, String content) {
    if (title.isEmpty && content.isEmpty) return;

    final newNote = Note(
      id: const Uuid().v4(),
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _notes.insert(0, newNote);
    _saveNotes();
    notifyListeners();
  }

  // Update note
  void updateNote(String id, String title, String content) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        updatedAt: DateTime.now(),
      );
      _saveNotes();
      notifyListeners();
    }
  }

  // Delete note
  Note? deleteNote(String id) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      final deletedNote = _notes.removeAt(index);
      _saveNotes();
      notifyListeners();
      return deletedNote;
    }
    return null;
  }

  // Restore note
  void restoreNote(Note note) {
    _notes.insert(0, note);
    _saveNotes();
    notifyListeners();
  }

  // Get note by id
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all notes
  Future<void> clearAllNotes() async {
    _notes.clear();
    await _prefs.remove(_notesKey);
    notifyListeners();
  }
}
