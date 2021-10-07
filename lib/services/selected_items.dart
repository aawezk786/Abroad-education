import 'package:ofy_flutter/services/shared_prefs.dart';

class SelectedItems{
  static HelperMethods _helperMethods = HelperMethods();
  static List<String> _categoryList = [];
  static List<String> _subCategoryList = [];
  static bool _isListEmpty = true;
  static fetchLists() async {
    _categoryList = await _helperMethods.getCategoryListSP();
    _subCategoryList = await _helperMethods.getSubCategoryListSP();
    _categoryList.isEmpty ? _isListEmpty = true : _isListEmpty = false;
    _categoryList = _categoryList.toSet().toList();
  }

  static List<String> get categoryList => _categoryList;
  static List<String> get subCategoryList => _subCategoryList;
  static bool get isListEmpty => _isListEmpty;
}