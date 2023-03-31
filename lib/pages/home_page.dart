import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
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
  late final LocalAuthentication auth;
  late bool _isAuthenticated = false;
  late String passBackUp;

  //controllers
  final _companyController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //database
  List passwordList = [
    ['Gmail', '@gmail.com', 'pass123'],
    ['Apple', 'apple.com', 'pass234'],
    ['Gmail', '@gmail.com', 'pass123'],
    ['Gmail', '@gmail.com', 'pass123'],
    ['Apple', 'apple.com', 'pass234'],
  ];

  void copyPassword(int index) async {
    await _authenticate();
    if (_isAuthenticated) {
      await Clipboard.setData(ClipboardData(text: passwordList[index][2]))
          .then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(milliseconds: 2500),
                    dismissDirection: DismissDirection.horizontal,
                    content: Text('Password was copied to clipboard !'),
                  ),
                ),
              });
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
              passwordList.add([
                _companyController.text.trim(),
                _usernameController.text.trim(),
                _passwordController.text.trim()
              ]),
              _companyController.clear(),
              _usernameController.clear(),
              _passwordController.clear(),
              Navigator.of(context).pop(),
            };
    });
  }

  //delete Existing Credentials
  void deleteCredential(int index) {
    setState(() {
      passwordList.removeAt(index);
    });
    Navigator.of(context).pop();
  }

  //openCurrentTile
  void openCurrentTile(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangePasswordPage(
          company: passwordList[index][0],
          username: passwordList[index][1],
          deleteTapped: () => deleteCredential(index),
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

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
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
      body: ListView.builder(
        itemCount: passwordList.length,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemBuilder: (BuildContext context, int index) {
          return IdTile(
            companyName: passwordList[index][0],
            id: passwordList[index][1],
            copyTapped: () => copyPassword(index),
            listTapped: () => openCurrentTile(index),
          );
        },
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
