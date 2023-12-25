import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommonFunction {
  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showErrorDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Center(child: Text(message!)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  showLoader(/*{required BuildContext context}*/) {
    // return showDialog(context: context, builder: (context) {
    //   return const Center(child: CircularProgressIndicator(),);
    // },);


    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showCustomSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,style: const TextStyle(
      )),
    ));
  }

  Future getImageFromGallery(
      {required var picture, required BuildContext context}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    picture = File(pickedFile!.path);
    print('IMAGE PICKED PATH FROM GALLERY :--- ${picture.imagePath}');
    Navigator.of(context).pop();
    return null;
  }

  Future getImageFromCamera(
      {required var picture, required BuildContext context}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    picture = File(pickedFile!.path);
    print('IMAGE PICKED PATH FROM CAMERA :--- ${picture.imagePath}');
    Navigator.of(context).pop();
    return null;
  }
}
