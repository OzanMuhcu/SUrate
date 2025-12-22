import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- MODELLER ---
// Eğer proje isminiz 'surate' değilse buraları değiştirin
import 'package:surate/models/course.dart';
import 'package:surate/models/discussion.dart';
import 'package:surate/models/comment.dart';

class DataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- STATE DEĞİŞKENLERİ ---
  List<Course> _courses = [];
  List<Discussion> _discussions = [];

  bool _isLoading = false;
  String? _errorMessage;

  // --- GETTER'LAR ---
  List<Course> get courses => _courses;
  List<Discussion> get discussions => _discussions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  StreamSubscription? _courseSubscription;
  StreamSubscription? _discussionSubscription;

  DataProvider() {
    _initData();
  }

  void _initData() {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. COURSES DİNLEME
      _courseSubscription = _firestore.collection('courses').snapshots().listen(
            (snapshot) {
          _courses = snapshot.docs.map((doc) {
            final data = doc.data();
            return Course.fromFirestore(data, doc.id);
          }).toList();

          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = "Error fetching courses: $error";
          _isLoading = false;
          notifyListeners();
        },
      );

      // 2. DISCUSSIONS DİNLEME
      _discussionSubscription = _firestore
          .collection('discussions')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          _discussions = snapshot.docs.map((doc) {
            final data = doc.data();
            return Discussion.fromFirestore(data, doc.id);
          }).toList();

          notifyListeners();
        },
        onError: (error) {
          debugPrint("Discussion Error: $error");
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- DISCUSSION EKLEME ---
  Future<void> addDiscussion(String title, String body, String courseId, String creatorName, String userId) async {
    try {
      await _firestore.collection('discussions').add({
        'title': title,
        'body': body,
        'courseId': courseId,
        'creatorName': creatorName,
        'createdBy': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _errorMessage = "Failed to add discussion: $e";
      notifyListeners();
      rethrow;
    }
  }

  // --- YORUMLARI DİNLEME (Stream) ---
  Stream<List<Comment>> getCommentsStream(String discussionId) {
    return _firestore
        .collection('discussions')
        .doc(discussionId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // Snapshot içindeki her dökümanı Comment objesine çeviriyoruz
      return snapshot.docs.map((doc) {
        // Burada 'Object?' tipini 'Map<String, dynamic>' olarak zorluyoruz
        final data = doc.data();
        return Comment.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  // --- YORUM EKLEME ---
  Future<void> addComment(String discussionId, String text, String userId, String authorName, String courseId) async {
    try {
      // DİKKAT: Path yapısı 'discussions/{discussionId}/comments' olmalı
      await _firestore
          .collection('discussions')
          .doc(discussionId)
          .collection('comments')
          .add({
        'text': text,
        'createdBy': userId,
        'authorName': authorName,
        'courseId': courseId,
        'createdAt': FieldValue.serverTimestamp(), // Tarih otomatik atanır
        'likeCount': 0,
        'dislikeCount': 0,
      });
      // notifyListeners() GEREKMEZ çünkü Stream kullanıyoruz,
      // Firestore değişince UI otomatik güncellenecek.
    } catch (e) {
      print("Error adding comment: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _courseSubscription?.cancel();
    _discussionSubscription?.cancel();
    super.dispose();
  }
}