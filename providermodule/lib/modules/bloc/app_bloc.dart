import 'package:flutter/cupertino.dart';
import 'package:providermodule/providermodule.dart';

class AppBloc extends ChangeNotifier {
  String _errorMsg, _successMsg, _selectedCategoryId, _selectedExtraId;
  List _categories = [],
      _dish = [],
      _extras = [],
      _packages = [],
      _dishDuration = [],
      _pendingOrders = [],
      _acceptedOrders = [],
      _rejectedOrders = [],
      _readyOrders = [],
      _inTransitOrders = [],
      _deliveredOrders = [],
      _deliveryDistricts=[],
      _options = [],
      _extraItems = [],
      _meals = [],
      _countries = [],
      _states = [],
      _districts = [],
      _selectedMeals = [],
      _selectedCategory = [],
      _selectedExtra = [],
      _selectedNewExtras = [];
  var _mapSuccess,
      _kitchenDetails = PublicData.tempKitchen,
      _selectedCategoryIndex,
      _optionId,
      _country,
      _orders,
      _state,
      _district={};
  bool sent,
      upload,
      exits,
      _hasOrders = false,
      _hasPendingOrder = false,
      _hasAcceptedOrder = false,
      _hasRejectedOrder = false,
      _hasReadyOrder = false,
      _hasIntransitOrders = false,
      _hasDeliveredOrder = false,
      _hasCategory = false,
      _hasDish = false,
      _hasExtras = false,
      _hasPackages = false,
      _hasMeals = false,
      _firstSyncedKitchen = false;

  get errorMsg => _errorMsg;
  get successMsg => _successMsg;
  get kitchenDetails => _kitchenDetails;
  get mapSuccess => _mapSuccess;
  get orders => _orders;
  get categories => _categories;
  get extras => _extras;
   get packages => _packages;
  get dish => _dish;
  get hasExtras => _hasExtras;
   get hasPackages => _hasPackages;
  get hasDish => _hasDish;
  get hasPendingOrder => _hasPendingOrder;
  get hasCategory => _hasCategory;
  get hasMeals => _hasMeals;
  get meals => _meals;
  get selectedCategory => _selectedCategory;
  get selectedCategoryId => _selectedCategoryId;
  get selectedExtra => _selectedExtra;
  get selectedMeals => _selectedMeals;
  get selectedExtraId => _selectedExtraId;
  get selectedCategoryIndex => _selectedCategoryIndex;
  get selectedNewExtras => _selectedNewExtras;
  get options => _options;
  get optionItems => _extraItems;
  get optionId => _optionId;
  get districts => _districts;
  get extraItems => _extraItems;
  get states => _states;
  get countries => _countries;
  get state => _state;
  get firstSyncedKitchen => _firstSyncedKitchen;
  get hasDeliveredOrder => _hasDeliveredOrder;
  get hasReadyOrder => _hasReadyOrder;
  get hasRejectedOrder => _hasRejectedOrder;
  get hasAcceptedOrder => _hasAcceptedOrder;
  get hasOrders => _hasOrders;
  get deliveredOrders => _deliveredOrders;
  get readyOrders => _readyOrders;
  get rejectedOrders => _rejectedOrders;
  get acceptedOrders => _acceptedOrders;
  get pendingOrders => _pendingOrders;
  get inTransitOrders => _inTransitOrders;
  get deliveryDistricts=>_deliveryDistricts;
  get hasIntransitOrders => _hasIntransitOrders;
  get dishDuration => _dishDuration;
  
  set dishDuration(value) {
    _dishDuration = value;
    notifyListeners();
  }
  set deliveryDistricts(value) {
    _deliveryDistricts = value;
    notifyListeners();
  }

