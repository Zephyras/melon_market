import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late num lat;
  late num lon;
  late GeoFirePoint geoFirePoint;
  late DateTime createDate;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.lat,
    required this.lon,
    required this.geoFirePoint,
    required this.createDate,
    this.reference,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
    userKey = json['userKey'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude,
        (json['geoFirePoint']['geopoint']).lotitude);
    createDate = json['createDate'] == null
        ? DateTime.now().toUtc()
        : (json['createDate'] as Timestamp).toDate();
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['lat'] = lat;
    map['lon'] = lon;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createDate'] = createDate;
    return map;
  }
}
