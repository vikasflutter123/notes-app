import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/note_model.dart';

class NotesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId;
  List<Note> _notes = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _notesSubscription;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  NotesProvider(this.userId) {
    if (userId != null) {
      _fetchNotes();
    }
  }

  void retryFetchNotes() {
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    if (userId == null) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _notesSubscription = _firestore
          .collection('notes')
          .where('user_id', isEqualTo: userId)
          .orderBy('updated_at', descending: true)
          .snapshots()
          .listen((snapshot) {
        _notes = snapshot.docs
            .map((doc) => Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        _isLoading = false;
        _hasError = false;
        _errorMessage = null;
        notifyListeners();
      }, onError: (error) {
        _isLoading = false;
        _hasError = true;
        _errorMessage = "Failed to load notes. Please try again.";
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = "Failed to load notes. Please try again.";
      notifyListeners();
    }
  }

  Future<String?> addNote(String title, String content) async {
    try {
      final now = Timestamp.now();
      await _firestore.collection('notes').add({
        'title': title,
        'content': content,
        'user_id': userId,
        'created_at': now,
        'updated_at': now,
      });
      return null;
    } catch (e) {
      return "Failed to save note. Please try again.";
    }
  }

  Future<String?> updateNote(String noteId, String title, String content) async {
    try {
      await _firestore.collection('notes').doc(noteId).update({
        'title': title,
        'content': content,
        'updated_at': Timestamp.now(),
      });
      return null;
    } catch (e) {
      return "Failed to update note. Please try again.";
    }
  }

  Future<String?> deleteNote(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
      return null;
    } catch (e) {
      return "Failed to delete note. Please try again.";
    }
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }
}