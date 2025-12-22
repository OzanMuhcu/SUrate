import 'package:cloud_firestore/cloud_firestore.dart';

// Modellerinin bulunduğu klasör yolunu kontrol et (gerekirse düzelt)
import '../models/course.dart';
import '../models/rating.dart';
import '../models/comment.dart';
import '../models/discussion.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- COURSES (Dersler) ---

  // Tüm dersleri getirir (Realtime Stream)
  Stream<List<Course>> getCourses() {
    return _db.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Course.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Yeni ders ekler (Hoca veya Admin ekler gibi düşün)
  Future<void> addCourse(Course course) async {
    // ID'yi biz verebiliriz veya Firestore'a bırakabiliriz.
    // Senin modelinde ID zorunlu olduğu için doc().set() kullanıyoruz.
    await _db.collection('courses').doc(course.id).set(course.toMap());
  }

  // --- RATINGS (Değerlendirmeler) ---

  // Bir derse ait ratingleri getirir
  Stream<List<Rating>> getRatingsForCourse(String courseId) {
    return _db
        .collection('ratings')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Rating.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Rating ekler
  Future<void> addRating(Rating rating) async {
    // Rastgele ID oluşturup kaydediyoruz
    DocumentReference docRef = _db.collection('ratings').doc();

    // Modeldeki ID boş gelebilir, o yüzden Firestore'un ürettiği ID'yi kullanmak
    // için modeli güncellemek gerekebilir veya direkt map olarak basarız.
    // Senin toMap metodunu kullanıyoruz:
    await docRef.set(rating.toMap());
  }

  // --- COMMENTS (Yorumlar) ---

  // Bir derse ait yorumları getirir
  Stream<List<Comment>> getCommentsForCourse(String courseId) {
    return _db
        .collection('comments')
        .where('courseId', isEqualTo: courseId)
        .orderBy('createdAt', descending: true) // En yeni en üstte
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Yorum ekler
  Future<void> addComment(Comment comment) async {
    DocumentReference docRef = _db.collection('comments').doc();
    // ID yönetimini burada yapıyoruz (Firestore ID'si ile kaydediyoruz)
    // Not: Comment modelindeki 'id' alanını Firestore ID'si ile güncellemek iyi olabilir.
    // Ancak şimdilik direkt kaydediyoruz.
    await docRef.set(comment.toMap());
  }

  // Yorum siler (CRUD - Delete)
  Future<void> deleteComment(String commentId) async {
    await _db.collection('comments').doc(commentId).delete();
  }

  // --- DISCUSSIONS (Tartışmalar) ---

  // Tüm tartışmaları getirir
  Stream<List<Discussion>> getDiscussions() {
    return _db
        .collection('discussions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Discussion.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Yeni tartışma açar
  Future<void> addDiscussion(Discussion discussion) async {
    await _db.collection('discussions').add(discussion.toMap());
  }
}