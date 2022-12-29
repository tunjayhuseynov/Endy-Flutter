import 'package:flutter/material.dart';

class Dialogs {
  static showRemoveDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Silmək istədiyinizdən əminsiniz?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              child: const Text('Ləvğ et'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text('Sil'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