   set hasOrders(value) {
    _hasOrders = value;
    notifyListeners();
  }
   set inTransitOrders(value) {
    _inTransitOrders = value;
    notifyListeners();
  }
  set hasIntransitOrders(value) {
    _hasIntransitOrders = value;
    notifyListeners();
  }
  set pendingOrders(value) {
    _pendingOrders = value;
    notifyListeners();
  }

  set firstSyncedKitchen(value) {
    _firstSyncedKitchen = value;
    notifyListeners();
  }

  get district => _district;

  get country => _country;

  set selectedMeals(value) {
    _selectedMeals = value;
    notifyListeners();
  }

  set country(value) {
    _country = value;
    notifyListeners();
  }

  set extraItems(value) {
    _extraItems = value;
    notifyListeners();
  }

  set optionId(value) {
    _optionId = value;
    notifyListeners();
  }

  set optionItems(value) {
    _extraItems = value;
    notifyListeners();
  }

  set options(value) {
    _options = value;
    notifyListeners();
  }

  set selectedNewExtras(value) {
    _selectedNewExtras = value;
    notifyListeners();
  }

  set selectedCategoryIndex(value) {
    _selectedCategoryIndex = value;
    notifyListeners();
  }

  set selectedExtraId(value) {
    _selectedExtraId = value;
    notifyListeners();
  }

  set selectedCategoryId(value) {
    _selectedCategoryId = value;
    notifyListeners();
  }

  set selectedCategory(value) {
    _selectedCategory = value;
    notifyListeners();
  }

  set meals(value) {
    _meals = value;
    notifyListeners();
  }

  set categories(value) {
    _categories = value;
    notifyListeners();
  }

  set extras(value) {
    _extras = value;
    notifyListeners();
  }

  set packages(value) {
    _packages = value;
    notifyListeners();
  }

  set dish(value) {
    _dish = value;
    notifyListeners();
  }

  set mapSuccess(value) {
    _mapSuccess = value;
    notifyListeners();
  }

  set errorMsg(value) {
    _errorMsg = value;
    notifyListeners();
  }

  set orders(value) {
    _orders = value;
    notifyListeners();
  }

  set kitchenDetails(value) {
    _kitchenDetails = value;
    notifyListeners();
  }

  set hasExtras(value) {
    _hasExtras = value;
    notifyListeners();
  }
set hasPackages(value) {
    _hasPackages = value;
    notifyListeners();
  }
  set hasDish(value) {
    _hasDish = value;
    notifyListeners();
  }

  set hasCategory(value) {
    _hasCategory = value;
    notifyListeners();
  }

  set hasPendingOrder(value) {
    _hasPendingOrder = value;
    notifyListeners();
  }

  set hasMeals(value) {
    _hasMeals = value;
    notifyListeners();
  }

  set selectedExtra(value) {
    _selectedExtra = value;
    notifyListeners();
  }

  set countries(value) {
    _countries = value;
    notifyListeners();
  }

  set states(value) {
    _states = value;
    notifyListeners();
  }

  set districts(value) {
    _districts = value;
    notifyListeners();
  }

  set state(value) {
    _state = value;
    notifyListeners();
  }

  set district(value) {
    _district = value;
    notifyListeners();
  }

  set hasDeliveredOrder(value) {
    _hasDeliveredOrder = value;
    notifyListeners();
  }

  set hasReadyOrder(value) {
    _hasReadyOrder = value;
    notifyListeners();
  }

  set hasRejectedOrder(value) {
    _hasRejectedOrder = value;
    notifyListeners();
  }

  set hasAcceptedOrder(value) {
    _hasAcceptedOrder = value;
    notifyListeners();
  }

  set deliveredOrders(value) {
    _deliveredOrders = value;
    notifyListeners();
  }

  set readyOrders(value) {
    _readyOrders = value;
    notifyListeners();
  }

  set rejectedOrders(value) {
    _rejectedOrders = value;
    notifyListeners();
  }

  set acceptedOrders(value) {
    _acceptedOrders = value;
    notifyListeners();
  }
}
