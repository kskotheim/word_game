import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_game/src/models/high_score.dart';


class DatabaseManager {

  static final DatabaseManager db = DatabaseManager();

  Firestore firestore = Firestore.instance;
  CollectionReference get highScoresCollection => firestore.collection('high_scores');

  Future<void> saveHighScore(HighScore highScore) async {
    return highScoresCollection.document().setData(highScore.toJson);
  }

  Future<List<HighScore>> getRecentHighScores() async {
    List<DocumentSnapshot> snapshots = await highScoresCollection.orderBy('time', descending: true).limit(10).getDocuments().then((docs) => docs.documents);
    return snapshots.map((snapshot) => HighScore.fromJson(snapshot.data)).toList();
  }

  Future<List<HighScore>> getAllTimeHighScores() async {
    List<DocumentSnapshot> snapshots = await highScoresCollection.orderBy('score', descending: true).limit(10).getDocuments().then((docs) => docs.documents);
    return snapshots.map((snapshot) => HighScore.fromJson(snapshot.data)).toList();
  }
}