import 'package:agrargo/models/emailadress_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:build_runner/build_runner.dart';

///https://firebase.flutter.dev/docs/firestore-odm/defining-models
///https://firebase.flutter.dev/docs/firestore-odm/code-generation
@JsonSerializable()
class User {
  final String name;
  final bool landwirt;
  User({required this.name, required this.email, required this.landwirt});

  @EmailAddressValidator()
  final String email;
}
