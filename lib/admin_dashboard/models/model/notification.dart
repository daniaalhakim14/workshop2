import 'dart:convert';
import 'dart:typed_data';


class Notification {
  int? notificationID;
  String? title;
  String? type;
  String? description;
  String? image;
  String? date; 
  String? time; 
  int? adminID;

  Notification({
    this.notificationID,
    this.title,
    this.type,
    this.description,
    this.image,
    this.date,
    this.time,
    this.adminID,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
     print('Image data: ${json['image']}');
    return Notification(
      notificationID: json['notificationid'],
      title: json['title'],
      type: json['type'],
      description: json['description'],
      image: json['image'],
      date: json['date'],
      time: json['time'],
      adminID: json['adminid'],
    );
  }

  

  Map<String, dynamic> toJson() {
    return {
      'notificationid': notificationID,
      'title': title,
      'type': type,
      'description': description,
      'image': image,
      'date': date,
      'time': time,
      'adminid': adminID,
    };
  }


}
