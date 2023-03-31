import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage(
      {Key? key,
      required this.company,
      required this.username,
      required this.deleteTapped, required this.generatePassword, required this.companyController, required this.usernameController, required this.passwordController, required this.onSave})
      : super(key: key);

  final String company;
  final String username;
  final VoidCallback onSave;
  final VoidCallback deleteTapped;
  final VoidCallback generatePassword;
  final TextEditingController companyController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  late bool hiddenPassword;

  @override
  void initState() {
    super.initState();
    hiddenPassword = true;
  }

  @override
  void dispose() {
    widget.companyController.clear();
    widget.usernameController.clear();
    widget.passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Change credentials.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: widget.onSave,
              icon: const Icon(
                Icons.check_circle_outline,
                color: Color(0xff66ffc2),
              ))
        ],
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: TextField(
              controller: widget.companyController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff66ffc2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: widget.company,
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: TextField(
              controller: widget.usernameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff66ffc2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: widget.username,
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: TextField(
              controller: widget.passwordController,
              obscureText: hiddenPassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      hiddenPassword = !hiddenPassword;
                    }),
                    icon: hiddenPassword
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff66ffc2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: widget.deleteTapped,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(171, 30),
                    backgroundColor: const Color(0xff66ffc2),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Delete Password.'),
                ),
                OutlinedButton(
                  onPressed: widget.generatePassword,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff66ffc2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Generate a Password.',
                    style: TextStyle(color: Color(0xff66ffc2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
