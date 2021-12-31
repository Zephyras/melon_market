import 'package:dio/dio.dart';
import 'package:melon_market/constants/keys.dart';
import 'package:melon_market/model/address_model.dart';
import 'package:melon_market/model/nearbyaddress_model.dart';
import 'package:melon_market/utils/logger.dart';

class AddressService {
  Future<AddressModel> searchAddressByStr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'type': 'ADDRESS',
      'category': 'ROAD',
      'query': text,
      'size': 30,
    };
    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError((e) {
      logger.e(e.message);
    });
    //logger.d(response);

    //logger.d(response.data["response"]['result ']);
    AddressModel adressModel = AddressModel.fromJson(response.data['response']);
    logger.d(response.data['response']);
    logger.d(adressModel);
    return adressModel;
  }

  Future<List<NearbyAddressModel>> findAddressByCoordinate(
      {required double log, required double lat}) async {
    final List<Map<String, dynamic>> formDatas = <Map<String, dynamic>>[];

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$log,$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${log - 0.01},$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${log + 0.01},$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$log,${lat - 0.01}',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$log,${lat + 0.01}',
    });

    List<NearbyAddressModel> nearbyadress = [];

    for (Map<String, dynamic> formData in formDatas) {
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        logger.e(e.message);
      });

      NearbyAddressModel nearbyaddressmodel =
          NearbyAddressModel.fromJson(response.data['response']);
      logger.d(response.data['response']);

      if (response.data['response']['status'] == 'OK') {
        nearbyadress.add(nearbyaddressmodel);
      }
    }
    logger.d(nearbyadress);
    return nearbyadress;
  }
}
