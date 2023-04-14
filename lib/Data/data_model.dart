import 'package:hive/hive.dart';

class PasswordDataModel {
  List passwordList = [];

  //reference to Hive Box
  final _mySafe = Hive.box('mySafe');

  //load data from the database
  void createData() {
    passwordList = [
      ['Demo.com', 'Username', '********']
    ];
  }

  //load data from the database
  void loadData() {
    passwordList = _mySafe.get('PASSWORDLIST');
  }

  //update database
  void updateDatabase() {
    _mySafe.put('PASSWORDLIST', passwordList);
  }
}
