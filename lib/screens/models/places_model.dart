import 'package:flutter/cupertino.dart';

class Places {
  Places({
    String? id,
    String? area,
    String? description,
    String? name,
    String? imageUrl,
    String? price,
    String? governorate,
  }) {
    _id = id;
    _area = area;
    _description = description;
    _name = name;
    _imageUrl = imageUrl;
    _price = price;
    _governorate = governorate;
  }

  Places.fromJson(dynamic json) {
    _id = json['id'];
    _area = json['area'];
    _description = json['description'];
    _name = json['name'];
    _imageUrl = json['imageUrl'];
    _price = json['price'];
    _governorate = json['governorate'];
  }

  String? _id;
  String? _area;
  String? _description;
  String? _name;
  String? _imageUrl;
  String? _price;
  String? _governorate;

  String? get id => _id;
  String? get area => _area;
  String? get description => _description;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  String? get price => _price;
  String? get governorate => _governorate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['area'] = _area;
    map['description'] = _description;
    map['name'] = _name;
    map['imageUrl'] = _imageUrl;
    map['price'] = _price;
    map['governorate'] = _governorate;

    return map;
  }
}