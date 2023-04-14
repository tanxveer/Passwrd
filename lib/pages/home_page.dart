import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/Data/data_model.dart';
import 'package:password_manager/pages/change_password.dart';

import '../components/dialog_box.dart';
import '../components/id_tile.dart';
import 'new_password.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // reference to Hive
  final _mySafe = Hive.box('mySafe');

  //instance of Data Model
  PasswordDataModel db = PasswordDataModel();

  @override
  void initState() {
    if (_mySafe.get('PASSWORDLIST') == null) {
      db.createData();
    } else {
      db.loadData();
    }
    super.initState();
    auth = LocalAuthentication();
  }

  late final LocalAuthentication auth;
  late bool _isAuthenticated = false;
  late String passBackUp;

  //controllers
  final _companyController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //copy Password to clipboard
  void copyPassword(int index) async {
    await _authenticate();
    if (_isAuthenticated) {
      await Clipboard.setData(ClipboardData(text: db.passwordList[index][2]))
          .then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(milliseconds: 2500),
                    dismissDirection: DismissDirection.horizontal,
                    content: Text('Password was copied to clipboard !'),
                  ),
                ),
              });
      _isAuthenticated = false;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2500),
          dismissDirection: DismissDirection.horizontal,
          content: Text('Please authenticate yourself first !'),
        ),
      );
    }
  }

  //save New Credentials
  void saveNew() {
    setState(() {
      _companyController.text.trim() == '' ||
              _usernameController.text.trim() == '' ||
              _passwordController.text.trim() == ''
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fill all required fields.'),
              ),
            )
          : {
              db.passwordList.add([
                _companyController.text.trim(),
                _usernameController.text.trim(),
                _passwordController.text.trim()
              ]),
              db.updateDatabase(),
              _companyController.clear(),
              _usernameController.clear(),
              _passwordController.clear(),
              Navigator.of(context).pop(),
            };
    });
  }

  //delete Existing Credentials
  void deleteCredential(int index) async {
    await _authenticate();
    if (_isAuthenticated) {
      setState(() {
        db.passwordList.removeAt(index);
      });
      db.updateDatabase();
      if (!mounted) return;
      Navigator.of(context).pop();
      _isAuthenticated = false;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2500),
          dismissDirection: DismissDirection.horizontal,
          content: Text('Please authenticate yourself first !'),
        ),
      );
    }
  }

  //openCurrentTile
  void openCurrentTile(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangePasswordPage(
          company: db.passwordList[index][0],
          username: db.passwordList[index][1],
          onSave: () => changeExistingCredential(index),
          deleteTapped: () => deleteCredential(index),
          generatePassword: () => createNewPassword(),
          companyController: _companyController,
          usernameController: _usernameController,
          passwordController: _passwordController,
        ),
      ),
    );
  }

  //create New Password
  void createNewPassword() {
    passBackUp = _passwordController.text;
    _passwordController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _passwordController,
            onCancel: () {
              _passwordController.text = passBackUp;
              Navigator.of(context).pop();
            },
          );
        });
  }

  //change Existing Credentials
  void changeExistingCredential(int index) async {
    await _authenticate();
    if (_isAuthenticated) {
      setState(() {
        if (_companyController.text.trim().isNotEmpty) {
          db.passwordList[index][0] = _companyController.text.trim();
        }
        if (_usernameController.text.trim().isNotEmpty) {
          db.passwordList[index][1] = _usernameController.text.trim();
        }
        if (_passwordController.text.trim().isNotEmpty) {
          db.passwordList[index][2] = _passwordController.text.trim();
        }
      });
      db.updateDatabase();
      //clear textFields
      _companyController.clear();
      _usernameController.clear();
      _passwordController.clear();
      //pop the page
      if (!mounted) return;
      Navigator.of(context).pop();
      _isAuthenticated = false;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2500),
          dismissDirection: DismissDirection.horizontal,
          content: Text('Please authenticate yourself first !'),
        ),
      );
    }
    //update database
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Passwords.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NewPasswordPage(
              onSave: saveNew,
              companyController: _companyController,
              usernameController: _usernameController,
              passwordController: _passwordController,
              generatePass: () {
                createNewPassword();
              },
            ),
          ),
        ),
        backgroundColor: const Color(0xff66ffc2),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: db.passwordList.isNotEmpty
          ? ListView.builder(
              itemCount: db.passwordList.length,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemBuilder: (BuildContext context, int index) {
                return IdTile(
                  companyName: db.passwordList[index][0],
                  id: db.passwordList[index][1],
                  copyTapped: () => copyPassword(index),
                  listTapped: () => openCurrentTile(index),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No account here',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 20),
                    ),
                  ),
                  Text(
                    'Use the + icon to add one',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Authenticate yourself first !',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      setState(() {
        _isAuthenticated = authenticated;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
