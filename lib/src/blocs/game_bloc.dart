import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/src/resources/db.dart';

class GameBloc implements BlocBase{

  int _finalScore = 0;
  int get finalScore => _finalScore;

  bool _soundOn = true;
  bool get soundOn => _soundOn;

  //Stream to handle the game's status (which page to render): output of Bloc
  StreamController<GameStatus> _gameStatusController = StreamController<GameStatus>();
  StreamSink<GameStatus> get _gameStatusSink => _gameStatusController.sink;
  Stream<GameStatus> get gameStatus => _gameStatusController.stream;

  //Stream to handle button events: input to Bloc
  StreamController _gameButtonController = StreamController();
  StreamSink get gameButton =>_gameButtonController.sink;

  //Stream to handle sound events
  BehaviorSubject<bool> _soundController = BehaviorSubject<bool>();
  StreamSink<bool> get soundButton => _soundController.sink;
  Stream<bool> get soundStatus => _soundController.stream;

  //in app purchase info
  StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  SharedPrefsManager _preferences;
  List<ProductDetails> _productDetails;

  //Stream to relay purchases as they are updated
  BehaviorSubject<List<String>> _purchaseDetailsController = BehaviorSubject<List<String>>();
  StreamSink<List<String>> get purchaseDetailsSink => _purchaseDetailsController.sink;
  Stream<List<String>> get purchaseDetailsStream => _purchaseDetailsController.stream;

  //Debug error Stream
  BehaviorSubject<String> _debugErrorController = BehaviorSubject<String>();
  StreamSink<String> get debugError => _debugErrorController.sink;
  Stream<String> get debugErrorString => _debugErrorController.stream;

  GameBloc(){

    _connectToStore();

    _gameButtonController.stream.listen(_mapGameEventToState);
    gameButton.add(GoHomeEvent());
    soundButton.add(true);
    soundStatus.listen(_mapSoundEventToState);
  }

  Future<void> _connectToStore() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (!available) {
      debugError.add('store unavailable');
      _getPurchases();
    } else {
       //load purchases and initialize in-app purchase stream
      _getPurchases().then((_) => _listenForPurchaseUpdates());
      _loadProductInfo();
    }
  }

  Future<void> _getPurchases() async {
    _preferences = await SharedPrefsManager.getInstance();
    //add updated lsit of purchases to purchase stream
    purchaseDetailsSink.add(_preferences.getPurchases());
  }
  void _listenForPurchaseUpdates(){
    _purchaseSubscription = InAppPurchaseConnection.instance.purchaseUpdatedStream.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
  }
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    if(_preferences == null) _preferences = await SharedPrefsManager.getInstance();
    List<String> ids = [];
    purchases.forEach((purchase){
      //save purchase to shared prefs
      _preferences.setPurchase(purchase.productID);
      ids.add(purchase.productID);
    });
    //add updated list of purchases to purchase stream
    purchaseDetailsSink.add(ids);
  }
  Future<void> queryPastPurchases() async {
    QueryPurchaseDetailsResponse details = await InAppPurchaseConnection.instance.queryPastPurchases();
    List<String> ids = [];
    details.pastPurchases.forEach((PurchaseDetails purchaseDetails){
      ids.add(purchaseDetails.productID);
    });
    purchaseDetailsSink.add(ids);
  }

  Future<void> _loadProductInfo() async {
    const Set<String> _kIds = {'3_lives_mode'};
    final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugError.add('Not found these ids: ${response.notFoundIDs}' + (response.error != null ? ', error: ${response.error.message}' : ''));
    }
    _productDetails = response.productDetails;
    _productDetails.forEach((product){
      debugError.add('FOUND PRODUCT INFO: ${product.title}: ${product.price}, ${product.description}');
    });
    return;
  }

  void _mapGameEventToState(event){
    if(event is PlayGameEvent){
      _gameStatusSink.add(GameStatus.playing);
    }
    if (event is GoHomeEvent){
      _gameStatusSink.add(GameStatus.home);
    }
    if(event is GameOverEvent){
      _finalScore = event.score;
      _gameStatusSink.add(GameStatus.ending);
    }
    if(event is SettingsEvent){
      _gameStatusSink.add(GameStatus.settings);
    }
    if(event is HighScoresEvent){
      _gameStatusSink.add(GameStatus.highScores);
    }
    if(event is NameButtonEvent){
      _gameStatusSink.add(GameStatus.naming);
    }
  }

  void _mapSoundEventToState(bool event){
    _soundOn = event;
  }

  void dispose(){
    _gameStatusController.close();
    _gameButtonController.close();
    _soundController.close();
    _purchaseSubscription.cancel();
    _purchaseDetailsController.close();

    _debugErrorController.close();
  }

  Future<bool> makePurchase(String itemId) async {
    ProductDetails details = _productDetails.where((product) => product.id == itemId).toList()[0];
    return InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: details));
  }
}


//Input events and output types for this bloc
abstract class GameEvent{}

class PlayGameEvent extends GameEvent{}

class SettingsEvent extends GameEvent{}

class GoHomeEvent extends GameEvent{}

class GameOverEvent extends GameEvent{
  final int score;
  GameOverEvent({this.score}) : assert(score != 0);
}

class HighScoresEvent extends GameEvent{}

class NameButtonEvent extends GameEvent{}

enum GameStatus { home, settings, playing, ending, highScores, naming }
