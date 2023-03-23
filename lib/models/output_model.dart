import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OutputModel {
  String text;
  bool hasProfanity;
  String censored;
  OutputModel({
    required this.text,
    required this.hasProfanity,
    required this.censored,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hasProfanity': hasProfanity,
      'censored': censored,
    };
  }

  factory OutputModel.fromMap(Map<String, dynamic> map) {
    return OutputModel(
      text: map['original'] as String,
      hasProfanity: map['has_profanity'] as bool,
      censored: map['censored'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  // factory OutputModel.fromJson(String source) =>
  //     OutputModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory OutputModel.fromJson(Map<String, dynamic> json) {
    return OutputModel(
      text: json['original'],
      censored: json['censored'],
      hasProfanity: json['has_profanity'],
    );
  }
}
