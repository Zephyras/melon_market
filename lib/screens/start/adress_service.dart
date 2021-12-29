import 'package:dio/dio.dart';
import 'package:melon_market/constants/keys.dart';
import 'package:melon_market/model/address_model.dart';
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

  // Future<AddressModel> findAddressByCoordinate(Point point) async {
  //   final formData = {
  //     'key': VWORLD_KEY,
  //     'request': 'search',
  //     'type': 'ADDRESS',
  //     'category': 'ROAD',
  //     'query': text,
  //     'size': 30,
  //   };
  //
  //   final response = await Dio()
  //       .get('http://api.vworld.kr/req/search', queryParameters: formData)
  //       .catchError((e) {
  //     logger.e(e.message);
  //   });
  // }
}
