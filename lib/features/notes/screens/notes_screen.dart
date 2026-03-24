import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/add_edit_note_dialog.dart';
import '../widgets/empty_notes_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glass_effect.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditNoteDialog(
        onSave: (title, content) {
          context.read<NotesProvider>().addNote(title, content);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✨ Note created!'),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AddEditNoteDialog(
        note: note,
        onSave: (title, content) {
          context.read<NotesProvider>().updateNote(note.id, title, content);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✨ Note updated!'),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('📝 Notes'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, _) {
          return notesProvider.notes.isEmpty
              ? const EmptyNotesState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: notesProvider.notes.length,
                  itemBuilder: (context, index) {
                    final note = notesProvider.notes[index];
                    return NoteCard(
                      note: note,
                      onDelete: () {
                        notesProvider.deleteNote(note.id);
                      },
                      onEdit: () {
                        _showEditNoteDialog(context, note);
                      },
                    );
                  },
                );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryGradient1, AppColors.primaryGradient2],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradient1.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showAddNoteDialog(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.add_rounded, size: 28, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
