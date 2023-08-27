import 'package:flutter/material.dart';

/// 共通のViewModel
/// ログイン後の各画面のViewModelはこのクラスを継承すること
abstract class BaseModel extends ChangeNotifier {
  BaseModel() {
    init();
  }

  /// ローディングフラグ
  bool isLoading = false;

  Future<void> init() async {}

  @protected
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  @protected
  void endLoading() {
    isLoading = false;
    notifyListeners();
  }
}