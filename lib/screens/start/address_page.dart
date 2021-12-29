import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:melon_market/constants/common_size.dart';
import 'package:melon_market/model/address_model.dart';
import 'package:melon_market/screens/start/adress_service.dart';
import 'package:melon_market/utils/logger.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel _addressModel = AddressModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: common_padding, right: common_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              _addressModel = await AddressService().searchAddressByStr(text);
              setState(() {});
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: '도로명으로 검색',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 24, minHeight: 24)),
          ),
          TextButton.icon(
            icon: Icon(
              CupertinoIcons.compass,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }

              _locationData = await location.getLocation();
              logger.d(_locationData);
            },
            label: Text(
              '현재 위치 찾기',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: common_padding),
              itemBuilder: (context, index) {
                if (_addressModel == null ||
                    _addressModel.result == null ||
                    _addressModel.result!.items == null ||
                    _addressModel.result!.items![index].address == null)
                  return Container();
                logger.d('index: $index');
                return ListTile(
                  leading: Icon(Icons.image),
                  trailing: Icon(Icons.clear),
                  title: Text(
                      _addressModel.result!.items![index].address!.road ?? ""),
                  subtitle: Text(
                      _addressModel.result!.items![index].address!.parcel ??
                          ""),
                );
              },
              itemCount: _addressModel == null ||
                      _addressModel.result == null ||
                      _addressModel.result!.items == null
                  ? 0
                  : _addressModel.result!.items!.length,
            ),
          )
        ],
      ),
    );
  }
}
