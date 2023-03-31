import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage(
      {Key? key,
      required this.company,
      required this.username,
      required this.deleteTapped})
      : super(key: key);

  final String company;
  final String username;
  final Function() deleteTapped;

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
              onPressed: () {},
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
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff66ffc2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: company,
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff66ffc2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: username,
                hintStyle: const TextStyle(color: Colors.white38),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
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
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: deleteTapped,
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
                  onPressed: () {},
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
