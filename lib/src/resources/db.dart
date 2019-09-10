import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_game/src/models/high_score.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DatabaseManager {

  static final DatabaseManager db = DatabaseManager();

  Firestore firestore = Firestore.instance;
  CollectionReference get highScoresCollection => firestore.collection('high_scores');

  Future<void> saveHighScore(HighScore highScore) async {
    return highScoresCollection.document().setData(highScore.toMap);
  }

  Future<List<HighScore>> getRecentHighScores() async {
    List<DocumentSnapshot> snapshots = await highScoresCollection.orderBy('time', descending: true).limit(10).getDocuments().then((docs) => docs.documents);
    return snapshots.map((snapshot) => HighScore.fromMap(snapshot.data)).toList();
  }

  Future<List<HighScore>> getAllTimeHighScores() async {
    List<DocumentSnapshot> snapshots = await highScoresCollection.orderBy('score', descending: true).limit(10).getDocuments().then((docs) => docs.documents);
    return snapshots.map((snapshot) => HighScore.fromMap(snapshot.data)).toList();
  }
}

class SharedPrefsManager {

  static const String _USERNAME_KEY = 'username';
  static const String _HIGHSCORES_KEY = 'highscores';
  static const String _PURCHASES_KEY = 'purchases';

  static SharedPrefsManager _instance;
  static SharedPreferences _preferences;
  static Future<SharedPrefsManager> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefsManager();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  Future<bool> setUsername(String username) async {
    return _preferences.setString(_USERNAME_KEY, username);
  }

  String getUsername() {
    return _preferences.getString(_USERNAME_KEY) ?? '';
  }

  Future<bool> setScores(List<String> scores) async {
    return _preferences.setStringList(_HIGHSCORES_KEY, scores);
  }

  List<String> getScores() {
    List<String> scores = _preferences.getStringList(_HIGHSCORES_KEY) ?? [];
    return scores;
  }

  Future<bool> setPurchase(String purchaseId) async {
    List<String> purchases = _preferences.getStringList(_PURCHASES_KEY) ?? [];
    if(!purchases.contains(purchaseId)) purchases.add(purchaseId);
    return _preferences.setStringList(_PURCHASES_KEY, purchases);
  }

  List<String> getPurchases(){
    return _preferences.getStringList(_PURCHASES_KEY) ?? [];
  }

  Future<bool> clear() async {
    return _preferences.clear();
  }


}