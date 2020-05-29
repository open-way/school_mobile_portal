import 'package:flutter/foundation.dart';

class AppVersionModel {
  final String id;
  final String code;
  final String name;
  final String version;
  final String updateApp;
  final String url;
  final String platform;

  AppVersionModel({
    @required this.id,
    @required this.code,
    @required this.name,
    @required this.version,
    @required this.updateApp,
    @required this.url,
    @required this.platform,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      updateApp: json['update_app'] as String,
      url: json['url'] as String,
      platform: json['platform'] as String,
    );
  }
}
