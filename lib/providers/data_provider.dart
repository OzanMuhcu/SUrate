import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Modellerini import et (Yolları kendine göre düzeltmen gerekebilir)
import 'package:surate/models/course.dart';
import 'package:surate/models/discussion.dart';
import 'package:surate/models/comment.dart';

class DataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- STATE DEĞİŞKENLERİ ---
  User? _user;
  List<Course> _courses = [];
  List<Discussion> _discussions = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Course> get courses => _courses;
  List<Discussion> get discussions => _discussions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  StreamSubscription? _courseSubscription;
  StreamSubscription? _discussionSubscription;

  // Constructor BOŞ. Veriyi updateAuth başlatacak.
  DataProvider();

  // --- AUTH ENTEGRASYONU ---
  void updateAuth(User? user) {
    _user = user;
    _courseSubscription?.cancel();
    _discussionSubscription?.cancel();

    if (_user != null) {
      _initData(); // Giriş yapıldıysa verileri çek
    } else {
      _courses = [];
      _discussions = [];
      notifyListeners();
    }
  }

  // --- REALTIME VERİ ÇEKME ---
  void _initData() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. DERSLERİ DİNLE
      _courseSubscription = _firestore.collection('courses').snapshots().listen(
            (snapshot) {
          _courses = snapshot.docs.map((doc) {
            return Course.fromFirestore(doc.data(), doc.id);
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

      // 2. TARTIŞMALARI DİNLE
      _discussionSubscription = _firestore
          .collection('discussions')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          _discussions = snapshot.docs.map((doc) {
            return Discussion.fromFirestore(doc.data(), doc.id);
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

  // ==========================================
  //          KURS PUANLAMA & YORUM (ÖNEMLİ)
  // ==========================================

  Future<void> submitCourseReview({
    required String courseId,
    required String userId,
    required String userName,
    required String commentText,
    required double userRating,
  }) async {
    final courseRef = _firestore.collection('courses').doc(courseId);
    final commentRef = courseRef.collection('comments').doc();

    // Transaction ile güvenli güncelleme (Puanlar karışmasın diye)
    await _firestore.runTransaction((transaction) async {
      final courseSnapshot = await transaction.get(courseRef);
      if (!courseSnapshot.exists) throw Exception("Course not found!");

      final data = courseSnapshot.data()!;
      final currentRating = (data['rating'] as num?)?.toDouble() ?? 0.0;
      final currentCount = (data['ratingCount'] as num?)?.toInt() ?? 0;

      // Yeni Ortalama Hesabı
      final newCount = currentCount + 1;
      final newRating = ((currentRating * currentCount) + userRating) / newCount;

      // Kursu Güncelle
      transaction.update(courseRef, {
        'rating': newRating,
        'ratingCount': newCount,
      });

      // Yorumu Ekle
      transaction.set(commentRef, {
        'text': commentText,
        'rating': userRating,
        'createdBy': userId,
        'authorName': userName,
        'courseId': courseId,
        'createdAt': FieldValue.serverTimestamp(),
        'likeCount': 0,
        'dislikeCount': 0,
        'likedBy': [],
        'dislikedBy': [],
      });
    });
  }

  // ==========================================
  //            DISCUSSION İŞLEMLERİ
  // ==========================================

  Future<void> addDiscussion(String title, String body, String courseId, String creatorName, String userId) async {
    await _firestore.collection('discussions').add({
      'title': title,
      'body': body,
      'courseId': courseId,
      'creatorName': creatorName,
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Comment>> getCommentsStream(String discussionId) {
    return _firestore
        .collection('discussions')
        .doc(discussionId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addComment(String discussionId, String text, String userId, String authorName, String courseId) async {
    await _firestore.collection('discussions').doc(discussionId).collection('comments').add({
      'text': text,
      'createdBy': userId,
      'authorName': authorName,
      'courseId': courseId,
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': 0,
      'dislikeCount': 0,
      'likedBy': [],
      'dislikedBy': [],
    });
  }

  // Discussion Yorumuna Like
  Future<void> reactToDiscussionComment({required String discussionId, required String commentId, required String userId, required bool isLike}) async {
    final commentRef = _firestore.collection('discussions').doc(discussionId).collection('comments').doc(commentId);
    await _updateCommentReaction(commentRef: commentRef, userId: userId, isLike: isLike);
  }

  // ==========================================
  //              COURSE İŞLEMLERİ
  // ==========================================

  Stream<List<Comment>> getCourseCommentsStream(String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  // Course Yorumuna Like
  Future<void> reactToCourseComment({required String courseId, required String commentId, required String userId, required bool isLike}) async {
    final commentRef = _firestore.collection('courses').doc(courseId).collection('comments').doc(commentId);
    await _updateCommentReaction(commentRef: commentRef, userId: userId, isLike: isLike);
  }

  // --- ORTAK LIKE/DISLIKE MANTIĞI ---
  Future<void> _updateCommentReaction({required DocumentReference<Map<String, dynamic>> commentRef, required String userId, required bool isLike}) async {
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(commentRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() ?? {};
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      final dislikedBy = List<String>.from(data['dislikedBy'] ?? []);
      var likeCount = (data['likeCount'] as num?)?.toInt() ?? 0;
      var dislikeCount = (data['dislikeCount'] as num?)?.toInt() ?? 0;

      if (isLike) {
        if (likedBy.contains(userId)) return;
        likedBy.add(userId);
        likeCount++;
        if (dislikedBy.remove(userId)) dislikeCount--;
      } else {
        if (dislikedBy.contains(userId)) return;
        dislikedBy.add(userId);
        dislikeCount++;
        if (likedBy.remove(userId)) likeCount--;
      }

      transaction.update(commentRef, {
        'likedBy': likedBy,
        'dislikedBy': dislikedBy,
        'likeCount': likeCount,
        'dislikeCount': dislikeCount < 0 ? 0 : dislikeCount, // Negatif olmasın
      });
    });
  }

  @override
  void dispose() {
    _courseSubscription?.cancel();
    _discussionSubscription?.cancel();
    super.dispose();
  }
}