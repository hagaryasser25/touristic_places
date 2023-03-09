import 'package:flutter/cupertino.dart';

class Replays {
  Replays({
    String? id,
    String? userUid,
    String? description,
    String? userComplain,
  }) {
    _id = id;
    _userUid = userUid;
    _description = description;
    _userComplain = userComplain;
  }

  Replays.fromJson(dynamic json) {
    _id = json['id'];
    _userUid = json['userUid'];
    _description = json['description'];
    _userComplain = json['userComplain'];
  }

  String? _id;
  String? _userUid;
  String? _description;
  String? _userComplain;

  String? get id => _id;
  String? get userUid => _userUid;
  String? get description => _description;
  String? get userComplain => _userComplain;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userUid'] = _userUid;
    map['description'] = _description;
    map['userComplain'] = _userComplain;

    return map;
  }
}