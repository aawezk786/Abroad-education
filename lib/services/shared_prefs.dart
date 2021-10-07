import 'package:shared_preferences/shared_preferences.dart';
class HelperMethods{

  static String sharedPreferenceCategoryList = "CATEGORYLIST";
  static String sharedPreferenceSubCategoryList = "SUBCATEGORYLIST";

  //Setter for categories
  Future<void> addItemToCategoryListSP(String item) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    temp = await getCategoryListSP();
    temp = temp.toSet().toList();
    temp.add(item);
    await _prefs.setStringList(sharedPreferenceCategoryList, temp);
  }

  Future<void> removeItemFromCategoryListSP(String item) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    temp = await getCategoryListSP();
    temp = temp.toSet().toList();
    for (int i=0 ; i<temp.length ; i++){
      if (temp[i] == item){
        temp.remove(temp[i]);
      }
    }
    for (int i=0 ; i<temp.length ; i++){
      print(temp[i]);
    }
    await _prefs.setStringList(sharedPreferenceCategoryList, temp);
  }

  //Getter for categories
  Future<List<String>> getCategoryListSP() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> temp = _prefs.getStringList(sharedPreferenceCategoryList);
    return temp == null ? [] : temp;
  }



  //Setter for sub-categories
  Future<void> addItemToSubCategoryListSP(String item) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    temp = await getSubCategoryListSP();
    temp.add(item);
    await _prefs.setStringList(sharedPreferenceSubCategoryList, temp);

  }

  Future<void> removeItemFromSubCategoryListSP(String item) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    temp = await getSubCategoryListSP();
    temp = temp.toSet().toList();
//    for (int i=0 ; i<temp.length ; i++){
//      if (temp[i] == item){
//        temp.remove(temp[i]);
//      }
//    }
    for (int i=0 ; i<temp.length ; i++){
      print(temp[i]);
    }
    await _prefs.setStringList(sharedPreferenceCategoryList, temp);
  }

  //Getter for sub-categories
  Future<List<String>> getSubCategoryListSP() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String> temp = _prefs.getStringList(sharedPreferenceSubCategoryList);
    return temp == null ? [] : temp;
  }



}