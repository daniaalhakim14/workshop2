import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MessageUtils{

  
  static showMessage({required BuildContext context, required String title, required String description}){
      showCupertinoDialog(context: context, builder: (context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          CupertinoDialogAction(
            child: Text('Ok'),
            onPressed: (){
              Get.back();
            },
          ),
        ],
      );
    });
  }


}