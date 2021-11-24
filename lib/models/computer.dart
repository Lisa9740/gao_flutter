
import 'package:gao_flutter/models/attribution.dart';

class Computer {
  var attributions;
  final int id;
  final String name;


  Computer({
    required this.id,
    required this.name,
    required this.attributions
  });

  //creating a dart user object from the json object
  factory Computer.fromJson(Map<String, dynamic> json) {
    return Computer(id: json['id'], name: json['name'], attributions: json['Attributions']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'attributions' : attributions
    };
  }

}