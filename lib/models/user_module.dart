import 'package:flutter/foundation.dart';

class UserModuleModel {
  final String idModulo;
  final String title;
  final String link;
  final String orden;
  final String icon;
  final String comentario;
  final String hasBadge;
  final String badgeText;

  UserModuleModel({
    @required this.idModulo,
    @required this.title,
    @required this.link,
    @required this.orden,
    @required this.icon,
    @required this.comentario,
    @required this.hasBadge,
    @required this.badgeText,
  });

  factory UserModuleModel.fromJson(Map<String, dynamic> json) {
    return UserModuleModel(
      idModulo: json['id_modulo'] as String,
      title: json['title'] as String,
      link: json['link'] as String,
      orden: json['orden'] as String,
      icon: json['icon'] as String,
      comentario: json['comentario'] as String,
      hasBadge: json['has_badge'] as String,
      badgeText: json['badge_text'] as String,
    );
  }

  @override
  String toString() {
    return """
    {
      "id_modulo": "${this.idModulo}", 
      "title" : "${this.title}", 
      "link" : "${this.link}", 
      "orden" : "${this.orden}",
      "icon" : "${this.icon}",
      "comentario" : "${this.comentario}",
      "has_badge" : "${this.hasBadge}",
      "badge_text" : "${this.badgeText}"
    }
    """;
  }
}
